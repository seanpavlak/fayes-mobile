//
//  settingsView.swift
//  genderDetector-7.2.1
//
//  Created by Sean Pavlak on 3/2/16.
//  Copyright © 2016 Sean Pavlak. All rights reserved.
//

import UIKit

class settingsView: UIViewController {
    
    @IBOutlet var faceIndicatorSwitch: UISwitch!
    @IBOutlet var genderIndicatorSwitch: UISwitch!
    @IBOutlet var genderIndicatorColorSlider: UISlider!
    @IBOutlet var genderIndicatorColorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Turn on and off the face indicator and its transition in the camera view
    @IBAction func faceIndicatorSwitchAction(_ sender: UISwitch) {
        if (faceIndicatorSwitch.isOn) {
            dataPass.faceIndicatorSwitch = true
        } else {
            dataPass.faceIndicatorSwitch = false
        }
    }
    
    // Turn on and off teh gender indicator
    @IBAction func genderIndicatorSwitchAction(_ sender: UISwitch) {
        if (genderIndicatorSwitch.isOn) {
            dataPass.genderIndicatorSwitch = true
        } else {
            dataPass.genderIndicatorSwitch = false
        }
    }
    
    // Change the gender indicator emoji color on the camera view and the settings view
    @IBAction func genderIndicatorColorSliderAction(_ sender: UISlider) {
        dataPass.genderIndicatorColorSliderValue = Float(sender.value)
        
        if (genderIndicatorColorSlider.value > 0.835) {
            genderIndicatorColorLabel.text = "👦🏿👧🏿"
        } else if (genderIndicatorColorSlider.value > 0.668) {
            genderIndicatorColorLabel.text = "👦🏾👧🏾"
        } else if (genderIndicatorColorSlider.value > 0.501) {
            genderIndicatorColorLabel.text = "👦🏽👧🏽"
        } else if (genderIndicatorColorSlider.value > 0.334) {
            genderIndicatorColorLabel.text = "👦👧"
        } else if (genderIndicatorColorSlider.value > 0.167) {
            genderIndicatorColorLabel.text = "👦🏼👧🏼"
        } else if (genderIndicatorColorSlider.value >= 0.000) {
            genderIndicatorColorLabel.text = "👦🏻👧🏻"
        }
    }
    
    // Reset all of the switches and sliders to the orijinal position
    @IBAction func defaultButton(_ sender: AnyObject) {
        faceIndicatorSwitch.setOn(true, animated: true)
        dataPass.faceIndicatorSwitch = true
        
        genderIndicatorSwitch.setOn(true, animated: true)
        dataPass.genderIndicatorSwitch = true
        
        genderIndicatorColorSlider.value = 0.5
        dataPass.genderIndicatorColorSliderValue = 0.5
        genderIndicatorColorLabel.text = "👦👧"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
