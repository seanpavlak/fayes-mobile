//
//  Distance.swift
//  fayes-mobile
//
//  Created by Sean Pavlak on 4/5/19.
//  Copyright © 2019 Kaldr Industries. All rights reserved.
//

import UIKit

extension CGPoint {
    func getMidpoint(between point: CGPoint) -> CGPoint {
        return CGPoint(x: (point.x + x) / 2, y: (point.y + y) / 2)
    }
}
