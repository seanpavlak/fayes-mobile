//
//  CaptureViewController.swift
//  Created by Sean Pavlak on 04/05/19.
//

import UIKit
import AVFoundation
import ChameleonFramework
import Vision

class CaptureViewController: UIViewController {
    let faceDetector = FaceLandmarksDetector()
    let captureSession = AVCaptureSession()

    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    let captureButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 36
        button.layer.borderWidth = 4.0
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = UIColor.flatWhite.cgColor
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSelf()
        setupViews()
        configureDevice()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupSelf() {
        view.backgroundColor = UIColor.flatWhite

        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "material-dehaze"), style: .plain, target: self, action: #selector(settingsButtonTapped(button:)))
        settingsButton.tintColor = UIColor.flatBlack
        navigationItem.leftBarButtonItem = settingsButton
                
        navigationItem.title = "Fayes"
    }
    
    private func setupViews() {
        let safeAreaLayoutGuide: UILayoutGuide = view.safeAreaLayoutGuide

        // imageView
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0.0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        
        // captureButton
        view.insertSubview(captureButton, aboveSubview: imageView)
        captureButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20.0).isActive = true
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        captureButton.heightAnchor.constraint(equalToConstant: 72.0).isActive = true
        captureButton.widthAnchor.constraint(equalTo: captureButton.heightAnchor, constant: 0.0).isActive = true
        captureButton.addTarget(self, action: #selector(captureFeatures), for: .touchUpInside)
    }
    
    private func getDevice() -> AVCaptureDevice? {
        let discoverSession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInTelephotoCamera, .builtInWideAngleCamera], mediaType: .video, position: .front)
        return discoverSession.devices.first
    }
    
    private func configureDevice() {
        if let device = getDevice() {
            do {
                try device.lockForConfiguration()
                if device.isFocusModeSupported(.continuousAutoFocus) {
                    device.focusMode = .continuousAutoFocus
                }
                device.unlockForConfiguration()
            } catch { print("failed to lock config") }
            
            do {
                let input = try AVCaptureDeviceInput(device: device)
                captureSession.addInput(input)
            } catch { print("failed to create AVCaptureDeviceInput") }
            
            captureSession.startRunning()
            
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.videoSettings = [String(kCVPixelBufferPixelFormatTypeKey): Int(kCVPixelFormatType_32BGRA)]
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .utility))
            
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
        }
    }
    
    @objc func captureFeatures(_ sender: Any) {
    }
    
    @objc private func settingsButtonTapped(button: UIButton) {
        let settingsViewController = SettingsViewController()
        
        var navigationController = UINavigationController()
        
        navigationController = UINavigationController(rootViewController: settingsViewController)
        navigationController.navigationBar.barTintColor = UIColor.flatWhite
        navigationController.navigationBar.isTranslucent = false
        
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension CaptureViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let maxSize = CGSize(width: 1024, height: 1024)
        
        if let image = UIImage(sampleBuffer: sampleBuffer)?.flipped()?.imageWithAspectFit(size: maxSize) {
            faceDetector.highlightFaces(for: image) { (resultImage) in
                DispatchQueue.main.async {
                    self.imageView.image = resultImage
                }
            }
        }
    }
}

