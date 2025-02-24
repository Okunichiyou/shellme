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

    init(item: Item) {
        self.item = item
        _name = State(initialValue: item.name)
        _amount = State(initialValue: String(item.amount))
        _price = State(initialValue: item.price.map { String($0) } ?? "")
    }

    var body: some View {
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
                    text: $name,
                    placeholder: "商品名"
                )
                .focused(self.$focus)
            }

            VStack(alignment: .leading) {
                Text("個数")
                    .font(.caption)
                    .foregroundStyle(.gray)

                RepresentableTextField(
                    text: $amount,
                    placeholder: "個数",
                    keyboardType: .numberPad
                )
            }

            VStack(alignment: .leading) {
                Text("値段")
                    .font(.caption)
                    .foregroundStyle(.gray)

                RepresentableTextField(
                    text: $price,
                    placeholder: "値段",
                    keyboardType: .decimalPad
                )
            }

            Button("保存") {
                validateAndSave()
            }
            .frame(maxWidth: .infinity)
        }
        .presentationDetents([.fraction(0.45)])
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
            saveChanges()
            dismiss()
        }
    }

    private func saveChanges() {
        item.name = name
        item.amount = Int(amount) ?? 0
        item.price = Float(price) ?? nil
    }
}

#Preview {
    EditItemForm(item: SampleData.shared.item)
}
