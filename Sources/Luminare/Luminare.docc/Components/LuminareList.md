# ``Luminare/LuminareList``

@Row {
    @Column {
        The list is based on a bordered ``LuminareSection``.
        An array of items and a set of selected items are required to create a list.
        
        Elements can conform to ``LuminareSelectionData`` for more precise controls on selection behaviors.
    }
    
    @Column {
        ![LuminareList](LuminareList)
    }
}
    
``LuminareList`` contains only the "selection" part without any control buttons, so it pairs well with a stack of actions inside a ``LuminareSection``.

Here's a practical usage with 2 custom action buttons and a named **remove** button:

```swift
LuminareSection(clipped: true) {
    HStack(spacing: 2) {
        Button("Add") {
            withAnimation {
                add(&items)
            }
        }
        .luminareRoundCorners(.topLeading)

        Button("Sort") {
            withAnimation {
                items.sort(by: <)
            }
        }
        .disabled(items.isEmpty)

        Button("Remove", role: .destructive) {
            items.removeAll { selection.contains($0) }
        }
        .disabled(selection.isEmpty)
        .luminareRoundCorners(.topTrailing)
    }
    .buttonStyle(.luminare)
    .frame(height: 40)

    LuminareList(
        items: $items,
        selection: $selection,
        id: \.self
    ) { value in
        Text("\(String(value.wrappedValue))")
            .contextMenu {
                // Context menu
            }
            .swipeActions {
                // Swipe actions
            }
    } emptyView: {
            Text("Empty")
                .foregroundStyle(.secondary)
    }
    .luminareRoundCorners(.bottom)
}
```
