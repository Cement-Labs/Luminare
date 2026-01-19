//
//  OptionSet+Extensions.swift
//  Luminare
//
//  Created by KrLite on 2026/1/19.
//

import Foundation

extension OptionSet {
    init(_ flags: [Self: Bool]) where Self: Hashable {
        self = flags.reduce(into: []) { result, element in
            let (option, enabled) = element
            if enabled {
                result.formUnion(option)
            }
        }
    }
}
