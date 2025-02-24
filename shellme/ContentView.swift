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
    @Query(sort: \Item.createdAt, order: .reverse) private var items: [Item]
    @State private var isAddFormPresented = false
    @State private var isAllDeleteDialogPresented = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    TotalPrice()

                    ZStack {
                        List {
                            ForEach(items) { item in
                                NavigationLink(
                                    destination: EditItemForm(item: item)
                                ) {
                                    HStack {
                                        Text(item.name)
                                            .frame(
                                                maxWidth: .infinity,
                                                alignment: .leading)

                                        Text(String(item.amount))
                                            .frame(
                                                width: 30, alignment: .trailing)

                                        if let price = item.price {
                                            Text(
                                                "\(price, format: .currency(code: "JPY"))"
                                            )
                                            .frame(
                                                width: 100, alignment: .trailing
                                            )
                                        } else {
                                            Text("-")
                                                .frame(
                                                    width: 100,
                                                    alignment: .trailing)
                                        }
                                    }
                                }
                            }
                            .onDelete(perform: deleteItems(indexes:))
                        }
                        .scrollContentBackground(.hidden)
                        .safeAreaInset(edge: .bottom) {
                            Color.clear.frame(height: 80)
                        }

                        VStack {
                            Spacer()
                            HStack {
                                NavigationLink(destination: ScannerView()) {
                                    Image(systemName: "camera")
                                }
                                .secondaryCircleButton(size: .xlarge)

                                Spacer()

                                Button(action: {
                                    isAddFormPresented.toggle()
                                }) {
                                    Image(systemName: "plus")
                                }
                                .primaryCircleButton(size: .xlarge)
                            }
                            .padding(.bottom, 20)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        isAllDeleteDialogPresented = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .alert("すべてのアイテムを削除しますか？", isPresented: $isAllDeleteDialogPresented) {
                Button("キャンセル", role: .cancel) {}
                Button("削除", role: .destructive) {
                    deleteAllItems()
                }
            } message: {
                Text("この操作は元に戻せません。")
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
