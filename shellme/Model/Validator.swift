//
//  Validator.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/24.
//

import Foundation

protocol Validator {
    associatedtype ResultType: ValidationResult
    func validate() -> ResultType
}

extension Validator {
    func isValid() -> Bool { validate().isOk }
}

protocol ValidationResult {
    var isOk: Bool { get }
    var errorMessage: String? { get }
}

extension ValidationResult {
    var isNg: Bool { !isOk }
}
