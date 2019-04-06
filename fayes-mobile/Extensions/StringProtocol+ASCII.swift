//
//  StringProtocol+ASCII.swift
//  Created by Sean Pavlak on 04/05/19.
//

import Foundation

extension StringProtocol {
    var ascii: [UInt32] {
        return unicodeScalars.compactMap { $0.isASCII ? $0.value : nil }
    }
}
