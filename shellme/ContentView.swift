//
//  ContentView.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/01/19.
//

import AppTrackingTransparency
import GoogleMobileAds
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.createdAt, order: .reverse) private var items: [Item]
    @State private var isAddFormPresented = false
    @State private var isAllDeleteDialogPresented = false

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemPink

        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        appearance.backButtonAppearance = backButtonAppearance

        let backImage = UIImage(systemName: "chevron.backward")?.withTintColor(
            .white, renderingMode: .alwaysOriginal)
        appearance.setBackIndicatorImage(
            backImage, transitionMaskImage: backImage)

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    TotalPrice()
                        .padding(.top, 20)

                    ZStack {
                        List {
                            ForEach(items) { item in
                                NavigationLink(
                                    destination: EditItemForm(item: item)
                                ) {
                                    HStack {

                                        Button(action: {
                                            toggleCheck(item: item)
                                        }) {
                                            Image(
                                                systemName: item.isChecked
                                                    ? "checkmark.circle.fill"
                                                    : "circle"
                                            )
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(
                                                item.isChecked ? .gray : .pink)
                                        }
                                        .contentShape(Rectangle())
                                        .buttonStyle(.plain)

                                        Text(item.name)
                                            .foregroundColor(
                                                item.isChecked
                                                    ? .gray : .primary
                                            )
                                            .strikethrough(
                                                item.isChecked, color: .gray
                                            )
                                            .frame(
                                                maxWidth: .infinity,
                                                alignment: .leading)

                                        Text(String(item.amount))
                                            .foregroundColor(
                                                item.isChecked
                                                    ? .gray : .primary
                                            )
                                            .strikethrough(
                                                item.isChecked, color: .gray
                                            )
                                            .frame(
                                                width: 30, alignment: .trailing)

                                        if let price = item.price {
                                            Text(
                                                "\(price, format: .currency(code: "JPY"))"
                                            )
                                            .foregroundColor(
                                                item.isChecked
                                                    ? .gray : .primary
                                            )
                                            .strikethrough(
                                                item.isChecked, color: .gray
                                            )
                                            .frame(
                                                width: 100, alignment: .trailing
                                            )
                                        } else {
                                            Text("-")
                                                .foregroundColor(
                                                    item.isChecked
                                                        ? .gray : .primary
                                                )
                                                .strikethrough(
                                                    item.isChecked, color: .gray
                                                )
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
                    BannerAdView()
                        .frame(width: 320, height: 50)
                }
            }
            .toolbarBackground(Color.pink, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(role: .destructive) {
                        isAllDeleteDialogPresented = true
                    } label: {
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingView()) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                }
            }
            .alert("すべてのアイテムを削除しますか？", isPresented: $isAllDeleteDialogPresented)
            {
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
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.didBecomeActiveNotification)
        ) { _ in
            OperationQueue.main.addOperation {
                ATTrackingManager.requestTrackingAuthorization(
                    completionHandler: {
                        _ in
                    })
            }
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

    private func toggleCheck(item: Item) {
        item.isChecked.toggle()
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
