//
//  PopupViewController.swift
//  RealTraining
//
//  Created by yc on 2023/09/30.
//

import UIKit
import SnapKit
import Then

final class PopupViewController: UIViewController {
    
    enum ButtonType {
        case one(title: String, action: () -> Void)
        case leftAndRight(
            leftTitle: String,
            leftAction: (() -> Void)?,
            rightTitle: String,
            rightAction: (() -> Void)?
        )
    }
    
    private var _isBackgroundTapDismissEnabled = false
    
    var isBackgroundTapDismissEnabled: Bool {
        get {
            return _isBackgroundTapDismissEnabled
        }
        
        set {
            _isBackgroundTapDismissEnabled = newValue
            
            if newValue {
                view.isUserInteractionEnabled = true
                
                view.addGestureRecognizer(backgroundTapGesture)
            } else {
                view.isUserInteractionEnabled = false
                
                view.removeGestureRecognizer(backgroundTapGesture)
            }
        }
    }
    
    private var leftButtonAction: (() -> Void)?
    private var rightButtonAction: (() -> Void)?
    
    private lazy var backgroundTapGesture = UITapGestureRecognizer(
        target: self,
        action: #selector(didTapBackground)
    )
    
    private lazy var popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .center
    }
    
    private lazy var messageLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var leftButton = UIButton().then {
        $0.backgroundColor = .init(red: 183 / 255, green: 183 / 255, blue: 183 / 255, alpha: 1)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.addTarget(
            self,
            action: #selector(didTapLeftButton),
            for: .touchUpInside
        )
    }
    
    private lazy var rightButton = UIButton().then {
        $0.backgroundColor = .init(red: 255 / 255, green: 109 / 255, blue: 102 / 255, alpha: 1)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.addTarget(
            self,
            action: #selector(didTapRightButton),
            for: .touchUpInside
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.75)
    }
    
    @objc func didTapBackground() {
        dismiss(animated: false)
    }
    
    @objc func didTapLeftButton() {
        dismiss(animated: false, completion: leftButtonAction)
    }
    @objc func didTapRightButton() {
        dismiss(animated: false, completion: rightButtonAction)
    }
    
    func setupView(
        title: String,
        message: String,
        buttonType: ButtonType
    ) {
        setupLayout()
        
        titleLabel.text = title
        messageLabel.text = message
        
        [
            titleLabel,
            messageLabel,
            leftButton,
            rightButton
        ].forEach {
            popupView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(32)
        }
        
        messageLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.bottom.equalTo(rightButton.snp.top).offset(-40)
        }
        
        leftButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.bottom.equalToSuperview()
            $0.trailing.equalTo(popupView.snp.centerX)
        }
        
        rightButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(popupView.snp.centerX)
        }
        
        switch buttonType {
        case .one(let title, let action):
            rightButton.setTitle(title, for: .normal)
            rightButtonAction = action
            
            leftButton.removeFromSuperview()
            
            rightButton.snp.makeConstraints {
                $0.leading.equalToSuperview()
            }
        case .leftAndRight(let leftTitle, let leftAction, let rightTitle, let rightAction):
            leftButton.setTitle(leftTitle, for: .normal)
            leftButtonAction = leftAction
            rightButton.setTitle(rightTitle, for: .normal)
            rightButtonAction = rightAction
        }
    }
    
    private func setupLayout() {
        view.addSubview(popupView)
        
        popupView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY)
        }
    }
}
