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
    var price: Int?
    
    init(name: String, amount: Int, price: Int? = nil) {
        self.name = name
        self.amount = amount
        self.price = price
    }

    @MainActor
    static let sampleData = [
        Item(name: "うまい棒", amount: 10,price: 11),
        Item(name: "うまい棒", amount: 300,price: 11),
        Item(name: "俺の脳内選択肢が学園ラブコメを全力で邪魔している", amount: 30000,price: 11),
    ]
}
