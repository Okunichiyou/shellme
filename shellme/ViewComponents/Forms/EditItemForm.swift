//
//  EditItemForm.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/09.
//

import SwiftUI

struct EditItemForm: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var item: Item
    @FocusState var focus: Bool

    @State private var name: String
    @State private var amount: String
    @State private var price: String
    @State private var nameError: String?
    @State private var amountError: String?
    @State private var priceError: String?

    init(item: Item) {
        self.item = item
        _name = State(initialValue: item.name)
        _amount = State(initialValue: String(item.amount))
        _price = State(initialValue: item.price.map { String($0) } ?? "")
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
                    placeholder: "商品名"
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
        .presentationDetents([.fraction(0.45)])
    }

    private func validateAndSave() {
        let nameHasError = validateName()
        let amountHasError = validateAmount()
        let priceHasError = validateAmount()

        if nameHasError || amountHasError || priceHasError {
            return
        }

        saveChanges()
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

    private func saveChanges() {
        item.name = name
        item.amount = Int(amount)!
        item.price = Float(price) ?? nil
    }
}

#Preview {
    EditItemForm(item: SampleData.shared.item)
}
