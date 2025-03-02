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

    @State private var isScanning: Bool = true
    @State private var isShowAlert: Bool = false
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var price: String = ""
    @State private var currentStep: ScanStep = .nameStep
    @State private var isHighlighted: Bool = false
    @State private var nameError: String?
    @State private var amountError: String?
    @State private var priceError: String?

    var body: some View {
        VStack {
            if isScanning {
                DataScanner(
                    isScanning: $isScanning,
                    isShowAlert: $isShowAlert,
                    name: $name,
                    price: $price,
                    currentStep: $currentStep
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            } else {
                EmptyView()
            }

            Text(stepMessage)
                .multilineTextAlignment(.center)
                .foregroundColor(isHighlighted ? .yellow : .primary)
                .animation(.easeInOut(duration: 0.5), value: isHighlighted)

            Form {
                VStack(alignment: .leading) {
                    HStack {
                        Text("商品名").font(.caption).foregroundStyle(.gray)
                        Text("*").foregroundColor(.red)
                    }

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
                    Text("値段").font(.caption).foregroundStyle(.gray)

                    if let priceError {
                        Text(priceError).font(.caption).foregroundColor(.red)
                    }

                    RepresentableTextField(
                        text: $price, placeholder: "値段",
                        keyboardType: .decimalPad
                    )
                }

                VStack(alignment: .leading) {
                    HStack {
                        Text("個数").font(.caption).foregroundStyle(.gray)
                        Text("*").foregroundColor(.red)
                    }

                    if let amountError {
                        Text(amountError).font(.caption).foregroundColor(.red)
                    }

                    RepresentableTextField(
                        text: $amount, placeholder: "個数",
                        keyboardType: .numberPad
                    )
                }

                HStack {
                    Button("キャンセル") {
                        dismiss()
                    }
                    .buttonStyle(TertiaryButtonStyle(size: .medium))

                    Button("保存") {
                        validateAndSave()
                    }
                    .buttonStyle(PrimaryButtonStyle(size: .medium))
                }
            }
        }
        .onAppear {
            highlightStepMessage()
        }
        .onChange(of: currentStep) {
            highlightStepMessage()
        }
        .animation(.easeInOut(duration: 0.5), value: isScanning)
    }

    private func validateAndSave() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil,
            for: nil)

        let nameHasError = validateName()
        let amountHasError = validateAmount()
        let priceHasError = validatePrice()

        if nameHasError || amountHasError || priceHasError {
            return
        }

        saveItem()
        resetForm()
        isScanning = true
        currentStep = .nameStep
    }

    private func validateName() -> Bool {
        let nameValidator = ItemNameValidator(name: name)
        let nameResult = nameValidator.validate()

        nameError = nameResult.errorMessage
        return nameResult.isNg
    }

    private func validateAmount() -> Bool {
        let amountValidator = ItemAmountValidator(amount: amount)
        let amountResult = amountValidator.validate()

        amountError = amountResult.errorMessage
        return amountResult.isNg
    }

    private func validatePrice() -> Bool {
        let priceValidator = ItemPriceValidator(price: price)
        let priceResult = priceValidator.validate()

        priceError = priceResult.errorMessage
        return priceResult.isNg
    }

    private func saveItem() {
        let item = Item(name: name, amount: Int(amount)!, price: Float(price))
        modelContext.insert(item)
    }

    private var stepMessage: String {
        switch currentStep {
        case .nameStep:
            return "文字にハイライトが出たら、商品名をタップしてください"
        case .priceStep:
            return "文字にハイライトが出たら、税込の値段をタップしてください"
        case .completed:
            return "個数を入力し、入力内容の確認をした後、保存してください"
        }
    }

    private func highlightStepMessage() {
        isHighlighted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isHighlighted = false
        }
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
