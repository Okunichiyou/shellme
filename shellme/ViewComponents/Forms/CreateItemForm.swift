//
//  CreateItemForm.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/02.
//

import SwiftUI

struct CreateItemForm: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var price: String = ""
    @State private var nameError: String?
    @State private var amountError: String?
    @State private var priceError: String?

    @FocusState var focus: Bool

    var body: some View {
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
                    text: $name, placeholder: "商品名", isFirstResponder: true
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
                    text: $amount, placeholder: "個数", keyboardType: .numberPad
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

            Button("保存") {
                validateAndSave()
            }
            .frame(maxWidth: .infinity)
        }
        .presentationDetents([.fraction(0.4)])
    }

    private func validateAndSave() {
        let nameHasError = validateName()
        let amountHasError = validateAmount()
        let priceHasError = validatePrice()

        if nameHasError || amountHasError || priceHasError {
            return
        }

        saveItem()
        resetForm()
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

    private func resetForm() {
        name = ""
        amount = ""
        price = ""

        self.focus = true
    }
}

#Preview {
    CreateItemForm()
}
