//
//  SecondaryButton.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/02.
//

import SwiftUI

extension View {
    public func secondaryCircleButton(
        size: ButtonSize
    ) -> some View {
        return modifier(
            SecondaryButtonStyleModifier(size: size))
    }
}

private struct SecondaryButtonStyleModifier: ViewModifier {
    @Environment(\.isEnabled) var isEnabled
    let size: ButtonSize

    func body(content: Content) -> some View {
        content.buttonStyle(
            SecondaryButtonStyle(
                isEnabled: isEnabled, size: size))
    }
}

private struct SecondaryButtonStyle: ButtonStyle {
    let isEnabled: Bool
    let size: ButtonSize

    func makeBody(configuration: Self.Configuration) -> some View {
        SecondaryButtonStyleView(
            label: configuration.label,
            isPressed: configuration.isPressed,
            isEnabled: isEnabled,
            size: size
        )
    }
}

private struct SecondaryButtonStyleView: View {
    let label: ButtonStyleConfiguration.Label
    let isPressed: Bool
    let isEnabled: Bool
    let size: ButtonSize
    private let color: Color = Color.pink
    private let secondaryBackgroundColor: Color = Color(.systemGroupedBackground)

    @ScaledMetric var fontSize: CGFloat

    init(
        label: ButtonStyleConfiguration.Label, isPressed: Bool, isEnabled: Bool,
        size: ButtonSize
    ) {
        self.label = label
        self.isPressed = isPressed
        self.isEnabled = isEnabled
        self.size = size
        _fontSize = ScaledMetric(wrappedValue: size.fontSize)
    }
    
    private func opacity(for pressed: Bool) -> Double {
         return pressed ? 0.3 : 1.0
     }

    var body: some View {
        label
            .font(.system(size: fontSize, weight: .bold))
            .foregroundStyle(color)
            .padding(size.padding)
            .background(
                Circle()
                    .fill(secondaryBackgroundColor)
            )
            .overlay(
                Circle()
                    .strokeBorder(color, lineWidth: size.borderWidth)
            )
            .overlay(
                Circle()
                    .fill(Color.white.opacity(isPressed ? 0.3 : 0.0))
            )
            .overlay(
                Circle()
                    .fill(Color.white.opacity(isEnabled ? 0.0 : 0.6))
            )
            .contentShape(Circle()) // 当たり判定を丸に限定
    }
}

#Preview {
    let buttonSizes: [(size: ButtonSize, name: String)] = [
        (.small, "Small"),
        (.medium, "Medium"),
        (.large, "Large"),
        (.xlarge, "X-Large"),
    ]

    VStack {
        List(buttonSizes, id: \.name) { buttonSize in
            HStack {
                Text(buttonSize.name)
                    .frame(width: 100, alignment: .trailing)
                Button(action: {
                    print("\(buttonSize.name) Button Tapped")
                }) {
                    Image(systemName: "trash")
                }
                .secondaryCircleButton(size: buttonSize.size)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        
        List(buttonSizes, id: \.name) { buttonSize in
            HStack {
                Text(buttonSize.name)
                    .frame(width: 100, alignment: .trailing)
                Button(action: {
                    print("\(buttonSize.name) Button Tapped")
                }) {
                    Image(systemName: "trash")
                }
                .secondaryCircleButton(size: buttonSize.size)
                .disabled(true)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
