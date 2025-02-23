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
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var price: String = ""
    @State private var currentStep: ScanStep = .nameStep
    @State private var isHighlighted: Bool = false

    var body: some View {
        VStack {
            Text(stepMessage)
                .foregroundColor(isHighlighted ? .yellow : .primary)
                .animation(.easeInOut(duration: 0.5), value: isHighlighted)

            DataScanner(
                isScanning: $isScanning,
                isShowAlert: $isShowAlert,
                name: $name,
                price: $price,
                currentStep: $currentStep
            )

            Form {
                RepresentableTextField(
                    text: $name, placeholder: "商品"
                )
                RepresentableTextField(
                    text: $amount, placeholder: "個数", keyboardType: .numberPad
                )
                RepresentableTextField(
                    text: $price, placeholder: "Price (optional)",
                    keyboardType: .decimalPad
                )
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
        .onAppear {
            highlightStepMessage()
        }
        .onChange(of: currentStep) {
            highlightStepMessage()
        }
    }

    private func saveItem() {
        let item = Item(name: name, amount: Int(amount) ?? 1, price: Float(price))
        modelContext.insert(item)
    }

    private func resetForm() {
        name = ""
        amount = ""
        price = ""
    }
    
    private var stepMessage: String {
        switch currentStep {
        case .nameStep:
            return "商品名をタップしてください"
        case .priceStep:
            return "税込の値段をタップしてください"
        case .completed:
            return "入力内容を確認し、保存してください"
        }
    }

    private func highlightStepMessage() {
        isHighlighted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isHighlighted = false
        }
    }
}

#Preview {
    ScannerView()
}
