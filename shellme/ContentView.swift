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
                }

                VStack {
                    Spacer()

                    HStack {
                        Button(action: {
                            print("Trash button tapped")
                        }) {
                            Image(systemName: "trash")
                        }
                        .dangerCircleButton(size: .xlarge)

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
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
