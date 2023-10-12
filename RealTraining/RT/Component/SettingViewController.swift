//
//  SettingViewController.swift
//  RealTraining
//
//  Created by yc on 2023/10/12.
//

import UIKit
import SnapKit
import Then

final class SettingViewController: UIViewController {
    
    enum SettingType {
        case fxVolume(Int)
        case recordFx(Int)
        
        var icon: UIImage? {
            switch self {
            case .fxVolume(_):
                return UIImage(systemName: "speaker.wave.3")
            case .recordFx(_):
                return UIImage(systemName: "mic.fill")
            }
        }
        
        var title: String {
            switch self {
            case .fxVolume(_):
                return "효과음"
            case .recordFx(_):
                return "녹음 시작음"
            }
        }
    }
    
    let settingTypes: [SettingType]
    
    init(settingTypes: [SettingType]) {
        self.settingTypes = settingTypes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var backgroundDimView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.75)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
        
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tapGesture)
    }
    
    private lazy var settingView = UIView().then {
        $0.backgroundColor = .white
        $0.isHidden = true
    }
    
    private lazy var settingStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        setupLayout()
        setupSettingButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        settingView.transform = CGAffineTransform(translationX: 0, y: settingView.bounds.height)
        settingView.isHidden = false
        
        UIView.animate(withDuration: 0.2) {
            self.settingView.transform = .identity
        }
    }
    
    @objc func didTapBackgroundView() {
        dismiss(animated: false)
    }
    
    private func setupSettingButton() {
        let topBarView = UIView().then {
            $0.backgroundColor = .secondarySystemBackground
        }
        
        let topBarTitleLabel = UILabel().then {
            $0.text = "학습 설정"
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 16, weight: .medium)
        }
        
        let xmarkImageView = UIImageView(image: UIImage(systemName: "xmark")).then {
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .black
            $0.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
            $0.addGestureRecognizer(tapGesture)
        }
        
        [
            topBarTitleLabel,
            xmarkImageView
        ].forEach {
            topBarView.addSubview($0)
        }
        
        topBarTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        xmarkImageView.snp.makeConstraints {
            $0.leading.equalTo(topBarTitleLabel.snp.trailing).offset(16)
            $0.top.trailing.bottom.equalToSuperview().inset(16)
            $0.size.equalTo(30)
        }
        
        settingStackView.addArrangedSubview(topBarView)
        
        for type in settingTypes {
            let settingButton = UIView()
            
            let icon = type.icon
            
            let title = type.title
            
            var currentValue = ""
            
            switch type {
            case .fxVolume(let v):
                currentValue = "\(v)%"
            case .recordFx(let v):
                currentValue = "효과음\(v)"
            }
            
            let iconImageView = UIImageView(image: icon).then {
                $0.contentMode = .scaleAspectFit
                $0.tintColor = .black
            }
            
            let titleLabel = UILabel().then {
                $0.text = title
                $0.textColor = .black
                $0.font = .systemFont(ofSize: 16, weight: .medium)
            }
            
            let currentValueLabel = UILabel().then {
                $0.text = currentValue
                $0.textColor = .darkGray
                $0.font = .systemFont(ofSize: 16, weight: .semibold)
            }
            
            [
                iconImageView,
                titleLabel,
                currentValueLabel
            ].forEach {
                settingButton.addSubview($0)
            }
            
            iconImageView.snp.makeConstraints {
                $0.leading.top.bottom.equalToSuperview().inset(16)
                $0.size.equalTo(30)
            }
            
            titleLabel.snp.makeConstraints {
                $0.leading.equalTo(iconImageView.snp.trailing).offset(16)
                $0.centerY.equalToSuperview()
            }
            
            currentValueLabel.snp.makeConstraints {
                $0.leading.equalTo(titleLabel.snp.trailing).offset(16)
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(16)
            }
            
            titleLabel.snp.contentHuggingHorizontalPriority = 600
            currentValueLabel.snp.contentHuggingHorizontalPriority = 700
            
            let separator = UIView().then {
                $0.backgroundColor = .separator
            }
            
            separator.snp.makeConstraints {
                $0.height.equalTo(0.4)
            }
            
            settingStackView.addArrangedSubview(separator)
            settingStackView.addArrangedSubview(settingButton)
        }
    }
    
    private func setupLayout() {
        [
            backgroundDimView,
            settingView
        ].forEach {
            view.addSubview($0)
        }
        
        backgroundDimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        settingView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        settingView.addSubview(settingStackView)
        
        let window = UIApplication.shared.windows.first
        let bottom = window?.safeAreaInsets.bottom ?? 0
        
        settingStackView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(bottom)
        }
    }
}
