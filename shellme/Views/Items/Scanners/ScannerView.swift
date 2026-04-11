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
    @State private var currentStep: ScanStep = .scanning
    @State private var nameError: String?
    @State private var amountError: String?
    @State private var priceError: String?
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                if isScanning {
                    DataScanner(
                        isScanning: $isScanning,
                        isShowAlert: $isShowAlert,
                        name: $name,
                        price: $price,
                        currentStep: $currentStep,
                        errorMessage: $errorMessage
                    )
                } else {
                    ZStack {
                        Color(.systemGray5)

                        Button(action: {
                            isScanning = true
                            currentStep = .scanning
                            errorMessage = nil
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 32))
                                Text("撮り直す")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.pink)
                        }
                    }
                }

                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: stepIcon)
                            .font(.system(size: 16, weight: .semibold))
                        Text(stepMessage)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.pink.opacity(0.9))
                            .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                    )

                    if let errorMessage {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 14))
                            Text(errorMessage)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.red.opacity(0.9))
                                .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                        )
                    }
                }
                .padding(.top, 16)
                .animation(.easeInOut(duration: 0.3), value: errorMessage)
            }
            .frame(maxHeight: 250)

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
        currentStep = .scanning
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
        case .scanning:
            return "値札を映してください"
        case .completed:
            return "個数を入力し、保存してください"
        }
    }

    private var stepIcon: String {
        switch currentStep {
        case .scanning:
            return "viewfinder"
        case .completed:
            return "checkmark.circle.fill"
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
