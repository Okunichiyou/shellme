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
            VStack(alignment: .leading) {
                Text("商品名")
                    .font(.caption)
                    .foregroundStyle(.gray)

                RepresentableTextField(
                    text: $item.name, placeholder: "商品"
                )
            }

            VStack(alignment: .leading) {
                Text("個数")
                    .font(.caption)
                    .foregroundStyle(.gray)

                RepresentableTextField(
                    text: Binding(
                        get: { String(item.amount) },
                        set: { item.amount = Int($0) ?? 0 }
                    ),
                    placeholder: "個数",
                    keyboardType: .numberPad
                )
            }

            VStack(alignment: .leading) {
                Text("値段")
                    .font(.caption)
                    .foregroundStyle(.gray)

                RepresentableTextField(
                    text: Binding(
                        get: { item.price.map { String($0) } ?? "" },
                        set: { item.price = Float($0) }
                    ),
                    placeholder: "値段",
                    keyboardType: .decimalPad
                )
            }

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
