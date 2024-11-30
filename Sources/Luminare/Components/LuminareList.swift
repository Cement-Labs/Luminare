//
//  LuminareList.swift
//
//
//  Created by Kai Azim on 2024-04-13.
//

import SwiftUI

// MARK: - List

/// A stylized list.
public struct LuminareList<
    Header, ContentA, ContentB, Actions, RemoveView, Footer, V, ID
>: View
where
    Header: View, ContentA: View, ContentB: View, Actions: View,
    RemoveView: View, Footer: View, V: Hashable, ID: Hashable
{
    // MARK: Environments

    @Environment(\.luminareClickedOutside) private var luminareClickedOutside
    @Environment(\.luminareTint) private var tint
    @Environment(\.luminareAnimation) private var animation
    @Environment(\.luminareIsBordered) private var isBordered
    @Environment(\.luminareListItemHeight) private var itemHeight
    @Environment(\.luminareListActionsHeight) private var actionsHeight

    // MARK: Fields

    @Binding private var items: [V]
    @Binding private var selection: Set<V>
    private let id: KeyPath<V, ID>

    @ViewBuilder private let content: (Binding<V>) -> ContentA,
        emptyView: () -> ContentB
    @ViewBuilder private let actions: () -> Actions,
        removeView: () -> RemoveView
    @ViewBuilder private let header: () -> Header, footer: () -> Footer

    @State private var firstItem: V?
    @State private var lastItem: V?

    @State private var canRefreshSelection = true
    @State private var eventMonitor: AnyObject?

    // MARK: Initializers

    /// Initializes a ``LuminareList``.
    ///
    /// - Parameters:
    ///   - items: the binding of the listed items.
    ///   - selection: the binding of the set of selected items.
    ///   - id: the key path for the identifiers of each element.
    ///   - content: the content generator that accepts a value binding.
    ///   - emptyView: the view to display when nothing is inside the list.
    ///   - actions: the actions placed next to the **remove** button.
    ///   Typically buttons that manipulate the listed items.
    ///   - removeView: the view inside the **remove** button.
    ///   - header: the header.
    ///   - footer: the footer.
    public init(
        items: Binding<[V]>,
        selection: Binding<Set<V>>, id: KeyPath<V, ID>,
        @ViewBuilder content: @escaping (Binding<V>) -> ContentA,
        @ViewBuilder emptyView: @escaping () -> ContentB,
        @ViewBuilder actions: @escaping () -> Actions,
        @ViewBuilder removeView: @escaping () -> RemoveView,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self._items = items
        self._selection = selection
        self.id = id
        self.content = content
        self.emptyView = emptyView
        self.actions = actions
        self.removeView = removeView
        self.header = header
        self.footer = footer
    }

    // MARK: Body

    public var body: some View {
        LuminareSection(hasPadding: false) {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                let hasActions = Actions.self != EmptyView.self
                let hasRemoveView = RemoveView.self != EmptyView.self

                Section {
                    if items.isEmpty {
                        emptyView()
                            .frame(minHeight: itemHeight)
                    } else {
                        List(selection: $selection) {
                            ForEach($items, id: id) { item in
                                let isDisabled = isDisabled(item.wrappedValue)
                                let tint = getTint(of: item.wrappedValue)

                                Group {
                                    if #available(macOS 14.0, *) {
                                        LuminareListItem(
                                            items: $items,
                                            selection: $selection,
                                            item: item,
                                            firstItem: $firstItem,
                                            lastItem: $lastItem,
                                            roundedTop: !hasActions && !hasRemoveView,
                                            roundedBottom: isBordered,
                                            canRefreshSelection:
                                                $canRefreshSelection,
                                            content: content
                                        )
                                        .selectionDisabled(isDisabled)
                                    } else {
                                        LuminareListItem(
                                            items: $items,
                                            selection: $selection,
                                            item: item,
                                            firstItem: $firstItem,
                                            lastItem: $lastItem,
                                            roundedTop: hasActions || hasRemoveView,
                                            roundedBottom: isBordered,
                                            canRefreshSelection:
                                                $canRefreshSelection,
                                            content: content
                                        )
                                    }
                                }
                                .disabled(isDisabled)
                                .animation(animation, value: isDisabled)
                                .overrideTint { tint }
                            }
                            .onMove { indices, newOffset in
                                withAnimation(animation) {
                                    items.move(
                                        fromOffsets: indices,
                                        toOffset: newOffset)
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init())
                            .padding(.horizontal, -10)
                        }
                        .frame(height: CGFloat(items.count) * itemHeight)
                        .scrollContentBackground(.hidden)
                        .scrollDisabled(true)
                        .listStyle(.plain)
                    }
                } header: {
                    Group {
                        if hasActions || hasRemoveView {
                            if isBordered {
                                VStack(spacing: 0) {
                                    HStack(spacing: 2) {
                                        if hasActions {
                                            actions()
                                                .buttonStyle(LuminareButtonStyle())
                                        }
                                        
                                        if hasRemoveView {
                                            removeButton()
                                        }
                                    }
                                    .modifier(
                                        LuminareCroppedSectionItem(
                                            isFirstChild: true,
                                            isLastChild: false
                                        )
                                    )
                                    .luminareMinHeight(actionsHeight)
                                    .frame(maxHeight: actionsHeight)
                                    .padding(.vertical, 4)
                                    
                                    Divider()
                                        .padding(.vertical, -1) // it's nuanced
                                }
                                .background(.ultraThickMaterial)
                            } else {
                                LuminareSection {
                                    HStack(spacing: 2) {
                                        if hasActions {
                                            actions()
                                                .buttonStyle(LuminareButtonStyle())
                                        }
                                        
                                        if hasRemoveView {
                                            removeButton()
                                        }
                                    }
                                }
                                .luminareBordered(true)
                                .luminareMinHeight(actionsHeight)
                                .frame(maxHeight: actionsHeight)
                                .padding(.horizontal, -4)
                                .padding(.top, 4)
                                .padding(.bottom, 8)
                            }
                        }
                    }
                    .luminareButtonCornerRadius()
                }
            }
        } header: {
            header()
        } footer: {
            footer()
        }
        .onChange(of: luminareClickedOutside) { _ in
            withAnimation(animation) {
                selection = []
            }
        }
        .onChange(of: selection) { _ in
            processSelection()

            if selection.isEmpty {
                removeEventMonitor()
            } else {
                addEventMonitor()
            }
        }
        .onAppear {
            if !selection.isEmpty {
                addEventMonitor()
            }
        }
        .onDisappear {
            removeEventMonitor()
        }
    }

    @ViewBuilder private func removeButton() -> some View {
        Button {
            if !selection.isEmpty {
                canRefreshSelection = false
                items.removeAll(where: {
                    selection.contains($0)
                })

                selection = []

                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 0.25
                ) {
                    canRefreshSelection = true
                }
            }
        } label: {
            removeView()
        }
        .buttonStyle(LuminareDestructiveButtonStyle())
        .disabled(selection.isEmpty)
    }

    // MARK: Functions

    private func isDisabled(_ element: V) -> Bool {
        (element as? LuminareSelectionData)?.isSelectable == false
    }

    private func getTint(of element: V) -> Color {
        (element as? LuminareSelectionData)?.tint ?? tint()
    }

    private func processSelection() {
        if selection.isEmpty {
            firstItem = nil
            lastItem = nil
        } else {
            firstItem = items.first(where: { selection.contains($0) })
            lastItem = items.last(where: { selection.contains($0) })
        }
    }

    private func addEventMonitor() {
        guard eventMonitor == nil else { return }

        eventMonitor =
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                let kVK_Escape: CGKeyCode = 0x35

                if event.keyCode == kVK_Escape {
                    withAnimation(animation) {
                        selection = []
                    }
                    return nil
                }
                return event
            } as? NSObject
    }

    private func removeEventMonitor() {
        if let eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
        }
        eventMonitor = nil
    }
}

