//
//  PrimaryAddButton.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/01.
//

import SwiftUI

extension View {
    public func primaryCircleButton(
        size: ButtonSize
    ) -> some View {
        return modifier(
            PrimaryCircleButtonStyleModifier(size: size))
    }
}

private struct PrimaryCircleButtonStyleModifier: ViewModifier {
    @Environment(\.isEnabled) var isEnabled
    let size: ButtonSize

    func body(content: Content) -> some View {
        content.buttonStyle(
            PrimaryCircleButtonStyle(
                isEnabled: isEnabled, size: size))
    }
}

private struct PrimaryCircleButtonStyle: ButtonStyle {
    let isEnabled: Bool
    let size: ButtonSize

    func makeBody(configuration: Self.Configuration) -> some View {
        PrimaryCircleButtonStyleView(
            label: configuration.label,
            isPressed: configuration.isPressed,
            isEnabled: isEnabled,
            size: size
        )
    }
}

private struct PrimaryCircleButtonStyleView: View {
    let label: ButtonStyleConfiguration.Label
    let isPressed: Bool
    let isEnabled: Bool
    let size: ButtonSize
    private let primaryBackgroundColor: Color = Color.pink
    private let iconColor: Color = Color.white

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

    var body: some View {
        label
            .font(.system(size: fontSize, weight: .bold))
            .foregroundStyle(iconColor)
            .padding(size.padding)
            .background(
                Circle()
                    .fill(primaryBackgroundColor)
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
                    Image(systemName: "plus")
                }
                .primaryCircleButton(size: buttonSize.size)
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
                    Image(systemName: "plus")
                }
                .primaryCircleButton(size: buttonSize.size)
                .disabled(true)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
