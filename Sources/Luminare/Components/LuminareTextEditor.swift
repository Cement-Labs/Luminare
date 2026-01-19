//
//  LuminareTextEditor.swift
//  Luminare
//
//  Created by KrLite on 2024/12/18.
//

import SwiftUI

// MARK: - Text Editor

/// A stylized text editor.
public struct LuminareTextEditor: View {
    // MARK: Environments

    @Environment(\.font) private var font
    @Environment(\.luminareMinHeight) private var minHeight
    @Environment(\.luminareSectionHorizontalPadding) private var horizontalPadding

    // MARK: Fields

    @Binding private var text: String
    @Binding private var selection: Any? // Handle os versions below macOS 15.0
    @State private var containerSize: CGSize = .zero

    // MARK: Initializers

    public init(
        text: Binding<String>
    ) {
        self._text = text
        self._selection = .constant(nil)
    }

    @available(macOS 15.0, *)
    public init(
        text: Binding<String>,
        selection: Binding<TextSelection?>
    ) {
        self._text = text
        self._selection = Binding {
            selection.wrappedValue
        } set: { newValue in
            if let newValue = newValue as? TextSelection? {
                selection.wrappedValue = newValue
            } else {
                selection.wrappedValue = nil
            }
        }
    }

    // MARK: Body

    public var body: some View {
        ScrollView {
            Group {
                if #available(macOS 15.0, *) {
                    TextEditor(text: $text, selection: strongTypedSelection)
                        .textEditorStyle(.plain)
                } else if #available(macOS 14.0, *) {
                    TextEditor(text: $text)
                        .textEditorStyle(.plain)
                } else {
                    TextEditor(text: $text)
                }
            }
            .scrollDisabled(true)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, 14)
            .frame(minHeight: max(minHeight, containerSize.height))
        }
        .scrollContentBackground(.hidden)
        .font(font ?? .body)
        .luminareContentSize(contentMode: .fill)
        .modifier(LuminareHoverableModifier())
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newValue in
            containerSize = newValue
        }
    }

    @available(macOS 15.0, *)
    private var strongTypedSelection: Binding<TextSelection?> {
        Binding {
            if let value = selection as? TextSelection? {
                value
            } else {
                nil
            }
        } set: { newValue in
            selection = newValue
        }
    }
}

// MARK: - Preview

let sampleText = """
Dolor deserunt culpa laboris nisi. Officia non in do consequat. Exercitation velit amet aliqua laborum adipisicing veniam reprehenderit. Eiusmod sunt sit est mollit veniam ea et duis non est excepteur. Ullamco officia velit ut ullamco veniam ut occaecat pariatur consectetur consectetur duis anim commodo aliqua adipisicing. Eiusmod anim tempor id velit.
"""


@available(macOS 15.0, *)
#Preview(
    "LuminareTextEditor",
    traits: .sizeThatFitsLayout
) {
    @Previewable @State var text = sampleText
    @Previewable @State var selection: TextSelection? = .init(range: .init(uncheckedBounds: (
        sampleText.index(
            sampleText.startIndex,
            offsetBy: 42
        ),
        sampleText.index(
            sampleText.startIndex,
            offsetBy: 128
        )
    )))

    LuminareSection {
        LuminareTextEditor(text: $text)
            .luminareRoundCorners(.top)

        LuminareTextEditor(text: $text, selection: $selection)

        LuminareTextEditor(text: $text, selection: $selection)
            .disabled(true)
            .luminareRoundCorners(.bottom)
    }
}