// MARK: - List Item

public struct LuminareListItem<Content, V>: View
where Content: View, V: Hashable {
    // MARK: Environments

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.luminareTint) private var tint
    @Environment(\.luminareAnimation) private var animation
    @Environment(\.luminareAnimationFast) private var animationFast
    @Environment(\.luminareCornerRadius) private var cornerRadius
    @Environment(\.luminareButtonCornerRadius) private var buttonCornerRadius
    @Environment(\.luminareIsBordered) private var isBordered
    @Environment(\.luminareListItemHeight) private var itemHeight

    // MARK: Fields

    @Binding var items: [V]
    @Binding var selection: Set<V>

    @Binding var item: V
    @Binding var firstItem: V?
    @Binding var lastItem: V?
    
    var roundedTop: Bool = true
    var roundedBottom: Bool = true
    @Binding var canRefreshSelection: Bool
    @ViewBuilder var content: (Binding<V>) -> Content

    @State private var isHovering = false

    private let maxLineWidth: CGFloat = 1.5
    @State private var lineWidth: CGFloat = .zero

    private let maxTintOpacity: CGFloat = 0.15
    @State private var tintOpacity: CGFloat = .zero

    // MARK: Body

    public var body: some View {
        Color.clear
            .frame(minHeight: itemHeight)
            .overlay {
                content($item)
                    .environment(\.hoveringOverLuminareItem, isHovering)
                    .foregroundStyle(isEnabled ? .primary : .secondary)
            }
            .tag(item)
            .onHover { hover in
                withAnimation(animationFast) {
                    isHovering = hover
                }
            }
            .background {
                ZStack {
                    if isEnabled {
                        itemBorder()
                        itemBackground()
                    }
                }
                .padding(.horizontal, 1)
                .padding(.leading, 1)  // somehow fixes
            }
            .overlay {
                if isBordered && !isLast {
                    VStack {
                        Spacer()

                        Divider()
                            .frame(height: 0)
                    }
                    .padding(.trailing, -1)
                }
            }

            .onChange(of: selection) { newSelection in
                guard isEnabled else { return }
                guard canRefreshSelection else { return }
                DispatchQueue.main.async {
                    withAnimation(animation) {
                        updateSelection(selection: newSelection)
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.async {
                    withAnimation(animation) {
                        // initialize selection
                        updateSelection(selection: selection)

                        // reset hovering state
                        isHovering = false
                    }
                }
            }
    }

    private var isFirst: Bool {
        item == items.first
    }

    private var isLast: Bool {
        item == items.last
    }
    
    private var itemBackgroundShape: UnevenRoundedRectangle {
        .init(
            topLeadingRadius: isFirst && roundedTop ? cornerRadius : buttonCornerRadius,
            bottomLeadingRadius: isLast && roundedBottom ? cornerRadius : buttonCornerRadius,
            bottomTrailingRadius: isLast && roundedBottom ? cornerRadius : buttonCornerRadius,
            topTrailingRadius: isFirst && roundedTop ? cornerRadius : buttonCornerRadius
        )
    }

    @ViewBuilder private func itemBackground() -> some View {
        ZStack {
            itemBackgroundShape
                .foregroundStyle(.tint)
                .opacity(tintOpacity)

            if isHovering {
                itemBackgroundShape
                    .foregroundStyle(.quaternary.opacity(0.7))
                    .opacity(
                        (maxTintOpacity - tintOpacity) * (1 / maxTintOpacity)
                    )
            }
        }
    }

    @ViewBuilder private func itemBorder() -> some View {
        if isFirstInSelection(), isLastInSelection() {
            singleSelectionPart()
        } else if isFirstInSelection() {
            firstItemPart()
        } else if isLastInSelection() {
            lastItemPart()
        } else if selection.contains(item) {
            doubleLinePart()
        }
    }

    @ViewBuilder private func firstItemPart() -> some View {
        VStack(spacing: 0) {
            // --- top half ---

            ZStack {
                UnevenRoundedRectangle(
                    topLeadingRadius: isFirst && roundedTop
                        ? cornerRadius : buttonCornerRadius,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: isFirst && roundedTop
                        ? cornerRadius : buttonCornerRadius
                )
                .strokeBorder(.tint, lineWidth: lineWidth)

                VStack {
                    Color.clear
                    HStack {
                        Spacer()
                            .frame(width: lineWidth)

                        Rectangle()
                            .foregroundStyle(.white)
                            .blendMode(.destinationOut)

                        Spacer()
                            .frame(width: lineWidth)
                    }
                }
            }
            .compositingGroup()

            // --- bottom half ---

            HStack {
                Rectangle()
                    .frame(width: lineWidth)

                Spacer()

                Rectangle()
                    .frame(width: lineWidth)
            }
            .foregroundStyle(.tint)
        }
    }

    @ViewBuilder private func lastItemPart() -> some View {
        VStack(spacing: 0) {
            // --- top half ---

            HStack {
                Rectangle()
                    .frame(width: lineWidth)

                Spacer()

                Rectangle()
                    .frame(width: lineWidth)
            }
            .foregroundStyle(.tint)

            // --- bottom half ---

            ZStack {
                UnevenRoundedRectangle(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: isLast && roundedBottom
                        ? cornerRadius : buttonCornerRadius,
                    bottomTrailingRadius: isLast && roundedBottom
                        ? cornerRadius : buttonCornerRadius,
                    topTrailingRadius: 0
                )
                .strokeBorder(.tint, lineWidth: lineWidth)

                VStack {
                    HStack {
                        Spacer()
                            .frame(width: lineWidth)

                        Rectangle()
                            .foregroundStyle(.white)
                            .blendMode(.destinationOut)

                        Spacer()
                            .frame(width: lineWidth)
                    }
                    Color.clear
                }
            }
            .compositingGroup()
        }
    }

    @ViewBuilder private func doubleLinePart() -> some View {
        HStack {
            Rectangle()
                .frame(width: lineWidth)

            Spacer()

            Rectangle()
                .frame(width: lineWidth)
        }
        .foregroundStyle(.tint)
    }

    @ViewBuilder private func singleSelectionPart() -> some View {
        UnevenRoundedRectangle(
            topLeadingRadius: isFirst && roundedTop
                ? cornerRadius : buttonCornerRadius,
            bottomLeadingRadius: isLast && roundedBottom
                ? cornerRadius : buttonCornerRadius,
            bottomTrailingRadius: isLast && roundedBottom
                ? cornerRadius : buttonCornerRadius,
            topTrailingRadius: isFirst && roundedTop
                ? cornerRadius : buttonCornerRadius
        )
        .strokeBorder(.tint, lineWidth: lineWidth)
    }

    // MARK: Functions

    private func updateSelection(selection: Set<V>) {
        tintOpacity = selection.contains(item) ? maxTintOpacity : .zero
        lineWidth = selection.contains(item) ? maxLineWidth : .zero
    }

    private func isFirstInSelection() -> Bool {
        if let firstIndex = items.firstIndex(of: item),
            firstIndex > 0,
            !selection.contains(items[firstIndex - 1])
        {
            return true
        }

        return item == firstItem
    }

    private func isLastInSelection() -> Bool {
        if let firstIndex = items.firstIndex(of: item),
            firstIndex < items.count - 1,
            !selection.contains(items[firstIndex + 1])
        {
            return true
        }

        return item == lastItem
    }
}

// MARK: - Preview

private struct ListPreview<V>: View where V: Hashable & Comparable {
    @State var items: [V]
    @State var selection: Set<V>
    let add: (inout [V]) -> Void

    var body: some View {
        LuminareList(
            items: $items,
            selection: $selection,
            id: \.self
        ) { value in
            Text("\(value.wrappedValue)")
                .contextMenu {
                    Button("Remove") {
                        withAnimation {
                            items.removeAll {
                                selection.contains($0)
                                    || value.wrappedValue == $0
                            }
                        }
                    }
                }
                .swipeActions {
                    Button("Swipe me!") {}
                }
        } emptyView: {
            Text("Empty")
                .foregroundStyle(.secondary)
        } actions: {
            Button("Add") {
                withAnimation {
                    add(&items)
                }
            }

            Button("Sort") {
                withAnimation {
                    items.sort(by: <)
                }
            }
        } removeView: {
            Text("Remove")
        } header: {
            Text("List Header")
        } footer: {
            Text("List Footer")
        }
    }
}

@available(macOS 15.0, *)
#Preview(
    "LuminareList",
    traits: .sizeThatFitsLayout
) {
    ScrollView {
        ListPreview(items: [37, 42, 1, 0], selection: [42]) { items in
            guard items.count < 100 else { return }
            let random = { Int.random(in: 0..<100) }
            var new = random()
            while items.contains([new]) {
                new = random()
            }
            items.append(new)
        }
        .luminareMinHeight(50)
//        .luminareBordered(false)
//        .luminareButtonCornerRadius(8)
    }
    .frame(height: 350)
}
