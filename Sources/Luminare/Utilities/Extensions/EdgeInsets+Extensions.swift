//
//  EdgeInsets+Extensions.swift
//  Luminare
//
//  Created by KrLite on 2026/1/19.
//

import SwiftUI

extension EdgeInsets {
    static var zero: Self { .init(0) }
    
    init(_ length: CGFloat) {
        self.init(
            top: length,
            leading: length,
            bottom: length,
            trailing: length
        )
    }
    
    init(_ length: CGFloat, edges: Edge.Set) {
        self.init(
            top: edges.contains(.top) ? length : 0,
            leading: edges.contains(.leading) ? length : 0,
            bottom: edges.contains(.bottom) ? length : 0,
            trailing: edges.contains(.trailing) ? length : 0,
        )
    }
}
