//
//  LuminareView.swift
//  Luminare
//
//  Created by Kai Azim on 2024-10-06.
//

import SwiftUI

// MARK: - Luminare View

/// The root view of a ``LuminareWindow``.
///
/// This view automatically overrides the content's tint by the one specified with `\.luminareTint` environment value.
public struct LuminareView<Content>: View where Content: View {
    // MARK: Environments

    @Environment(\.luminareTint) private var tint
    @Environment(\.luminareWindow) private var window
    @Environment(\.luminareWindowMinWidth) private var minWidth
    @Environment(\.luminareWindowMaxWidth) private var maxWidth
    @Environment(\.luminareWindowMinHeight) private var minHeight
    @Environment(\.luminareWindowMaxHeight) private var maxHeight

    // MARK: Fields

    @ViewBuilder public let content: () -> Content

    @State private var currentAnimation: LuminareWindowAnimation?

    // MARK: Body

    public var body: some View {
        content()
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            setSize(size: proxy.size, animate: false)
                        }
                        .onChange(of: proxy.size) {
                            setSize(size: $0, animate: true)
                        }
                }
            }
            .frame(
                minWidth: minWidth, maxWidth: maxWidth,
                minHeight: minHeight, maxHeight: maxHeight,
                alignment: .leading
            )
            .focusable(false)
            .buttonStyle(.luminare)
            .overrideTint(tint)
    }

    // MARK: Functions

    func setSize(size: CGSize, animate: Bool) {
        guard let window else {
            return
        }

        if let animation = currentAnimation {
            animation.stop()
        }

        var frame = NSRect(
            origin: window.frame.origin,
            size: CGSize(
                width: size.width,
                height: size.height + 52 // 52 is the titlebar height
            )
        )

        if let screenFrame = window.screen?.visibleFrame {
            if frame.minX < screenFrame.minX {
                frame.origin.x = screenFrame.minX
            }

            if frame.minY < screenFrame.minY {
                frame.origin.y = screenFrame.minY
            }

            if frame.maxX > screenFrame.maxX {
                frame.origin.x = screenFrame.maxX - frame.width
            }

            if frame.maxY > screenFrame.maxY {
                frame.origin.y = screenFrame.maxY - frame.height
            }
        }

        if animate {
            currentAnimation = LuminareWindowAnimation(window, frame)
            currentAnimation?.start()
        } else {
            window.setFrame(frame, display: true)
        }
    }
}

// MARK: - NSWindow Animation

// Vustom `NSWindow` resize animation so that it can be stopped midway
class LuminareWindowAnimation: NSAnimation {
    let window: NSWindow
    let targetFrame: NSRect

    init(_ window: NSWindow, _ targetFrame: NSRect) {
        self.window = window
        self.targetFrame = targetFrame
        super.init(duration: 0.5, animationCurve: .easeOut)
        super.animationBlockingMode = .nonblocking // allows the window to redraw contents while animating
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var currentProgress: NSAnimation.Progress {
        didSet {
            // The last frame of this `NSAnimation` looks a little stuttery,
            // so we multiply the progress by 1.01, and then make sure the last
            // frame doesn't draw
            let progress = CGFloat(currentProgress * 1.01)
            guard progress < 1 else {
                return
            }

            let currentFrame = NSRect(
                x: window.frame.origin.x + (targetFrame.origin.x - window.frame.origin.x) * progress,
                y: window.frame.origin.y + (targetFrame.origin.y - window.frame.origin.y) * progress,
                width: window.frame.width + (targetFrame.width - window.frame.width) * progress,
                height: window.frame.height + (targetFrame.height - window.frame.height) * progress
            )

            window.setFrame(currentFrame, display: false)
        }
    }
}
