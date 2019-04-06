//
//  Character+ASCII.swift
//  Created by Sean Pavlak on 9/24/18.
//
//  Copyright © 2018 Reliability Data Network. All rights reserved.
//
//  All information contained herein is, and remains the property of Reliability Data Network.
//  The intellectual and technical concepts contained herein are proprietary to Reliability Data
//  Network and its suppliers and may be covered by U.S. and Foreign Patents, patents in process,
//  and are protected by trade secret or copyright law. Dissemination of this information or
//  reproduction of this material is strictly forbidden unless prior written permission is obtained
//  from Reliability Data Network.
//

import Foundation

extension Character {
    var ascii: UInt32? {
        return String(self).ascii.first
    }
}
