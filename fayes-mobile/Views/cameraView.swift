//
//  cameraView.swift
//  genderDetector-7.2.1
//
//  Created by Sean Pavlak on 3/2/16.
//  Copyright © 2016 Sean Pavlak. All rights reserved.
//

import UIKit

class cameraView: UIViewController {
    
    // Set up Visage to use CoreImage face detection and feature detection
    fileprivate var visage : Visage?
    fileprivate let notificationCenter : NotificationCenter = NotificationCenter.default
    
    // Create the gender detection and face indicator emoji label programatically
    let emojiLabel : UILabel = UILabel(frame: CGRect(x: 10, y: 20, width: 50, height: 50))
    
    // Bool to test if the program is streaming or still
    var isDetecting : Bool = false
    
    // Distances between face points
    var distanceLeftEyeToRightEye : Float = 0.0
    var distanceLeftEyeToMouth : Float = 0.0
    var distanceRightEyeToMouth : Float = 0.0
    var distanceCenterEyeToMouth : Float = 0.0
    
    
    // Ratios between distances
    var ratioLeftEyeToRightEyeAndCenterEyeToMouth : Float = 0.0
    var ratioLeftEyeToMouthAndRightEyeToMouth : Float = 0.0
    var ratioLeftEyeToMouthAndCenterEyeToMouth : Float = 0.0
    var ratioRightEyeToMouthAndCenterEyeToMouth : Float = 0.0
    
    // Tests to see if the ratios are above or below their threshold values
    var ratioLeftEyeToRightEyeAndCenterEyeToMouthIsAbove : Bool = false
    var ratioLeftEyeToMouthAndRightEyeToMouthIsAbove : Bool = false
    var ratioLeftEyeToMouthAndCenterEyeToMouthIsAbove : Bool = false
    var ratioRightEyeToMouthAndCenterEyeToMouthIsAbove : Bool = false
    
    // Value given by naive bayes formula for male and female likelyhood
    var probabilityMale : Float = 0.0
    var probabilityFemale : Float = 0.0
    
    // Containers to hold the above or below values for male and female
    var probabilityMaleGivenRatioLeftEyeToRightEyeAndCenterEyeToMouth : Float = 0.0
    var probabilityMaleGivenRatioLeftEyeToMouthAndRightEyeToMouth : Float = 0.0
    var probabilityMaleGivenRatioLeftEyeToMouthAndCenterEyeToMouth : Float = 0.0
    var probabilityMaleGivenRatioRightEyeToMouthAndCenterEyeToMouth : Float = 0.0
    
    var probabilityFemaleGivenLeftEyeToRightEyeAndCenterEyeToMouth : Float = 0.0
    var probabilityFemaleGivenRatioLeftEyeToMouthAndRightEyeToMouth : Float = 0.0
    var probabilityFemaleGivenRatioLeftEyeToMouthAndCenterEyeToMouth : Float = 0.0
    var probabilityFemaleGivenRatioRightEyeToMouthAndCenterEyeToMouth : Float = 0.0
    
    // Values determined by NB training set for male and female
    var probabilityMaleGivenRatioLeftEyeToRightEyeAndCenterEyeToMouthIsAbove : Float = 19/50
    var probabilityMaleGivenRatioLeftEyeToRightEyeAndCenterEyeToMouthIsBelow : Float = 31/50
    var probabilityFemaleGivenRatioLeftEyeToRightEyeAndCenterEyeToMouthIsAbove : Float = 30/50
    var probabilityFemaleGivenRatioLeftEyeToRightEyeAndCenterEyeToMouthIsBelow : Float = 20/50
    
    var probabilityMaleGivenRatioLeftEyeToMouthAndRightEyeToMouthIsAbove : Float = 22/50
    var probabilityMaleGivenRatioLeftEyeToMouthAndRightEyeToMouthIsBelow : Float = 28/50
    var probabilityFemaleGivenRatioLeftEyeToMouthAndRightEyeToMouthIsAbove : Float = 26/50
    var probabilityFemaleGivenRatioLeftEyeToMouthAndRightEyeToMouthIsBelow : Float = 24/50
    
    var probabilityMaleGivenRatioLeftEyeToMouthAndCenterEyeToMouthIsAbove : Float = 26/50
    var probabilityMaleGivenRatioLeftEyeToMouthAndCenterEyeToMouthIsBelow : Float = 24/50
    var probabilityFemaleGivenRatioLeftEyeToMouthAndCenterEyeToMouthIsAbove : Float = 29/50
    var probabilityFemaleGivenRatioLeftEyeToMouthAndCenterEyeToMouthIsBelow : Float = 21/50
    
