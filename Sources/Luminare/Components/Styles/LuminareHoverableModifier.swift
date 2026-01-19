//
//  LuminareHoverableModifier.swift
//  Luminare
//
//  Created by KrLite on 2025/4/12.
//

import SwiftUI

/// A stylized modifier that constructs a bordered appearance while hovering.
///
/// Combines both of `LuminareFilledModifier` and `LuminareBorderedModifier`.
public struct LuminareHoverableModifier: ViewModifier {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.luminareCornerRadii) private var cornerRadii
    @Environment(\.luminareIsInsideSection) private var isInsideSection
    @Environment(\.luminareRoundCorners) private var roundCorners
    @State private var disableInnerPadding: Bool? = nil

    private let isPressed: Bool
    private let isHovering: Bool

    public init(
        isPressed: Bool = false,
        isHovering: Bool = false
    ) {
        self.isPressed = isPressed
        self.isHovering = isHovering
    }

    private var radii: RectangleCornerRadii {
        if isInsideSection {
            let disableInnerPadding = disableInnerPadding == true
            let cornerRadii = disableInnerPadding ? cornerRadii : cornerRadii.inset(by: 4)
            let defaultCornerRadius: CGFloat = 2

            return RectangleCornerRadii(
                topLeading: roundCorners.contains(.topLeading) ? cornerRadii.topLeading : defaultCornerRadius,
                bottomLeading: roundCorners.contains(.bottomLeading) ? cornerRadii.bottomLeading : defaultCornerRadius,
                bottomTrailing: roundCorners.contains(.bottomTrailing) ? cornerRadii.bottomTrailing : defaultCornerRadius,
                topTrailing: roundCorners.contains(.topTrailing) ? cornerRadii.topTrailing : defaultCornerRadius
            )
        } else {
            return cornerRadii
        }
    }

    public func body(content: Content) -> some View {
        content
            .compositingGroup()
            .luminareCornerRadii(radii)
            .background {
                LuminareFill(
                    isHovering: isHovering,
                    isPressed: isPressed,
                    cornerRadii: radii,
                    style: .default
                )

                LuminareBorder(
                    isHovering: isHovering,
                    cornerRadii: radii,
                    style: .default
                )
            }
            .opacity(isEnabled ? 1 : 0.5)
            .readPreference(LuminareSectionStackDisableInnerPaddingKey.self, to: $disableInnerPadding)
    }
}
