//
//  TertiaryButtonStyle.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/25.
//

import SwiftUI

struct TertiaryButtonStyle: ButtonStyle {
    var size: ButtonSize

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: size.fontSize))
            .padding(size.padding)
            .frame(maxWidth: .infinity)
            .background(Color.clear)
            .foregroundColor(.secondary)
            .overlay(
                RoundedRectangle(cornerRadius: size.cornerRadius)
                    .stroke(Color.secondary, lineWidth: size.borderWidth)
            )
            .overlay(
                Color.white.opacity(configuration.isPressed ? 0.3 : 0.0)
                    .cornerRadius(size.cornerRadius)
            )
    }
}

#Preview {
    Button("キャンセル") {
        print("キャンセルする")
    }
    .buttonStyle(TertiaryButtonStyle(size: .medium))
}
