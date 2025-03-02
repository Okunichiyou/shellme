//
//  TotalPrice.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/25.
//

import SwiftData
import SwiftUI

struct TotalPrice: View {
    @Query() private var items: [Item]
    
    private var totalPrice: Int {
        let total: Float = items.reduce(0) { sum, item in
            if let price = item.price {
                return sum + (Float(item.amount) * price)
            }
            return sum
        }
        return Int(total)
    }

    var body: some View {
        Text("合計金額: \(totalPrice, format: .currency(code: "JPY"))")
            .font(.title2)
            .fontWeight(.bold)
    }
}

#Preview {
    TotalPrice()
        .modelContainer(SampleData.shared.modelContainer)
}
