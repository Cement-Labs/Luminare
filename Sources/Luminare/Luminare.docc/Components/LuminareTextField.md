# ``Luminare/LuminareTextField``

Handles basic `String` input with customizable formatting means. The appearance can be either bordered or not.

@Row {
    @Column {
        ## Basic Usage
        
        ```swift
        LuminareTextField(
            "Company Input",
            text: $input,
            prompt: Text("Company Name")
        )
        
        LuminareTextField(
            value: $price,
            format: .number,
            prompt: Text("Product Price")
        ) {
            Text("Price Input")
        }
        ```
    }
    
    @Column {
        ## Variants

        ![LuminareTextField](LuminareTextField)
    }
}

## Topics

- ``StringFormatStyle``
