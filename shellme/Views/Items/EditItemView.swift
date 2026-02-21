//
//  EditItemForm.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/09.
//

import SwiftUI

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss

    var item: Item

    @State private var name: String
    @State private var amount: String
    @State private var price: String

    init(item: Item) {
        self.item = item
        _name = State(initialValue: item.name)
        _amount = State(initialValue: String(item.amount))
        _price = State(initialValue: item.price.map { String($0) } ?? "")
    }

    var body: some View {
        ItemFormView(
            name: $name,
            amount: $amount,
            price: $price,
            isFirstResponder: false,
            onSave: saveChanges
        )
        .presentationDetents([.fraction(0.45)])
    }

    private func saveChanges() {
        item.name = name
        item.amount = Int(amount)!
        item.price = Float(price) ?? nil
        dismiss()
    }
}

#Preview {
    EditItemView(item: SampleData.shared.item)
}
