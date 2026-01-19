//
//  LuminareButtonStyle+Previews.swift
//  Luminare
//
//  Created by KrLite on 2024/11/4.
//

import SwiftUI

// MARK: - All

#if DEBUG
@available(macOS 15.0, *)
#Preview(
    "LuminareButtonStyles",
    traits: .sizeThatFitsLayout
) {
    VStack {
        LuminareSection {
            HStack(spacing: 4) {
                Button("Prominent") {}
                    .buttonStyle(.luminare(tinted: true))
                    .tint(.purple)
                    .luminareRoundCorners(.topLeading)

                Button("Prominent") {}
                    .buttonStyle(.luminare(tinted: true))
                    .tint(.teal)
                    .luminareRoundCorners(.topTrailing)
            }
            .frame(height: 40)

            HStack(spacing: 4) {
                Button("Normal") {}
                    .luminareRoundCorners(.bottomLeading)

                Button("Destructive", role: .destructive) {}
                    .luminareRoundCorners(.bottomTrailing)
            }
            .frame(height: 40)
        }

        LuminareSection {
            HStack {
                Button("Plateau") {}
                    .luminareRoundCorners()
            }
            .frame(height: 40)
        }
    }
    .buttonStyle(.luminare)
}
#endif

// MARK: - LuminareButtonStyle

#if DEBUG
@available(macOS 15.0, *)
#Preview(
    "LuminareButtonStyle",
    traits: .sizeThatFitsLayout
) {
    Button("Click Me!") {}
        .buttonStyle(.luminare)
        .frame(height: 40)
}
#endif

// MARK: - LuminareProminentButtonStyle

#if DEBUG
@available(macOS 15.0, *)
#Preview(
    "LuminareProminentButtonStyle",
    traits: .sizeThatFitsLayout
) {
    Button("Click Me!") {}
        .buttonStyle(.luminare(tinted: true))
        .frame(height: 40)

    Button("My Role is Destructive", role: .destructive) {}
        .buttonStyle(.luminare)
        .frame(height: 40)
}
#endif

// MARK: - LuminareHoverable

#if DEBUG
@available(macOS 15.0, *)
#Preview(
    "LuminareHoverable",
    traits: .sizeThatFitsLayout
) {
    Text("Not Bordered")
        .fixedSize()
        .modifier(LuminareHoverableModifier())
        .luminareBorderConditions(.none)

    Text("Bordered")
        .fixedSize()
        .modifier(LuminareHoverableModifier())

    Text("Bordered, Hovering")
        .fixedSize()
        .modifier(LuminareHoverableModifier(isHovering: true))

    Text("Bordered, Pressed")
        .fixedSize()
        .modifier(LuminareHoverableModifier(isPressed: true))
}
#endif
