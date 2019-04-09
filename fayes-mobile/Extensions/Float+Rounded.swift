//
//  Float+Rounded.swift
//  fayes-mobile
//
//  Created by Sean Pavlak on 4/8/19.
//  Copyright © 2019 Kaldr Industries. All rights reserved.
//

import UIKit

extension Float {
    func rounded(to places: Int) -> String {
        return String(format: "%.\(places)f", self)
    }
}

