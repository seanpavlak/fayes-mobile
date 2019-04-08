//
//  TrainingValues.swift
//  fayes-mobile
//
//  Created by Sean Pavlak on 4/5/19.
//  Copyright © 2019 Kaldr Industries. All rights reserved.
//

import UIKit

struct NBTrainingData {
    struct LereCem {
        static let average: CGFloat = 0.882389848

        struct Masculine {
            static let above: Float = 19/50
            static let below: Float = 31/50
        }
        
        struct Feminine {
            static let above: Float = 30/50
            static let below: Float = 20/50
        }
    }
    
    struct LemRem {
        static let average: CGFloat = 0.9968473554

        struct Masculine {
            static let above: Float = 22/50
            static let below: Float = 28/50
        }
        
        struct Feminine {
            static let above: Float = 26/50
            static let below: Float = 24/50
        }
    }
    
    struct LemCem {
        static let average: CGFloat = 1.078119427

        struct Masculine {
            static let above: Float = 26/50
            static let below: Float = 24/50
        }
        
        struct Feminine {
            static let above: Float = 29/50
            static let below: Float = 21/50
        }
    }
    
    struct RemCem {
        static let average: CGFloat = 1.081694334

        struct Masculine {
            static let above: Float = 28/50
            static let below: Float = 22/50
        }
        
        struct Feminine {
            static let above: Float = 32/50
            static let below: Float = 18/50
        }
    }
}
