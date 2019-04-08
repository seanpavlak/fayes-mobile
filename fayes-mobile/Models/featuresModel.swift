//
//  featuresModel.swift
//  Created by Sean Pavlak on 04/05/19.
//

import Foundation
import UIKit

struct features {
    var leftEyePoint: CGPoint?
    var rightEyePoint: CGPoint?
    var centerEyePoint: CGPoint?
    var mouthPoint: CGPoint?
    
    var lereDistance: CGFloat?
    var lemDistance: CGFloat?
    var remDistance: CGFloat?
    var cemDistance: CGFloat?
    
    var lereCemRatio: CGFloat?
    var lemRemRatio: CGFloat?
    var lemCemRatio: CGFloat?
    var remCemRatio: CGFloat?

    var malePercentage: Float = 0.0
    var femalePercentage: Float = 0.0
}
