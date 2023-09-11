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
    func introView(_ iv: IntroView, didTapStartButton: UIButton)
}

final class IntroView: UIView {
    
    weak var delegate: IntroViewDelegate?
    
    private lazy var topView = UIView()
    private lazy var bottomView = UIView()
    
    private lazy var enTitleLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.text = "Real Training"
    }
    
    private lazy var koTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 36, weight: .heavy)
        $0.text = "리얼 트레이닝"
    }
    
    private lazy var titleUnderlineView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "학습한 표현을 활용하여 영어문장을 만들어보고\n원어민의 발음과 억양을 주의하여 문장을 따라 말해보세요."
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
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapStartButton(_ sender: UIButton) {
        delegate?.introView(self, didTapStartButton: sender)
    }
    
    private func setupLayout() {
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
            startButton
        ].forEach {
            bottomView.addSubview($0)
        }
        
        startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(bottomView.snp.top)
            $0.height.equalTo(50)
        }
    }
}
