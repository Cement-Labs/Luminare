# ``Luminare/LuminareColorPicker``

@Row {
    @Column(size: 2) {
        A simple yet robust color picker designed to match the Luminare design system.
        
        The text field provides an input for a hex color code, while RGB color codes can be inputted from inside a color picker modal.
        
        Here is an example of its typical usage:
        
        ```swift
        LuminareColorPicker(
            "Done",
            color: $color,
            parseStrategy: .hex(.lowercasedWithWell),
            colorNames: .init {
                Text("Red")
            } green: {
                Text("Green")
            } blue: {
                Text("Blue")
            }
        )
        ```
        
        If using `format` rather than `parseStrategy`, see ``StringFormatStyle`` for more formatting options for the hex color code.
    }

    @Column {
        ![`LuminareColorPicker`](LuminareColorPicker)
        
        ![`ColorPickerModalView`](ColorPickerModalView)
    }
}

## Topics

### Formatting the Color Code

- ``StringFormatStyle``