//
//  Distance.swift
//  fayes-mobile
//
//  Created by Sean Pavlak on 4/5/19.
//  Copyright © 2019 Kaldr Industries. All rights reserved.
//

import UIKit

func euclideanDistance(from firstPoint: CGPoint, to secondPoint: CGPoint) -> Float {
    return Float(sqrt(pow(secondPoint.x-firstPoint.x,2)+pow(secondPoint.y-firstPoint.y,2)))
}
