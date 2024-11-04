//
//  LuminareSection.swift
//
//
//  Created by Kai Azim on 2024-04-01.
//

import SwiftUI

// MARK: - Section

public struct LuminareSection<Header, Content, Footer>: View where Header: View, Content: View, Footer: View {
    // MARK: Fields
    
    private let hasPadding: Bool
    private let hasDividers: Bool
    private let isBordered: Bool
    
    private let headerSpacing: CGFloat
    private let footerSpacing: CGFloat
    private let cornerRadius: CGFloat
    private let innerPadding: CGFloat
    
    @ViewBuilder private let content: () -> Content
    @ViewBuilder private let header: () -> Header
    @ViewBuilder private let footer: () -> Footer

    // MARK: Initializers

    public init(
        hasPadding: Bool = true,
        hasDividers: Bool = true,
        isBordered: Bool = true,
        headerSpacing: CGFloat = 8, footerSpacing: CGFloat = 8,
        cornerRadius: CGFloat = 12, innerPadding: CGFloat = 4,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.hasPadding = hasPadding
        self.hasDividers = hasDividers
        self.isBordered = isBordered
        self.headerSpacing = headerSpacing
        self.footerSpacing = footerSpacing
        self.cornerRadius = cornerRadius
        self.innerPadding = innerPadding
        self.content = content
        self.header = header
        self.footer = footer
    }
    
    public init(
        _ headerKey: LocalizedStringKey,
        _ footerKey: LocalizedStringKey,
        hasPadding: Bool = true,
        hasDividers: Bool = true,
        isBordered: Bool = true,
        headerSpacing: CGFloat = 8, footerSpacing: CGFloat = 8,
        cornerRadius: CGFloat = 12, innerPadding: CGFloat = 4,
        @ViewBuilder content: @escaping () -> Content
    ) where Header == Text, Footer == Text {
        self.init(
            hasPadding: hasPadding,
            hasDividers: hasDividers,
            isBordered: isBordered,
            headerSpacing: headerSpacing, footerSpacing: footerSpacing,
            cornerRadius: cornerRadius, innerPadding: innerPadding
        ) {
            content()
        } header: {
            Text(headerKey)
        } footer: {
            Text(footerKey)
        }
    }
    
    public init(
        hasPadding: Bool = true,
        hasDividers: Bool = true,
        isBordered: Bool = true,
        headerSpacing: CGFloat = 8, footerSpacing: CGFloat = 8,
        cornerRadius: CGFloat = 12, innerPadding: CGFloat = 4,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder header: @escaping () -> Header
    ) where Footer == EmptyView {
        self.init(
            hasPadding: hasPadding,
            hasDividers: hasDividers,
            isBordered: isBordered,
            headerSpacing: headerSpacing, footerSpacing: footerSpacing,
            cornerRadius: cornerRadius, innerPadding: innerPadding
        ) {
            content()
        } header: {
            header()
        } footer: {
            EmptyView()
        }
    }
    
    public init(
        _ headerKey: LocalizedStringKey,
        hasPadding: Bool = true,
        hasDividers: Bool = true,
        isBordered: Bool = true,
        headerSpacing: CGFloat = 8, footerSpacing: CGFloat = 8,
        cornerRadius: CGFloat = 12, innerPadding: CGFloat = 4,
        @ViewBuilder content: @escaping () -> Content
    ) where Header == Text, Footer == EmptyView {
        self.init(
            hasPadding: hasPadding,
            hasDividers: hasDividers,
            isBordered: isBordered,
            headerSpacing: headerSpacing, footerSpacing: footerSpacing,
            cornerRadius: cornerRadius, innerPadding: innerPadding
        ) {
            content()
        } header: {
            Text(headerKey)
        }
    }
    
    public init(
        hasPadding: Bool = true,
        hasDividers: Bool = true,
        isBordered: Bool = true,
        headerSpacing: CGFloat = 8, footerSpacing: CGFloat = 8,
        cornerRadius: CGFloat = 12, innerPadding: CGFloat = 4,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder footer: @escaping () -> Footer
    ) where Header == EmptyView {
        self.init(
            hasPadding: hasPadding,
            hasDividers: hasDividers,
            isBordered: isBordered,
            headerSpacing: headerSpacing, footerSpacing: footerSpacing,
            cornerRadius: cornerRadius, innerPadding: innerPadding
        ) {
            content()
        } header: {
            EmptyView()
        } footer: {
            footer()
        }
    }
    
    public init(
        footerKey: LocalizedStringKey,
        hasPadding: Bool = true,
        hasDividers: Bool = true,
        isBordered: Bool = true,
        headerSpacing: CGFloat = 8, footerSpacing: CGFloat = 8,
        cornerRadius: CGFloat = 12, innerPadding: CGFloat = 4,
        @ViewBuilder content: @escaping () -> Content
    ) where Header == EmptyView, Footer == Text {
        self.init(
            hasPadding: hasPadding,
            hasDividers: hasDividers,
            isBordered: isBordered,
            headerSpacing: headerSpacing, footerSpacing: footerSpacing,
            cornerRadius: cornerRadius, innerPadding: innerPadding
        ) {
            content()
        } footer: {
            Text(footerKey)
        }
    }
    
    public init(
        hasPadding: Bool = true,
        hasDividers: Bool = true,
        isBordered: Bool = true,
        headerSpacing: CGFloat = 8, footerSpacing: CGFloat = 8,
        cornerRadius: CGFloat = 12, innerPadding: CGFloat = 4,
        @ViewBuilder content: @escaping () -> Content
    ) where Header == EmptyView, Footer == EmptyView {
        self.init(
            hasPadding: hasPadding,
            hasDividers: hasDividers,
            isBordered: isBordered,
            headerSpacing: headerSpacing, footerSpacing: footerSpacing,
            cornerRadius: cornerRadius, innerPadding: innerPadding
        ) {
            content()
        } header: {
            EmptyView()
        } footer: {
            EmptyView()
        }
    }
    
    // MARK: Body

    public var body: some View {
        VStack(spacing: 0) {
            if Header.self != EmptyView.self {
                Group {
                    if Header.self == Text.self {
                        HStack {
                            header()
                            
                            Spacer()
                        }
                    } else {
                        header()
                    }
                }
                .foregroundStyle(.secondary)
                
                Spacer()
                    .frame(height: headerSpacing)
            }
            
            if isBordered {
                DividedVStack(applyMaskToItems: hasPadding, hasDividers: hasDividers) {
                    content()
                }
                .frame(maxWidth: .infinity)
                .background(.quinary)
                .clipShape(.rect(cornerRadius: cornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(.quaternary, lineWidth: 1)
                }
            } else {
                content()
            }
            
            if Footer.self != EmptyView.self {
                Spacer()
                    .frame(height: footerSpacing)
                
                Group {
                    if Footer.self == Text.self {
                        HStack {
                            footer()
                            
                            Spacer()
                        }
                    } else {
                        footer()
                    }
                }
                .foregroundStyle(.secondary)
            }

        }
    }
}

// MARK: - Preview

#Preview {
    LuminareSection {
        Text("Content")
            .frame(height: 200)
    } header: {
        HStack(alignment: .bottom) {
            Text("Header")
            
            Spacer()
            
            Button {
                
            } label: {
                Text("Action")
                    .font(.caption)
                    .frame(height: 24)
                    .padding(.horizontal, 8)
            }
            .buttonStyle(LuminareCompactButtonStyle(extraCompact: true))
        }
    } footer: {
        HStack {
            Text("Footer")
            
            Spacer()
        }
    }
    .padding()
}
