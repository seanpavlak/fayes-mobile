//
//  Compare.swift
//  fayes-mobile
//
//  Created by Sean Pavlak on 4/9/19.
//  Copyright © 2019 Kaldr Industries. All rights reserved.
//

import Foundation

extension Float {
    func less(than value: Float?) -> Bool {
        guard let value = value else { return false }
        
        return Double(self) < Double(value)
    }
    
    func greater(than value: Float?) -> Bool {
        guard let value = value else { return false }
        
        return Double(self) > Double(value)
    }
}
