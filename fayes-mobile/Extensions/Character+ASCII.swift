//
//  Character+ASCII.swift
//  Created by Sean Pavlak on 04/05/19.
//

import Foundation

extension Character {
    var ascii: UInt32? {
        return String(self).ascii.first
    }
}
