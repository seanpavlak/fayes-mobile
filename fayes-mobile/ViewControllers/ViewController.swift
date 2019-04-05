//
//  ViewController.swift
//  fayes-mobile
//
//  Created by Sean Pavlak on 4/5/19.
//  Copyright © 2019 Kaldr Industries. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the three nib views
        let topView : settingsView = settingsView(nibName: "settingsView", bundle: nil)
        let midView : cameraView = cameraView(nibName: "cameraView", bundle: nil)
        let botView : dataView = dataView(nibName: "dataView", bundle: nil)
        
        // scrollView
        view.insertSubview(scrollView, aboveSubview: view)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        
        // Add the views to a scroll view
        self.addChild(topView)
        self.scrollView.addSubview(topView.view)
        topView.didMove(toParent: self)
        
        self.addChild(midView)
        self.scrollView.addSubview(midView.view)
        midView.didMove(toParent: self)
        
        self.addChild(botView)
        self.scrollView.addSubview(botView.view)
        botView.didMove(toParent: self)
        
        
        // Add the middle view in a frame vertically below the top view
        var midViewFrame : CGRect = midView.view.frame
        midViewFrame.origin.y = self.view.frame.height
        midView.view.frame = midViewFrame
        
        // Add the bottom view in a frame vertically below the middle view
        var botViewFrame : CGRect = botView.view.frame
        botViewFrame.origin.y = self.view.frame.height * 2
        botView.view.frame = botViewFrame
        
        // Adjust the height of the scroll view to fit all three frames.
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 3)
        
        // Start the scroll view at the middle view
        scrollView.contentOffset.y = self.view.frame.size.height
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
