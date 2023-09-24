//
//  StudyThumbnailView.swift
//  RealTraining
//
//  Created by yc on 2023/09/09.
//

import UIKit
import SnapKit
import Then

protocol StudyThumbnailViewDelegate: AnyObject {
    func studyView(_ sv: StudyThumbnailView, didTapStartButton startButton: UIButton)
}

final class StudyThumbnailView: UIView {
    let studyInfo: RtQuiz
    
    weak var delegate: StudyThumbnailViewDelegate?
    
    private lazy var thumbnailView = UIImageView().then {
        $0.backgroundColor = .secondarySystemBackground
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var questionLabel = UILabel().then {
        $0.text = "주어진 문장을 영어로 생각해 보세요."
        $0.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.textAlignment = .center
    }
    
    private lazy var bubbleBorderView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.layer.borderColor = .init(
            red: 251 / 255,
            green: 184 / 255,
            blue: 70 / 255,
            alpha: 1
        )
        $0.layer.borderWidth = 3
    }
    
    private lazy var sentenceLabel = UILabel().then {
        $0.text = studyInfo.contentKor
        $0.font = .systemFont(ofSize: 16, weight: .heavy)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var startButton = UIButton().then {
        var titleConfig = AttributeContainer()
        
        titleConfig.foregroundColor = .white
        titleConfig.font = .systemFont(ofSize: 20, weight: .heavy)
        
        var buttonConfig = UIButton.Configuration.filled()
        
        buttonConfig.attributedTitle = AttributedString(
            "계속하기",
            attributes: titleConfig
        )
        buttonConfig.image = UIImage(systemName: "arrow.forward.circle")
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
    
    init(studyInfo: RtQuiz) {
        self.studyInfo = studyInfo
        
        super.init(frame: .zero)
        backgroundColor = .white
        setupLayout()
        
        setThumbnailImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapStartButton(_ sender: UIButton) {
        sender.isEnabled = false
        delegate?.studyView(self, didTapStartButton: sender)
    }
    
    private func setThumbnailImage() {
        let urlString = studyInfo.quizMakeup.bgImg
        
        ImageFetcher.fetch(urlString) { image in
            DispatchQueue.main.async {
                self.thumbnailView.image = image
            }
        }
    }
    
    private func setupLayout() {
        [
            thumbnailView,
            questionLabel,
            bubbleBorderView,
            sentenceLabel,
            startButton
        ].forEach {
            addSubview($0)
        }
        
        thumbnailView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(thumbnailView.snp.width).multipliedBy(9.0 / 16.0)
        }
        
        questionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(thumbnailView.snp.bottom).offset(32)
        }
        
        bubbleBorderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(questionLabel.snp.bottom).offset(32)
            $0.bottom.equalTo(snp.centerY).multipliedBy(1.4)
        }
        
        sentenceLabel.snp.makeConstraints {
            $0.centerY.equalTo(bubbleBorderView.snp.centerY)
            $0.leading.trailing.equalTo(bubbleBorderView).inset(16)
        }
        
        startButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
}
