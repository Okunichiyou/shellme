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
                Text("個数")
                    .font(.caption)
                    .foregroundStyle(.gray)
                RepresentableTextField(
                    text: $amount, placeholder: "個数", keyboardType: .numberPad
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
        .presentationDetents([.fraction(0.4)])
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
            resetForm()
        }
    }

    private func saveItem() {
        let item = Item(
            name: name, amount: Int(amount) ?? 1, price: Float(price))
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
