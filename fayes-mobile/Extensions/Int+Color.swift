//
//  Int+Color.swift
//  Created by Sean Pavlak on 04/05/19.
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
