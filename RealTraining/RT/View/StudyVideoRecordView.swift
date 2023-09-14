//
//  StudyVideoRecordView.swift
//  RealTraining
//
//  Created by yc on 2023/09/14.
//

import UIKit
import SnapKit
import Then

protocol StudyVideoRecordViewDelegate: AnyObject {
    func studyVideoRecordView(_ srv: StudyVideoRecordView, didFinishRecord: UIButton)
}

final class StudyVideoRecordView: UIView {
    weak var delegate: StudyVideoRecordViewDelegate?
    
    let studyInfo: RtQuiz
    
    private lazy var midView = UIView()
    private lazy var bottomView = UIView()
    
    private lazy var videoPlayerView = UIView().then {
        $0.backgroundColor = .gray
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "음성을 듣고 따라 말해보세요!"
        $0.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.textAlignment = .center
    }
    
    private lazy var questionBackgroundView = UIView().then {
        $0.backgroundColor = .init(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
    }
    
    private lazy var questionMeanLabel = UILabel().then {
        $0.text = studyInfo.contentKor
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private lazy var micButton = UIButton().then {
        $0.setImage(UIImage(systemName: "mic.circle.fill"), for: .normal)
        $0.tintColor = .darkGray
        $0.contentVerticalAlignment = .fill
        $0.contentHorizontalAlignment = .fill
        $0.addTarget(
            self,
            action: #selector(didFinishRecord),
            for: .touchUpInside
        )
    }
    
    init(studyInfo: RtQuiz, frame: CGRect) {
        self.studyInfo = studyInfo
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didFinishRecord(_ sender: UIButton) {
        delegate?.studyVideoRecordView(self, didFinishRecord: sender)
    }
    
    private func setupLayout() {
        [
            midView,
            bottomView,
            videoPlayerView,
            descriptionLabel,
            questionBackgroundView,
            questionMeanLabel,
            micButton
        ].forEach {
            addSubview($0)
        }
        
        videoPlayerView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(frame.height / 3)
        }
        
        midView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(videoPlayerView.snp.bottom)
            $0.height.equalTo(frame.height / 3)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(midView.snp.bottom)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(midView.snp.top).inset(40)
        }
        
        questionBackgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            $0.bottom.equalTo(midView.snp.bottom)
        }
        
        questionMeanLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(questionBackgroundView.snp.centerY).offset(16)
        }
        
        micButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.center.equalTo(bottomView)
        }
    }
}
