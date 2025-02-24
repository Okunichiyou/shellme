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
    @State private var nameError: String?

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
                VStack(alignment: .leading) {
                    Text("商品名")
                        .font(.caption)
                        .foregroundStyle(.gray)

                    if let nameError {
                        Text(nameError)
                            .font(.caption)
                            .foregroundColor(.red)
                    }

                    RepresentableTextField(
                        text: $name, placeholder: "商品"
                    )
                }

                VStack(alignment: .leading) {
                    Text("個数")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    RepresentableTextField(
                        text: $amount, placeholder: "個数",
                        keyboardType: .numberPad
                    )
                }

                VStack(alignment: .leading) {
                    Text("値段")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    RepresentableTextField(
                        text: $price, placeholder: "値段",
                        keyboardType: .decimalPad
                    )
                }

                Button("保存") {
                    validateAndSave()
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

    private func validateAndSave() {
        let validator = ItemNameValidator(name: name)
        let result = validator.validate()

        switch result {
        case .required(let message):
            nameError = message
            return
        case .none:
            nameError = nil
            saveItem()
            dismiss()
        }
    }

    private func saveItem() {
        let item = Item(
            name: name, amount: Int(amount) ?? 1, price: Float(price))
        modelContext.insert(item)
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
