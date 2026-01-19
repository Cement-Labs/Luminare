# ``Luminare/LuminareSection``

@Row {
    @Column {
        ``LuminareSection`` is intuitive to use and is much like a SwiftUI `Section` besides its stylish look.
        
        In the default style, direct children of the content will be separated by horizontal dividers just as expected.
        You can, however, toggle clipping, dividers and many other aspects to match your style.
        
        ```swift
        LuminareSection {
            // Content
        } header: {
            // Header
        } footer: {
            // Footer
        }
        ```
    }
    
    @Column {
        ![LuminareSection](LuminareSection)
    }
}