    var probabilityMaleGivenRatioRightEyeToMouthAndCenterEyeToMouthIsAbove : Float = 28/50
    var probabilityMaleGivenRatioRightEyeToMouthAndCenterEyeToMouthIsBelow : Float = 22/50
    var probabilityFemaleGivenRatioRightEyeToMouthAndCenterEyeToMouthIsAbove : Float = 32/50
    var probabilityFemaleGivenRatioRightEyeToMouthAndCenterEyeToMouthIsBelow : Float = 18/50
    
    // Variable for the midpoint between the eyes
    var centerEye : CGPoint?
    
    // Test if photo was taken
    var didTakePhoto : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup "Visage" with a camera-position (iSight-Camera (Back), FaceTime-Camera (Front)) and an optimization mode for either better feature-recognition performance (HighPerformance) or better battery-life (BatteryLife)
        visage = Visage(cameraPosition: Visage.CameraDevice.faceTimeCamera, optimizeFor: Visage.DetectorAccuracy.higherPerformance)
        
        visage!.onlyFireNotificatonOnStatusChange = false
        
        //You need to call "beginFaceDetection" to start the detection, but also if you want to use the cameraView.
        visage!.beginFaceDetection()
        
        //This is a very simple cameraView you can use to preview the image that is seen by the camera.
        let cameraView = visage!.visageCameraView
        self.view.insertSubview(cameraView, at: 1)
        if (dataPass.faceIndicatorSwitch) {
            emojiLabel.text = "😃"
        } else {
            emojiLabel.text = " "
        }
        emojiLabel.font = UIFont.systemFont(ofSize: 50)
        emojiLabel.textAlignment = .center
        self.view.addSubview(emojiLabel)
        
