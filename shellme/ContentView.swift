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
        List {
            ForEach(items) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text(String(item.amount))
                }
            }
        }
        HStack {

            Button(action: {
                print("Button Tapped")
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
        .sheet(isPresented: $isAddFormPresented) {
            CreateItemForm()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
