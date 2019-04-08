//
//  AnalysisViewController.swift
//  Created by Sean Pavlak on 04/05/19.
//

import AloeStackView
import UIKit
import ChameleonFramework

public class AnalysisViewController: AloeStackViewController {
    var features: features?
    var arrangedViews: [UIView] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupSelf()
        setupStackView()
        setupFeaturesModel()
        setupRows()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        arrangedViews = []
        stackView.removeAllRows()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        if arrangedViews.isEmpty {
            setupRows()
        }
    }
    
    private func setupFeaturesModel() {
        getFeatureDistance()
        getFeatureRatio()
        getFeatureComparison()
    }
    
    private func getFeatureDistance() {
        guard let leftEyePoint = features?.leftEyePoint else { return }
        guard let rightEyePoint = features?.rightEyePoint else { return }
        guard let centerEyePoint = features?.centerEyePoint else { return }
        guard let mouthPoint = features?.mouthPoint else { return }

        features?.lereDistance = leftEyePoint.distance(to: rightEyePoint)
        features?.lemDistance = leftEyePoint.distance(to: mouthPoint)
        features?.remDistance = rightEyePoint.distance(to: mouthPoint)
        features?.cemDistance = centerEyePoint.distance(to: mouthPoint)
    }
    
    private func getFeatureRatio() {
        guard let lereDistance = features?.lereDistance else { return }
        guard let lemDistance = features?.lemDistance else { return }
        guard let remDistance = features?.remDistance else { return }
        guard let cemDistance = features?.cemDistance else { return }

        features?.lereCemRatio = lereDistance/cemDistance
        features?.lemRemRatio = lemDistance/remDistance
        features?.lemCemRatio = lemDistance/cemDistance
        features?.remCemRatio = remDistance/cemDistance
    }
    
    private func getFeatureComparison() {
        guard let lereCemRatio = features?.lereCemRatio else { return }
        guard let lemRemRatio = features?.lemRemRatio else { return }
        guard let lemCemRatio = features?.lemCemRatio else { return }
        guard let remCemRatio = features?.remCemRatio else { return }
        
        features?.lereCemRatioAbove = lereCemRatio >= NBTrainingData.LereCem.average
        features?.lemRemRatioAbove = lemRemRatio >= NBTrainingData.LemRem.average
        features?.lemCemRatioAbove = lemCemRatio >= NBTrainingData.LemCem.average
        features?.remCemRatioAbove = remCemRatio >= NBTrainingData.RemCem.average
    }

    
    private func setupSelf() {
        definesPresentationContext = true
        
        title = "Analysis"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        view.backgroundColor = UIColor("#EFEFF4")
        
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissButtonTapped(button:)))
        dismissButton.tintColor = .black
        navigationItem.leftBarButtonItem = dismissButton
    }
    
    private func setupStackView() {
        stackView.backgroundColor = UIColor("#EFEFF4")
        stackView.automaticallyHidesLastSeparator = true
        stackView.hidesSeparatorsByDefault = true
        stackView.rowInset.top = 0.0
        stackView.rowInset.bottom = 0.0
        stackView.rowInset.left = 0.0
        stackView.rowInset.right = 0.0
    }
    
    private func setupRows() {
        setupSpacerView(ofHeight: 18.0)
        
        setupEmojiView()
        
        setupSpacerView(ofHeight: 18.0)

        setupNavigationRow(icon: #imageLiteral(resourceName: "fayes-masculine"), color: .flatPowderBlueDark, value: "Masculine Percentage", subValue: "0.0%")
        setupNavigationRow(icon: #imageLiteral(resourceName: "fayes-feminine"), color: .flatPink, value: "Feminine Percentage", subValue: "0.0%", isLast: true)

        setupNavigationRow(icon: #imageLiteral(resourceName: "fayes-LERE"), color: .flatRed, value: "LERE Distance", subValue: "\(features?.lereDistance?.rounded(to: 2) ?? "0.00") dpi")
        setupNavigationRow(icon: #imageLiteral(resourceName: "fayes-LEM"), color: .flatOrange, value: "LEM Distance", subValue: "\(features?.lemDistance?.rounded(to: 2) ?? "0.00") dpi")
        setupNavigationRow(icon: #imageLiteral(resourceName: "fayes-REM"), color: .flatYellow, value: "REM Distance", subValue: "\(features?.remDistance?.rounded(to: 2) ?? "0.00") dpi")
        setupNavigationRow(icon: #imageLiteral(resourceName: "fayes-CEM"), color: .flatLime, value: "CEM Distance", subValue: "\(features?.cemDistance?.rounded(to: 2) ?? "0.00") dpi", isLast: true)
        
        setupNavigationRow(icon: #imageLiteral(resourceName: "fayes-LERE_CEM"), color: .flatGreen, value: "LERE - CEM Ratio", subValue: "\(features?.lereCemRatio?.rounded(to: 3) ?? "0.000")")
        setupNavigationRow(icon: #imageLiteral(resourceName: "fayes-LEM_REM"), color: .flatMint, value: "LEM - REM Ratio", subValue: "\(features?.lemRemRatio?.rounded(to: 3) ?? "0.000")")
        setupNavigationRow(icon: #imageLiteral(resourceName: "fayes-LEM_CEM"), color: .flatBlue, value: "LEM - CEM Ratio", subValue: "\(features?.lemCemRatio?.rounded(to: 3) ?? "0.000")")
        setupNavigationRow(icon: #imageLiteral(resourceName: "fayes-REM_CEM"), color: .flatPurpleDark, value: "REM - CEM Ratio", subValue: "\(features?.remCemRatio?.rounded(to: 3) ?? "0.000")", isLast: true)
    }
    
    private func setupEmojiView() {
        let containerView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let masculineEmojiLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            
            label.font = UIFont.systemFont(ofSize: 60.0)
            label.numberOfLines = 1
            label.textAlignment = .right
            label.text = "👦🏽"
            label.alpha = 0.33

            return label
        }()
        
        let feminineEmojiLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            
            label.font = UIFont.systemFont(ofSize: 60.0)
            label.numberOfLines = 1
            label.textAlignment = .left
            label.text = "👧🏽"
            label.alpha = 0.33
            
            return label
        }()

        
        containerView.addSubview(masculineEmojiLabel)
        masculineEmojiLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0).isActive = true
        masculineEmojiLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0).isActive = true
        masculineEmojiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0.0).isActive = true
        masculineEmojiLabel.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -6.0).isActive = true
        
        containerView.addSubview(feminineEmojiLabel)
        feminineEmojiLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0).isActive = true
        feminineEmojiLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0).isActive = true
        feminineEmojiLabel.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 6.0).isActive = true
        feminineEmojiLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0.0).isActive = true

        stackView.addRow(containerView)
    }
    
    private func setupNavigationRow(icon: UIImage, color: UIColor? = nil, value: String, subValue: String? = nil, isNavigator: Bool = false, isLast: Bool = false, isFinal: Bool = false, completion: (() -> Void)? = {}) {
        let containerView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor("#FFFFFF")
            
            return view
        }()
        
        let valueLabelView: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 1
            label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.regular)
            label.textAlignment = .left
            label.textColor = UIColor("#3A4759")
            label.text = value
            
            return label
        }()
        
        let subValueLabelView: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 1
            label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.regular)
            label.textAlignment = .left
            label.textColor = UIColor("#A8B2C1")
            label.text = subValue
            
            return label
        }()
        
        let iconImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = true
            imageView.image = icon
            imageView.tintColor = color != nil ? color : "\(value), \(String(describing: index))".toColor()
            
            return imageView
        }()
        
        let indicatorImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = true
            imageView.image = #imageLiteral(resourceName: "material-chevron-right")
            imageView.tintColor = UIColor("#C8C7CC")
            
            return imageView
        }()
        
        let dividerLineView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor("#C8C7CC").withAlphaComponent(0.4)
            view.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
            
            return view
        }()
        
        containerView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        // iconImageView
        containerView.addSubview(iconImageView)
        iconImageView.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor, constant: 0.0).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0.0).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12.0).isActive = true
        
        // valueLabelView
        containerView.addSubview(valueLabelView)
        valueLabelView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0.0).isActive = true
        valueLabelView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12.0).isActive = true
        
        // indicatorImageView
        if isNavigator {
            containerView.addSubview(indicatorImageView)
            indicatorImageView.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
            indicatorImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0.0).isActive = true
            indicatorImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12.0).isActive = true
        }
        
        // subValueLabelView
        containerView.addSubview(subValueLabelView)
        subValueLabelView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0.0).isActive = true
        subValueLabelView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: isNavigator ? -36.0 : -12.0).isActive = true
        
        // dividerLineView
        if !isLast {
            containerView.addSubview(dividerLineView)
            dividerLineView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0).isActive = true
            dividerLineView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8.0).isActive = true
            dividerLineView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0.0).isActive = true
        }
        
        arrangedViews.append(containerView)
        stackView.addRow(containerView)
        stackView.setTapHandler(forRow: containerView) { [weak self] _ in
            guard self != nil else { return }
            completion!()
        }
        
        if isLast {
            setupSpacerView(ofHeight: 18.0, withFooter: isFinal)
        }
    }
    
    private func setupSpacerView(ofHeight height: CGFloat, withFooter isFooter: Bool? = nil) {
        let isStaging: Bool = false
        
        let containerView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            
            if let isFooter = isFooter, isFooter && isStaging {
                view.heightAnchor.constraint(equalToConstant: height * 2).isActive = true
            } else {
                view.heightAnchor.constraint(equalToConstant: height).isActive = true
            }
            
            return view
        }()
        
        let stagingLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 1
            label.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.regular)
            label.textAlignment = .left
            label.textColor = UIColor("#A8B2C1")
            label.text = isStaging ? NSLocalizedString("StagingEnvironment", comment: "Staging Environment") : ""
            
            return label
        }()
        
        // stagingLabel
        if let isFooter = isFooter, isFooter {
            containerView.addSubview(stagingLabel)
            stagingLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0).isActive = true
            stagingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: height).isActive = true
        }
        
        
        let versionLabel: UILabel = {
            let version = getAppInfo()
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 1
            label.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.regular)
            label.textAlignment = .left
            label.textColor = UIColor("#A8B2C1")
            label.text = "Version: \(version)"
            
            return label
        }()
        
        // versionLabel
        if let isFooter = isFooter, isFooter {
            containerView.addSubview(versionLabel)
            versionLabel.bottomAnchor.constraint(equalTo: stagingLabel.topAnchor, constant: 0.0).isActive = true
            versionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: height).isActive = true
        }
        
        arrangedViews.append(containerView)
        stackView.addRow(containerView)
    }
    
    private func presentViewController(_ vc: UIViewController) {
        vc.title = self.title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func dismissButtonTapped(button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
