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
    @Binding var isLoading: Bool
    @Binding var name: String
    @Binding var price: String

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let controller = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .accurate,
            recognizesMultipleItems: false,
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
                self.parent.isLoading = true
                sendTextToAPI(text.transcript)
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

        private func sendTextToAPI(_ text: String) {
            guard
                let url = URL(
                    string:
                        "https://shellme-backend.seifuzi2064.workers.dev/api/parse-price-tag"
                )
            else {
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(
                "application/json", forHTTPHeaderField: "Content-Type")

            let requestBody: [String: Any] = ["text": text]
            request.httpBody = try? JSONSerialization.data(
                withJSONObject: requestBody)

            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                guard let data = data, error == nil else {
                    print(
                        "Request failed: \(error?.localizedDescription ?? "Unknown error")"
                    )
                    return
                }

                do {
                    let jsonResponse =
                        try JSONSerialization.jsonObject(
                            with: data, options: []) as? [String: Any]
                    if let name = jsonResponse?["name"] as? String,
                        let price = jsonResponse?["price"] as? NSNumber
                    {

                        DispatchQueue.main.async {
                            self.parent.name = name
                            self.parent.price = price.stringValue
                            self.parent.isLoading = false
                        }
                    }
                } catch {
                    print("JSON decoding failed: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.parent.isLoading = false
                    }
                }
            }
            task.resume()
        }
    }
}
