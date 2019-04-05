//
//  dataView.swift
//  genderDetector-7.2.1
//
//  Created by Sean Pavlak on 3/2/16.
//  Copyright © 2016 Sean Pavlak. All rights reserved.
//

import UIKit

class dataView: UIViewController {
    
    @IBOutlet var malePercentLabel: UILabel!
    @IBOutlet var femalePercentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // On button press reload the data
    @IBAction func reloadButton(_ sender: AnyObject) {
        reload()
    }
    
    // Override the previous values in label
    func reload() {
        let maleValue : Int = Int(dataPass.malePercentage * 100)
        let femaleValue : Int = Int(dataPass.femalePercentage * 100)
        
        self.malePercentLabel.text = String(maleValue) + "%"
        self.femalePercentLabel.text = String(femaleValue) + "%"
    }
    
}
