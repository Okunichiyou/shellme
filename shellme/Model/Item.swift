//
//  Item.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/01/19.
//

import Foundation
import SwiftData

@Model
final class Item {
    var name: String
    var amount: Int
    var price: Float?
    var createdAt: Date
    var isChecked: Bool

    init(name: String, amount: Int, price: Float? = nil, isChecked: Bool = false) {
        self.name = name
        self.amount = amount
        self.price = price
        self.createdAt = Date()
        self.isChecked = isChecked
    }

    @MainActor
    static let sampleData = [
        Item(name: "うまい棒", amount: 10, price: 11),
        Item(name: "値段未定の商品", amount: 30),
        Item(name: "俺の脳内選択肢が学園ラブコメを全力で邪魔している", amount: 5, price: 800),
        Item(name: "ゲーミングチェア", amount: 4, price: 50000),
        Item(name: "MyGO!!!!! CD", amount: 1, price: 1000),
        Item(name: "ご注文はうさぎですか?", amount: 3, price: 1000),
        Item(name: "極黒のブリュンヒルデ", amount: 3, price: 500),
        Item(name: "夜桜四重奏", amount: 20, price: 1000),
        Item(name: "嘘つきみーくんと壊れたまーちゃん", amount: 3),
        Item(name: "左ききのエレン", amount: 3, price: 1000),
        Item(name: "聲の形", amount: 30000, price: 1000),
        Item(name: "All You Need Is Kill", amount: 3, price: 10000),
        Item(name: "﷽﷽﷽", amount: 3, price: 10000),
        Item(name: "小数点の値段", amount: 3, price: 100.11)
    ]
}
