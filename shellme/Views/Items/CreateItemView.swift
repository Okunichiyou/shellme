//
//  CreateItemForm.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/02.
//

import SwiftUI

struct CreateItemView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var price: String = ""

    var body: some View {
        ItemFormView(
            name: $name,
            amount: $amount,
            price: $price,
            isFirstResponder: true,
            onSave: saveItem
        )
    }

    private func saveItem() {
        let item = Item(name: name, amount: Int(amount)!, price: Float(price))
        modelContext.insert(item)
        resetForm()
    }

    private func resetForm() {
        name = ""
        amount = ""
        price = ""
    }
}

#Preview {
    CreateItemView()
}
