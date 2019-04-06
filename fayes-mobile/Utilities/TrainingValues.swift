//
//  TrainingValues.swift
//  fayes-mobile
//
//  Created by Sean Pavlak on 4/5/19.
//  Copyright © 2019 Kaldr Industries. All rights reserved.
//

import Foundation

struct NBTrainingData {
    struct LERE_CEM {
        struct Masculine {
            static let above: Float = 19/50
            static let below: Float = 31/50
        }
        
        struct Feminine {
            static let above: Float = 30/50
            static let below: Float = 20/50
        }
    }
    
    struct LEM_REM {
        struct Masculine {
            static let above: Float = 22/50
            static let below: Float = 28/50
        }
        
        struct Feminine {
            static let above: Float = 26/50
            static let below: Float = 24/50
        }
    }
    
    struct LEM_CEM {
        struct Masculine {
            static let above: Float = 26/50
            static let below: Float = 24/50
        }
        
        struct Feminine {
            static let above: Float = 29/50
            static let below: Float = 21/50
        }
    }
    
    struct REM_CEM {
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
