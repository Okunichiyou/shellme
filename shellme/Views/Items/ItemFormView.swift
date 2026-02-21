//
//  ItemFormView.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/21.
//

import SwiftUI

/// アイテムのフォーム表示と入力検証を行う共通ビュー
struct ItemFormView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var name: String
    @Binding var amount: String
    @Binding var price: String

    @State private var nameError: String?
    @State private var amountError: String?
    @State private var priceError: String?

    @FocusState var focus: Bool

    let isFirstResponder: Bool
    let onSave: () -> Void

    init(
        name: Binding<String>,
        amount: Binding<String>,
        price: Binding<String>,
        isFirstResponder: Bool = false,
        onSave: @escaping () -> Void
    ) {
        self._name = name
        self._amount = amount
        self._price = price
        self.isFirstResponder = isFirstResponder
        self.onSave = onSave
    }

    var body: some View {
        TotalPrice()
            .padding(.top, 20)

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
                    text: $name,
                    placeholder: "商品名",
                    isFirstResponder: isFirstResponder
                )
                .focused(self.$focus)
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
                    text: $amount,
                    placeholder: "個数",
                    keyboardType: .numberPad
                )
            }

            VStack(alignment: .leading) {
                Text("値段").font(.caption).foregroundStyle(.gray)

                if let priceError {
                    Text(priceError).font(.caption).foregroundColor(.red)
                }

                RepresentableTextField(
                    text: $price,
                    placeholder: "値段",
                    keyboardType: .decimalPad
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

    private func validateAndSave() {
        let nameHasError = validateName()
        let amountHasError = validateAmount()
        let priceHasError = validatePrice()

        if nameHasError || amountHasError || priceHasError {
            return
        }

        onSave()
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
}

#Preview {
    @Previewable @State var name = ""
    @Previewable @State var amount = ""
    @Previewable @State var price = ""

    ItemFormView(
        name: $name,
        amount: $amount,
        price: $price,
        isFirstResponder: true,
        onSave: {
            print("保存: \(name), \(amount), \(price)")
        }
    )
}
