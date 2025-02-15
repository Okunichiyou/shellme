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
    @Bindable var item: Item
    @FocusState var focus: Bool

    var body: some View {
        Form {
            RepresentableTextField(
                text: $item.name, placeholder: "商品"
            )
            .padding(.vertical)
            RepresentableTextField(
                text: Binding(
                    get: { String(item.amount) },
                    set: { item.amount = Int($0) ?? 0 }
                ),
                placeholder: "個数",
                keyboardType: .numberPad
            )
            .padding(.vertical)
            RepresentableTextField(
                text: Binding(
                    get: { item.price.map(String.init) ?? "" },
                    set: { item.price = Int($0) }
                ),
                placeholder: "Price (optional)",
                keyboardType: .numberPad
            )
            .padding(.vertical)
            Button("保存") {
                dismiss()
            }
            .frame(maxWidth: .infinity)
        }
        .presentationDetents([.fraction(0.45)])
    }
}

#Preview {
    EditItemForm(item: SampleData.shared.item)
}
