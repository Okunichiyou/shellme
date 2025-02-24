//
//  ItemPriceValidator.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/24.
//

import Foundation

struct ItemPriceValidator: Validator {
    let price: String

    enum Result: ValidationResult {
        case none
        case isNotNumber(String)

        var isOk: Bool {
            if case .none = self { return true } else { return false }
        }

        var errorMessage: String? {
            switch self {
            case .none: return nil
            case .isNotNumber(let msg):
                return msg
            }
        }
    }

    func validate() -> Result {
        if price.isEmpty {
            return .none
        }

        if Float(price) == nil {
            return .isNotNumber("値段には数字を入力してください")
        }

        return .none
    }
}
