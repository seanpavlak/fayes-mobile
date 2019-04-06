//
//  WebViewController.swift
//  Created by Sean Pavlak on 10/4/18.
//

import UIKit
import ChameleonFramework
import NVActivityIndicatorView

class WebViewController: UIViewController, UIWebViewDelegate {
    var url: String = "" {
        didSet {
            let weburl = URL(string: url)
            let request = NSMutableURLRequest(url: weburl!)
            
            webView.loadRequest(request as URLRequest)
            webView.reload()
        }
    }
    
    let activityIndicatorView: NVActivityIndicatorView = {
        let indicatorView = NVActivityIndicatorView(frame: CGRect.zero)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.type = NVActivityIndicatorType.circleStrokeSpin
        indicatorView.color = UIColor.flatWatermelonDark
        return indicatorView
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.flatWhite
        
        return view
    }()
    
    let webView: UIWebView = {
        let view = UIWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.allowsInlineMediaPlayback = true
        view.allowsLinkPreview = true
        view.allowsPictureInPictureMediaPlayback = true
        view.mediaPlaybackAllowsAirPlay = true
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.flatWhite
        webView.delegate = self
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        view.addSubview(activityIndicatorView)
        view.bringSubviewToFront(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        // backgroundView
        view.addSubview(backgroundView)
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        
        // webView
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        webView.scalesPageToFit = true
        webView.isHidden = true
        
        
        // activityIndicatorView
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalTo: activityIndicatorView.heightAnchor, constant: 0.0).isActive = true
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView) {
        activityIndicatorView.stopAnimating()
        webView.isHidden = false
    }
}