        //Subscribing to the "visageFaceDetectedNotification" (for a list of all available notifications check out the "ReadMe" or switch to "Visage.swift") and reacting to it with a completionHandler. You can also use the other .addObserver-Methods to react to notifications.
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "visageFaceDetectedNotification"), object: nil, queue: OperationQueue.main, using: { notification in
            
            UIView.animate(withDuration: 0.5, animations: {
                self.emojiLabel.alpha = 1
            })
            
            self.isDetecting = true
            
            if (self.visage!.faceBounds != nil) {
                // Calculate Distances
                self.distanceLeftEyeToRightEye = self.euclideanDistance(self.visage!.leftEyePosition!, secondPoint: self.visage!.rightEyePosition!)
                self.distanceLeftEyeToMouth = self.euclideanDistance(self.visage!.leftEyePosition!, secondPoint: self.visage!.mouthPosition!)
                self.distanceRightEyeToMouth = self.euclideanDistance(self.visage!.rightEyePosition!, secondPoint: self.visage!.mouthPosition!)
                self.centerEye = CGPoint(x: (self.visage!.leftEyePosition!.x + self.visage!.rightEyePosition!.x)/2, y: (self.visage!.leftEyePosition!.y + self.visage!.rightEyePosition!.y)/2)
                self.distanceCenterEyeToMouth = self.euclideanDistance(self.centerEye!, secondPoint: self.visage!.mouthPosition!)
                
                // Calculate Ratio
                self.ratioLeftEyeToRightEyeAndCenterEyeToMouth = self.distanceLeftEyeToRightEye / self.distanceCenterEyeToMouth
                self.ratioLeftEyeToMouthAndRightEyeToMouth = self.distanceLeftEyeToMouth / self.distanceRightEyeToMouth
                self.ratioLeftEyeToMouthAndCenterEyeToMouth = self.distanceLeftEyeToMouth / self.distanceCenterEyeToMouth
                self.ratioRightEyeToMouthAndCenterEyeToMouth = self.distanceRightEyeToMouth / self.distanceCenterEyeToMouth
                
                // Determine Above or Below
                if (self.ratioLeftEyeToRightEyeAndCenterEyeToMouth >= 0.882389848) {
                    self.ratioLeftEyeToRightEyeAndCenterEyeToMouthIsAbove = true
                } else {
                    self.ratioLeftEyeToRightEyeAndCenterEyeToMouthIsAbove = false
                }
                if (self.ratioLeftEyeToMouthAndRightEyeToMouth >= 0.9968473554) {
                    self.ratioLeftEyeToMouthAndRightEyeToMouthIsAbove = true
                } else {
                    self.ratioLeftEyeToMouthAndRightEyeToMouthIsAbove = false
                }
                if (self.ratioLeftEyeToMouthAndCenterEyeToMouth >= 1.078119427) {
                    self.ratioLeftEyeToMouthAndCenterEyeToMouthIsAbove = true
                } else {
                    self.ratioLeftEyeToMouthAndCenterEyeToMouthIsAbove = false
                }
                if (self.ratioRightEyeToMouthAndCenterEyeToMouth >= 1.081694334) {
                    self.ratioRightEyeToMouthAndCenterEyeToMouthIsAbove = true
                } else {
                    self.ratioRightEyeToMouthAndCenterEyeToMouthIsAbove = false
                }
            }
        })
        
        // The same thing for the opposite, when no face is detected things are reset.
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "visageNoFaceDetectedNotification"), object: nil, queue: OperationQueue.main, using: { notification in
            
            UIView.animate(withDuration: 0.5, animations: {
                self.emojiLabel.alpha = 0.25
            })
            
            self.isDetecting = false
            
        })
    }
    
    // Stop stream
    func didPressTakePhoto(){
        visage!.endFaceDetection()
    }
    
    // Measure the distance between two points
    func euclideanDistance(_ firstPoint: CGPoint, secondPoint: CGPoint) -> Float {
        return Float(sqrt(pow(secondPoint.x-firstPoint.x,2)+pow(secondPoint.y-firstPoint.y,2)))
    }
    
    // Test id didTakePhoto has been set to true if it is restart the stream and reset the emoji if not end the stream
    func didPressTakeAnother(){
        if (didTakePhoto == true) {
            visage!.beginFaceDetection()
            if (dataPass.faceIndicatorSwitch) {
                emojiLabel.text = "😃"
            } else {
                emojiLabel.text = " "
            }
            self.didTakePhoto = false
        }
        else{
            self.didTakePhoto = true
            didPressTakePhoto()
            if (dataPass.genderIndicatorSwitch) {
                genderDetector()
            }
        }
    }
    
    // Function to call Naive Bayes Classifier and assign the gender to the emoji
    func genderDetector() {
        // Test to see if collected values are above or below the threshold and assign the propper value to them
        if (self.ratioLeftEyeToRightEyeAndCenterEyeToMouthIsAbove == true) {
            self.probabilityMaleGivenRatioLeftEyeToRightEyeAndCenterEyeToMouth = self.probabilityMaleGivenRatioLeftEyeToRightEyeAndCenterEyeToMouthIsAbove
            self.probabilityFemaleGivenLeftEyeToRightEyeAndCenterEyeToMouth = self.probabilityFemaleGivenRatioLeftEyeToRightEyeAndCenterEyeToMouthIsAbove
            
        } else {
            self.probabilityMaleGivenRatioLeftEyeToRightEyeAndCenterEyeToMouth = self.probabilityMaleGivenRatioLeftEyeToRightEyeAndCenterEyeToMouthIsBelow
            self.probabilityFemaleGivenLeftEyeToRightEyeAndCenterEyeToMouth = self.probabilityFemaleGivenRatioLeftEyeToRightEyeAndCenterEyeToMouthIsBelow
            
        }
        
        if (self.ratioLeftEyeToMouthAndRightEyeToMouthIsAbove == true) {
            self.probabilityMaleGivenRatioLeftEyeToMouthAndRightEyeToMouth = self.probabilityMaleGivenRatioLeftEyeToMouthAndRightEyeToMouthIsAbove
            self.probabilityFemaleGivenRatioLeftEyeToMouthAndRightEyeToMouth = self.probabilityFemaleGivenRatioLeftEyeToMouthAndRightEyeToMouthIsAbove
        } else {
            self.probabilityMaleGivenRatioLeftEyeToRightEyeAndCenterEyeToMouth = self.probabilityMaleGivenRatioLeftEyeToRightEyeAndCenterEyeToMouthIsBelow
            self.probabilityFemaleGivenLeftEyeToRightEyeAndCenterEyeToMouth = self.probabilityFemaleGivenRatioLeftEyeToRightEyeAndCenterEyeToMouthIsBelow
            
        }
        
        if (self.ratioLeftEyeToMouthAndCenterEyeToMouthIsAbove == true) {
            self.probabilityMaleGivenRatioLeftEyeToMouthAndCenterEyeToMouth = self.probabilityMaleGivenRatioLeftEyeToMouthAndCenterEyeToMouthIsAbove
            self.probabilityFemaleGivenRatioLeftEyeToMouthAndCenterEyeToMouth = self.probabilityFemaleGivenRatioLeftEyeToMouthAndCenterEyeToMouthIsAbove
            
        } else {
            self.probabilityMaleGivenRatioLeftEyeToMouthAndCenterEyeToMouth = self.probabilityMaleGivenRatioLeftEyeToMouthAndCenterEyeToMouthIsBelow
            self.probabilityFemaleGivenRatioLeftEyeToMouthAndCenterEyeToMouth = self.probabilityFemaleGivenRatioLeftEyeToMouthAndCenterEyeToMouthIsBelow
            
        }
        
        if (self.ratioRightEyeToMouthAndCenterEyeToMouthIsAbove == true) {
            self.probabilityMaleGivenRatioRightEyeToMouthAndCenterEyeToMouth = self.probabilityMaleGivenRatioRightEyeToMouthAndCenterEyeToMouthIsAbove
            self.probabilityFemaleGivenRatioRightEyeToMouthAndCenterEyeToMouth = self.probabilityFemaleGivenRatioRightEyeToMouthAndCenterEyeToMouthIsAbove
            
        } else {
            self.probabilityMaleGivenRatioRightEyeToMouthAndCenterEyeToMouth = self.probabilityMaleGivenRatioRightEyeToMouthAndCenterEyeToMouthIsBelow
            self.probabilityFemaleGivenRatioRightEyeToMouthAndCenterEyeToMouth = self.probabilityFemaleGivenRatioRightEyeToMouthAndCenterEyeToMouthIsBelow
            
        }
        
        // Determine the male and female likelyhoods based on the NB formula
        self.probabilityMale = self.probabilityMaleGivenRatioLeftEyeToRightEyeAndCenterEyeToMouth * self.probabilityMaleGivenRatioLeftEyeToMouthAndCenterEyeToMouth * self.probabilityMaleGivenRatioRightEyeToMouthAndCenterEyeToMouth * self.probabilityMaleGivenRatioRightEyeToMouthAndCenterEyeToMouth
        
        self.probabilityFemale = self.probabilityFemaleGivenLeftEyeToRightEyeAndCenterEyeToMouth * self.probabilityFemaleGivenRatioLeftEyeToMouthAndCenterEyeToMouth * self.probabilityFemaleGivenRatioRightEyeToMouthAndCenterEyeToMouth * self.probabilityFemaleGivenRatioRightEyeToMouthAndCenterEyeToMouth
        
        
        // Pass male and female percentages to the data view and assign the gender label
        if (isDetecting) {
            dataPass.malePercentage = (self.probabilityMale)/(self.probabilityMale + self.probabilityFemale)
            dataPass.femalePercentage = (self.probabilityFemale)/(self.probabilityMale + self.probabilityFemale)
            
            // Male test
            if (self.probabilityMale > self.probabilityFemale) {
                if (dataPass.genderIndicatorSwitch) {
                    if (dataPass.genderIndicatorColorSliderValue > 0.835) {
                        emojiLabel.text = "👦🏿"
                    } else if (dataPass.genderIndicatorColorSliderValue > 0.668) {
                        emojiLabel.text = "👦🏾"
                    } else if (dataPass.genderIndicatorColorSliderValue > 0.501) {
                        emojiLabel.text = "👦🏽"
                    } else if (dataPass.genderIndicatorColorSliderValue > 0.334) {
                        emojiLabel.text = "👦"
                    } else if (dataPass.genderIndicatorColorSliderValue > 0.167) {
                        emojiLabel.text = "👦🏼"
                    } else if (dataPass.genderIndicatorColorSliderValue >= 0.000) {
                        emojiLabel.text = "👦🏻"
                    }
                    
                // Female test
                } } else if (self.probabilityFemale > self.probabilityMale) {
                if (dataPass.genderIndicatorSwitch) {
                    if (dataPass.genderIndicatorColorSliderValue > 0.835) {
                        emojiLabel.text = "👧🏿"
                    } else if (dataPass.genderIndicatorColorSliderValue > 0.668) {
                        emojiLabel.text = "👧🏾"
                    } else if (dataPass.genderIndicatorColorSliderValue > 0.501) {
                        emojiLabel.text = "👧🏽"
                    } else if (dataPass.genderIndicatorColorSliderValue > 0.334) {
                        emojiLabel.text = "👧"
                    } else if (dataPass.genderIndicatorColorSliderValue > 0.167) {
                        emojiLabel.text = "👧🏼"
                    } else if (dataPass.genderIndicatorColorSliderValue >= 0.000) {
                        emojiLabel.text = "👧🏻"
                    }
                
                // If both are exactly equal return the 😃
                } } else {
                if (dataPass.faceIndicatorSwitch) {
                    emojiLabel.text = "😃"
                } else {
                    emojiLabel.text = " "
                }
                UIView.animate(withDuration: 0.5, animations: {
                    self.emojiLabel.alpha = 0.25
                })
            }
        }
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        didPressTakeAnother()
    }
    
}

