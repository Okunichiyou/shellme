//
//  DataScanner.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/16.
//

import Foundation
import SwiftUI
import VisionKit

struct DataScanner: UIViewControllerRepresentable {
    @Binding var isScanning: Bool
    @Binding var isShowAlert: Bool
    @Binding var name: String
    @Binding var price: String
    @Binding var currentStep: ScanStep

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let controller = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .accurate,
            recognizesMultipleItems: true,
            isPinchToZoomEnabled: true,
            isHighlightingEnabled: true)

        controller.delegate = context.coordinator

        return controller
    }

    func updateUIViewController(
        _ uiViewController: DataScannerViewController, context: Context
    ) {
        if isScanning {
            do {
                try uiViewController.startScanning()

            } catch (let error) {
                print(error)
            }

        } else {
            uiViewController.stopScanning()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: DataScanner

        init(_ parent: DataScanner) {
            self.parent = parent
        }

        func dataScanner(
            _ dataScanner: DataScannerViewController,
            didTapOn item: RecognizedItem
        ) {
            if case .text(let text) = item {
                switch parent.currentStep {
                case .nameStep:
                    parent.name = text.transcript
                    parent.currentStep = .priceStep
                case .priceStep:
                    let extractedPrice = extractTaxIncludedPrice(text.transcript)
                    parent.price = extractedPrice
                    parent.isScanning = false
                    parent.currentStep = .completed
                case .completed:
                    break
                }
            }

        }

        func dataScanner(
            _ dataScanner: DataScannerViewController,
            becameUnavailableWithError error: DataScannerViewController
                .ScanningUnavailable
        ) {
            switch error {
            case .cameraRestricted:
                print("カメラの使用を許可してください。")
                parent.isShowAlert = true

            case .unsupported:
                print("このデバイスをはサポートされていません。")

            default:
                print(error.localizedDescription)
            }
        }
        
        private func extractTaxIncludedPrice(_ text: String) -> String {
            let patterns = [
                #"税込[^\d]*(\d+[,.]?\d*)"#,
                #"総額[^\d]*(\d+[,.]?\d*)"#,
                #"内税[^\d]*(\d+[,.]?\d*)"#,
                #"[^\d]*(\d+[,.]?\d*)"# // 税込表記がない場合でも数字をタップしていた場合は入力されるようにしておく
            ]

            for pattern in patterns {
                if let match = text.range(of: pattern, options: .regularExpression) {
                    let matchedText = String(text[match])
                    if let numberMatch = matchedText.range(of: #"\d+[,.]?\d*"#, options: .regularExpression) {
                        return String(matchedText[numberMatch])
                    }
                }
            }

            return text // 見つからなかった場合は元のテキストを返す
        }
    }
}
