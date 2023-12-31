//
//  IntroView.swift
//  RealTraining
//
//  Created by yc on 2023/09/09.
//

import UIKit
import SnapKit
import Then

protocol IntroViewDelegate: AnyObject {
    func introView(_ iv: IntroView, didTapStartButton startButton: UIButton)
    func rotate()
}

final class IntroView: UIView {
    
    enum Mode {
        case rt
        
        var texts: (enTitle: String, koTitle: String, desc: String) {
            switch self {
            case .rt:
                return ("Real Training", "리얼 트레이닝", "학습한 표현을 활용하여 영어문장을 만들어보고\n원어민의 발음과 억양을 주의하여 문장을 따라 말해보세요.")
            }
        }
    }
    
    weak var delegate: IntroViewDelegate?
    
    private lazy var topView = UIView().then { $0.isUserInteractionEnabled = false }
    private lazy var bottomView = UIView().then { $0.isUserInteractionEnabled = false }
    
    private lazy var enTitleLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.text = mode.texts.enTitle
    }
    
    private lazy var koTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 36, weight: .heavy)
        $0.text = mode.texts.koTitle
    }
    
    private lazy var titleUnderlineView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = mode.texts.desc
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .lightGray
    }
    
    private lazy var startButton = UIButton().then {
        var titleConfig = AttributeContainer()
        
        titleConfig.foregroundColor = .white
        titleConfig.font = .systemFont(ofSize: 20, weight: .heavy)
        
        var buttonConfig = UIButton.Configuration.filled()
        
        buttonConfig.attributedTitle = AttributedString(
            "시작하기",
            attributes: titleConfig
        )
        buttonConfig.image = UIImage(systemName: "chevron.right.2")
        buttonConfig.imagePlacement = .trailing
        buttonConfig.imagePadding = 8
        buttonConfig.baseBackgroundColor = .init(
            red: 239 / 255,
            green: 64 / 255,
            blue: 64 / 255,
            alpha: 1
        )
        
        $0.configuration = buttonConfig
        
        $0.addTarget(
            self,
            action: #selector(didTapStartButton),
            for: .touchUpInside
        )
    }
    
    private lazy var rotateButton = UIButton().then {
        $0.setImage(
            UIImage(systemName: "arrow.triangle.2.circlepath.circle"),
            for: .normal
        )
        $0.tintColor = .lightGray
        $0.addTarget(
            self,
            action: #selector(didTapRotateButton),
            for: .touchUpInside
        )
    }
    
    private let mode: Mode
    
    init(mode: Mode) {
        self.mode = mode
        super.init(frame: .zero)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapStartButton(_ sender: UIButton) {
        sender.isEnabled = false
        delegate?.introView(self, didTapStartButton: sender)
    }
    
    @objc func didTapRotateButton(_ sender: UIButton) {
        delegate?.rotate()
        
        setupLayout()
    }
    
    override func updateConstraints() {
        print("HELLO1")
        super.updateConstraints()
        print("HELLO2")
    }   //
    
    private func setupLayout() {
        [
            topView,
            bottomView,
            enTitleLabel,
            koTitleLabel,
            titleUnderlineView,
            descriptionLabel,
            startButton,
            rotateButton
        ].forEach {
            $0.snp.removeConstraints()
            $0.removeFromSuperview()
        }
        
        if OrientationManager.landscapeSupported {
            [
                descriptionLabel,
                enTitleLabel,
                koTitleLabel,
                titleUnderlineView,
                startButton,
                rotateButton,
                rotateButton
            ].forEach {
                addSubview($0)
            }
            
            enTitleLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(16)
                $0.leading.equalTo(koTitleLabel.snp.leading)
            }
            
            koTitleLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(enTitleLabel.snp.bottom).offset(4)
            }
            
            titleUnderlineView.snp.makeConstraints {
                $0.leading.trailing.equalTo(koTitleLabel).inset(-4)
                $0.height.equalTo(2)
                $0.top.equalTo(koTitleLabel.snp.bottom)
            }
            
            descriptionLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(16)
            }
            
            startButton.snp.makeConstraints {
                $0.width.equalToSuperview().dividedBy(2.0)
                $0.bottom.equalToSuperview().inset(16)
                $0.height.equalTo(50)
                $0.centerX.equalToSuperview()
            }
            
            rotateButton.snp.makeConstraints {
                $0.size.equalTo(50)
                $0.trailing.bottom.equalToSuperview().inset(16)
            }
            rotateButton.imageView?.snp.makeConstraints {
                $0.size.equalTo(50)
            }
            
        } else {
            [
                topView,
                bottomView
            ].forEach {
                addSubview($0)
            }
            
            topView.snp.makeConstraints {
                $0.leading.top.trailing.equalToSuperview()
                $0.height.equalToSuperview().multipliedBy(0.7)
            }
            
            bottomView.snp.makeConstraints {
                $0.leading.bottom.trailing.equalToSuperview()
                $0.height.equalToSuperview().multipliedBy(0.3)
            }
            
            [
                enTitleLabel,
                koTitleLabel,
                titleUnderlineView,
                descriptionLabel
            ].forEach {
                topView.addSubview($0)
            }
            
            enTitleLabel.snp.makeConstraints {
                $0.bottom.equalTo(koTitleLabel.snp.top).offset(-4)
                $0.leading.equalTo(koTitleLabel.snp.leading)
            }
            
            koTitleLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().multipliedBy(0.64)
            }
            
            titleUnderlineView.snp.makeConstraints {
                $0.top.equalTo(koTitleLabel.snp.bottom).offset(4)
                $0.leading.trailing.equalTo(koTitleLabel).inset(-4)
                $0.height.equalTo(2)
            }
            
            descriptionLabel.snp.makeConstraints {
                $0.top.equalTo(titleUnderlineView.snp.bottom).offset(56)
                $0.leading.trailing.equalToSuperview().inset(16)
            }
            
            [
                startButton,
                rotateButton
            ].forEach {
                addSubview($0)
            }
            
            startButton.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.centerY.equalTo(bottomView.snp.top)
                $0.height.equalTo(50)
            }
            
            rotateButton.snp.makeConstraints {
                $0.size.equalTo(50)
                $0.trailing.bottom.equalToSuperview().inset(16)
            }
            rotateButton.imageView?.snp.makeConstraints {
                $0.size.equalTo(50)
            }
        }
    }
}
