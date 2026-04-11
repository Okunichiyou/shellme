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
    @Binding var errorMessage: String?

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let controller = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .accurate,
            recognizesMultipleItems: true,
            isPinchToZoomEnabled: true,
            isHighlightingEnabled: true
        )

        controller.delegate = context.coordinator

        return controller
    }

    func updateUIViewController(
        _ uiViewController: DataScannerViewController,
        context: Context
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
        private var recognizedTexts: [RecognizedItem.Text] = []
        private var scanTimer: Timer?
        private let priceTagService = PriceTagService()

        init(_ parent: DataScanner) {
            self.parent = parent
        }

        func dataScanner(
            _ dataScanner: DataScannerViewController,
            didUpdate updatedItems: [RecognizedItem],
            allItems: [RecognizedItem]
        ) {
            // 認識されたテキストをキャッシュ
            recognizedTexts = allItems.compactMap { item in
                if case .text(let text) = item {
                    return text
                }
                return nil
            }

            // タイマーが未設定の場合のみ、スキャン開始から1秒後にAPIを呼び出す
            if scanTimer == nil && parent.currentStep == .scanning {
                scanTimer = Timer.scheduledTimer(
                    withTimeInterval: 1.0,
                    repeats: false
                ) { [weak self] _ in
                    self?.processRecognizedTexts()
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

        private func processRecognizedTexts() {
            guard !recognizedTexts.isEmpty else { return }

            // TextItem配列に変換（座標付き）
            let items = recognizedTexts.map { text -> TextItem in
                let bounds = text.bounds
                return TextItem(
                    text: text.transcript,
                    boundingBox: BoundingBox(
                        x: bounds.topLeft.x,
                        y: bounds.topLeft.y,
                        width: bounds.topRight.x - bounds.topLeft.x,
                        height: bounds.bottomLeft.y - bounds.topLeft.y
                    )
                )
            }
            
            print(items)

            // APIを呼び出し
            Task { @MainActor in
                do {
                    let response = try await priceTagService.parsePriceTag(
                        items: items
                    )

                    // レスポンスをバインディングに設定
                    parent.name = response.name
                    parent.price = String(response.price)
                    parent.currentStep = .completed
                    parent.isScanning = false
                    parent.errorMessage = nil

                } catch let error as PriceTagServiceError {
                    // オフラインエラーなどを表示
                    parent.errorMessage = error.localizedDescription
                    parent.isScanning = false

                } catch {
                    parent.errorMessage =
                        "エラーが発生しました: \(error.localizedDescription)"
                    parent.isScanning = false
                }
            }
        }
    }
}
