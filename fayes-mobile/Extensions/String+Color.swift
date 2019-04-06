//
//  String+Color.swift
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

import UIKit
import ChameleonFramework

extension String {
    func toInt() -> Int {
        let fold = 4
        let intLength = self.count / fold
        var sum = 0
        
        for index in 0..<intLength {
            let substring = self[(index * fold)..<((index * fold) + fold)]
            hashString(substring, sum: &sum)
        }
        
        hashString(self, sum: &sum)
        
        sum %= 727
        
        return sum
    }
    
    func hashString(_ string: String, sum: inout Int) {
        let stringArray = Array(string)
        var multiplier = 1.0
        for index in 0..<stringArray.count {
            let character = stringArray[index]
            let characterAscii = character.ascii
            if let characterAscii = characterAscii {
                sum += Int(Double(characterAscii) * multiplier)
                multiplier *= 2.7
            }
        }
    }
    
    func toColor() -> UIColor {
        return self.toInt().toColor()
    }
    
    func toShadedColor() -> UIColor {
        let value = self.toInt()
        var ratio: CGFloat = CGFloat(value) / 727
        
        if ratio >= 0.60 {
            ratio = 0.60
        }
        
        let color = value.toColor().lighten(byPercentage: 0.25)
        return color!.darken(byPercentage: ratio) ?? .flatGray
    }
    
    func toColors() -> (light: UIColor, dark: UIColor) {
        return self.toInt().toColors()
    }
}
