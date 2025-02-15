//
//  ContentView.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/01/19.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var isAddFormPresented = false
    @State private var isAllDeleteDialogPresented = false

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(items) { item in
                        NavigationLink(destination: EditItemForm(item: item)) {
                            HStack {
                                Text(item.name)
                                    .frame(
                                        maxWidth: .infinity, alignment: .leading
                                    )

                                Text(String(item.amount))
                                    .frame(width: 30, alignment: .trailing)

                                if let price = item.price {
                                    Text(
                                        "\(price, format: .currency(code: "JPY"))"
                                    )
                                    .frame(width: 100, alignment: .trailing)
                                } else {
                                    Text("-")
                                        .frame(width: 100, alignment: .trailing)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteItems(indexes:))
                }

                VStack {
                    Spacer()

                    HStack {
                        Button(action: {
                            isAllDeleteDialogPresented = true
                        }) {
                            Image(systemName: "trash")
                        }
                        .dangerCircleButton(size: .xlarge)
                        .confirmationDialog(
                            "全商品の削除", isPresented: $isAllDeleteDialogPresented, titleVisibility: .visible
                        ) {
                            Button("削除", role: .destructive) {
                                deleteAllItems()
                            }
                            Button("キャンセル", role: .cancel) {
                                isAllDeleteDialogPresented = false
                            }
                        } message: {
                            Text("リスト内の全ての商品が削除されます。削除したデータは戻りません。")
                        }

                        Spacer()

                        Button(action: {
                            isAddFormPresented.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                        .primaryCircleButton(size: .xlarge)
                    }
                    .background(.clear)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .sheet(isPresented: $isAddFormPresented) {
            CreateItemForm()
        }
    }

    private func deleteItems(indexes: IndexSet) {
        for index in indexes {
            modelContext.delete(items[index])
        }
    }

    private func deleteAllItems() {
        for item in items {
            modelContext.delete(item)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
