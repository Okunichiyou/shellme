//
//  ItemNameValidator.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/24.
//

import Foundation

struct ItemNameValidator: Validator {
    let name: String

    enum Result: ValidationResult {
        case none
        case required(String)

        var isOk: Bool {
            if case .none = self { return true } else { return false }
        }
    }

    func validate() -> Result {
        if name.isEmpty {
            return .required("商品名が入力されていません")
        }

        return .none
    }
}
