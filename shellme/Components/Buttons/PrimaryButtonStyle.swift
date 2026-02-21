//
//  SaveButtonStyle.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/25.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var size: ButtonSize

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: size.fontSize))
            .padding(size.padding)
            .frame(maxWidth: .infinity)
            .background(Color.pink)
            .foregroundColor(.white)
            .cornerRadius(size.cornerRadius)
            .overlay(
                Color.white.opacity(configuration.isPressed ? 0.3 : 0.0)
                    .cornerRadius(size.cornerRadius)
            )
    }
}

#Preview {
    Button("保存") {
        print("保存する")
    }
    .buttonStyle(PrimaryButtonStyle(size: .medium))
}
