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
                                    destination: EditItemView(item: item)
                                ) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack(alignment: .center) {
                                            Text(item.name)
                                                .font(.headline)
                                                .foregroundColor(
                                                    item.isChecked
                                                        ? .gray : .primary
                                                )
                                                .strikethrough(
                                                    item.isChecked, color: .gray
                                                )
                                                .lineLimit(1)

                                            Spacer()

                                            Button(action: {
                                                toggleCheck(item: item)
                                            }) {
                                                HStack(spacing: 6) {
                                                    Image(
                                                        systemName: item
                                                            .isChecked
                                                            ? "checkmark.square.fill"
                                                            : "square"
                                                    )
                                                    .font(.system(size: 18))
                                                    Text(
                                                        item.isChecked
                                                            ? "カート追加済み"
                                                            : "カート未追加")
                                                }
                                                .font(.caption)
                                                .foregroundColor(
                                                    item.isChecked
                                                        ? .gray : .pink)
                                            }
                                            .buttonStyle(.plain)
                                        }

                                        HStack(spacing: 16) {
                                            Label {
                                                Text("\(item.amount)個")
                                                    .foregroundColor(
                                                        item.isChecked
                                                            ? .gray
                                                            : .secondary
                                                    )
                                            } icon: {
                                                Image(
                                                    systemName:
                                                        "shippingbox"
                                                )
                                                .foregroundColor(
                                                    item.isChecked
                                                        ? .gray : .pink)
                                            }
                                            .font(.subheadline)

                                            Label {
                                                if let price = item.price {
                                                    Text(
                                                        "\(price, format: .currency(code: "JPY"))"
                                                    )
                                                    .foregroundColor(
                                                        item.isChecked
                                                            ? .gray
                                                            : .secondary
                                                    )
                                                } else {
                                                    Text("-")
                                                        .foregroundColor(
                                                            item.isChecked
                                                                ? .gray
                                                                : .secondary
                                                        )
                                                }
                                            } icon: {
                                                Image(
                                                    systemName:
                                                        "yensign.circle"
                                                )
                                                .foregroundColor(
                                                    item.isChecked
                                                        ? .gray : .pink)
                                            }
                                            .font(.subheadline)

                                            Spacer()
                                        }
                                    }
                                    .padding(.vertical, 4)
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
                    NavigationLink(destination: SettingsView()) {
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
            CreateItemView()
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
