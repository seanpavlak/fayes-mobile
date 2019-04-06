//
//  Int+Color.swift
//  Created by Sean Pavlak on 7/20/18.
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

extension Int {
    func toColor() -> UIColor {
        let seed = self % 727
        
        srand48(seed)
        let color = UIColor(hue: CGFloat(drand48()),
                            saturation: 0.6,
                            brightness: 0.9,
                            alpha: 1.0)
        
        return color.flatten()
    }
    
    func toColorScheme() -> [UIColor] {
        return ColorSchemeOf(ColorScheme.analogous, color: self.toColor(), isFlatScheme: true)
    }
    
    func toColors() -> (light: UIColor, dark: UIColor) {
        let lightColor: UIColor = self.toColor().lighten(byPercentage: 0.6) ?? FlatGray()
        let darkColor: UIColor = self.toColor().darken(byPercentage: 0.2) ?? FlatGrayDark()
        
        return (lightColor, darkColor)
    }
}
