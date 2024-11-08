//
//  ColorSaturationBrightnessView.swift
//
//
//  Created by Kai Azim on 2024-05-15.
//

import SwiftUI

// MARK: - Color Saturation Brightness

// view for adjusting the lightness of a selected color
struct ColorSaturationBrightnessView: View {
    // MARK: Environments

    @Environment(\.luminareAnimation) private var animation

    // MARK: Fields

    @Binding var selectedColor: HSBColor

    @State private var circlePosition: CGPoint = .zero
    @State private var isDragging: Bool = false

    private let circleSize: CGFloat = 12

    // MARK: Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(
                    hue: selectedColor.hue,
                    saturation: 1,
                    brightness: 1
                )

                LinearGradient(
                    gradient: Gradient(colors: [.white.opacity(0), .white]),
                    startPoint: .trailing,
                    endPoint: .leading
                )

                LinearGradient(
                    gradient: Gradient(colors: [.black.opacity(0), .black]),
                    startPoint: .top,
                    endPoint: .bottom
                )

                ColorPickerCircle(selectedColor: $selectedColor, isDragging: $isDragging, circleSize: circleSize)
                    .offset(
                        x: circlePosition.x - geo.size.width / 2,
                        y: circlePosition.y - geo.size.width / 2
                    )
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isDragging = true
                        updateColor(value.location, geo.size)
                    }
                    .onEnded { value in
                        isDragging = false
                        updateColor(value.location, geo.size)
                    }
            )
            .frame(width: geo.size.width, height: geo.size.width)
            .onAppear {
                updateCirclePosition(geo.size)
            }
            .onChange(of: selectedColor) { _ in
                if !isDragging {
                    updateCirclePosition(geo.size)
                }
            }
        }
    }

    // MARK: Functions

    // update the position of the circle based on user interaction
    private func updateColor(_ location: CGPoint, _ viewSize: CGSize) {
        let adjustedX = max(0, min(location.x, viewSize.width))
        let adjustedY = max(0, min(location.y, viewSize.height))

        // only adjust brightness if dragging, to avoid overwriting with white or black
        if isDragging {
            let saturation = (adjustedX / viewSize.width)
            let brightness = 1 - (adjustedY / viewSize.height)

            selectedColor.saturation = Double(saturation)
            selectedColor.brightness = Double(max(0.0001, brightness))
        }

        withAnimation(animation) {
            updateCirclePosition(viewSize)
        }
    }

    // initialize the position of the circle based on the current color
    private func updateCirclePosition(_ viewSize: CGSize) {
        if selectedColor.saturation <= 0.0001 {
            circlePosition = CGPoint(
                x: .zero,
                y: (1 - CGFloat(selectedColor.brightness)) * viewSize.height
            )
        } else {
            circlePosition = CGPoint(
                x: CGFloat(selectedColor.saturation) * viewSize.width,
                y: (1 - CGFloat(selectedColor.brightness)) * viewSize.height
            )
        }
    }
}

// MARK: - Color Picker Circle

struct ColorPickerCircle: View {
    // MARK: Environments

    @Environment(\.luminareAnimation) private var animation

    // MARK: Fields

    @Binding var selectedColor: HSBColor
    @Binding var isDragging: Bool
    var circleSize: CGFloat

    @State private var isHovering: Bool = false

    // MARK: Body

    var body: some View {
        Circle()
            .frame(width: circleSize, height: circleSize)
            .foregroundColor(selectedColor.rgb)
            .background {
                Circle()
                    .stroke(.white, lineWidth: 6)
            }
            .shadow(radius: 3)
            .scaleEffect((isHovering || isDragging) ? 1.25 : 1.0)
            .onHover { hovering in
                isHovering = hovering
            }
            .animation(animation, value: [isHovering, isDragging])
    }
}

// MARK: - Preview

@available(macOS 15.0, *)
#Preview("ColorSaturationBrightnessView") {
    @Previewable @State var color: HSBColor = Color.accentColor.hsb

    LuminareSection {
        ColorSaturationBrightnessView(selectedColor: $color)
    }
    .padding()
}
