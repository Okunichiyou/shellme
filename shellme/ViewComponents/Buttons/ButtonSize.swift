//
//  ButtonSize.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/01.
//

import SwiftUI

public enum ButtonSize {
    case small
    case medium
    case large
    case xlarge
}

extension ButtonSize {
    var padding: EdgeInsets {
        switch self {
        case .small:
            return EdgeInsets(top: 7, leading: 16, bottom: 7, trailing: 16)
        case .medium:
            return EdgeInsets(top: 11, leading: 24, bottom: 11, trailing: 24)
        case .large:
            return EdgeInsets(top: 15, leading: 32, bottom: 15, trailing: 32)
        case .xlarge:
            return EdgeInsets(top: 19, leading: 40, bottom: 19, trailing: 40)
        }
    }

    var cornerRadius: CGFloat {
        return padding.leading
    }

    var fontSize: CGFloat {
        switch self {
        case .small:
            return 12
        case .medium:
            return 14
        case .large:
            return 16
        case .xlarge:
            return 30
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .small:
            return 1
        case .medium:
            return 2
        case .large:
            return 4
        case .xlarge:
            return 6
        }
    }
}
