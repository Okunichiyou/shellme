//
//  DangerCircleButton.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/02.
//

import SwiftUI

extension View {
    public func dangerCircleButton(
        size: ButtonSize
    ) -> some View {
        return modifier(
            DangerCircleButtonStyleModifier(size: size))
    }
}

private struct DangerCircleButtonStyleModifier: ViewModifier {
    @Environment(\.isEnabled) var isEnabled
    let size: ButtonSize

    func body(content: Content) -> some View {
        content.buttonStyle(
            DangerCircleButtonStyle(
                isEnabled: isEnabled, size: size))
    }
}

private struct DangerCircleButtonStyle: ButtonStyle {
    let isEnabled: Bool
    let size: ButtonSize

    func makeBody(configuration: Self.Configuration) -> some View {
        DangerCircleButtonStyleView(
            label: configuration.label,
            isPressed: configuration.isPressed,
            isEnabled: isEnabled,
            size: size
        )
    }
}

private struct DangerCircleButtonStyleView: View {
    let label: ButtonStyleConfiguration.Label
    let isPressed: Bool
    let isEnabled: Bool
    let size: ButtonSize
    private let color: Color = Color.red

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
            .frame(width: size.padding.leading * 2, height: size.padding.top + size.padding.bottom)
            .padding(size.padding)
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
                .dangerCircleButton(size: buttonSize.size)
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
                .dangerCircleButton(size: buttonSize.size)
                .disabled(true)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
