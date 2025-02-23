//
//  CreateItemForm.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/02.
//

import SwiftData
import SwiftUI

struct CreateItemForm: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var price: String = ""
    @FocusState var focus: Bool

    var body: some View {
        Form {
            RepresentableTextField(
                text: $name, placeholder: "商品", isFirstResponder: true
            )
            .focused(self.$focus)
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
            }
            .frame(maxWidth: .infinity)
        }
        .presentationDetents([.fraction(0.25)])
    }

    private func saveItem() {
        let item = Item(name: name, amount: Int(amount) ?? 1, price: Float(price))
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
