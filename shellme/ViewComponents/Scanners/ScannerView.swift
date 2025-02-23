//
//  ScannerView.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/16.
//

import SwiftData
import SwiftUI

struct ScannerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var isScanning: Bool = false
    @State private var isShowAlert: Bool = false
    @State private var isLoading: Bool = false
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var price: String = ""

    var body: some View {
        VStack {
            DataScanner(
                isScanning: $isScanning,
                isShowAlert: $isShowAlert,
                isLoading: $isLoading,
                name: $name,
                price: $price
            )

            if isLoading {
                ProgressView("読み込み中...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }

            Form {
                RepresentableTextField(
                    text: $name, placeholder: "商品"
                )
                .padding(.vertical)
                RepresentableTextField(
                    text: $amount, placeholder: "個数", keyboardType: .numberPad
                )
                .padding(.vertical)
                RepresentableTextField(
                    text: $price, placeholder: "Price (optional)",
                    keyboardType: .numberPad
                )
                .padding(.vertical)
                Button("保存") {
                    saveItem()
                    resetForm()
                    dismiss()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .task {
            isScanning.toggle()
        }
    }

    private func saveItem() {
        let item = Item(name: name, amount: Int(amount) ?? 1, price: Int(price))
        modelContext.insert(item)
    }

    private func resetForm() {
        name = ""
        amount = ""
        price = ""
    }
}

#Preview {
    ScannerView()
}
