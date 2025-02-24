//
//  ItemAmountValidator.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/24.
//

import Foundation

struct ItemAmountValidator: Validator {
    let amount: String

    enum Result: ValidationResult {
        case none
        case required(String)
        case isNotNumber(String)
        case isLessThanOne(String)

        var isOk: Bool {
            if case .none = self { return true } else { return false }
        }
    }

    func validate() -> Result {
        if amount.isEmpty {
            return .required("個数が入力されていません")
        }
        
        guard let intAmount = Int(amount) else {
            return .isNotNumber("個数は半角で、整数値を入力してください")
        }
        
        if intAmount < 1 {
            return .isLessThanOne("個数は1以上の整数入力してください")
        }

        return .none
    }
}
