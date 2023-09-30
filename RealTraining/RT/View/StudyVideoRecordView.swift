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
    func studyVideoRecordView(_ srv: StudyVideoRecordView, didFinishStep: UIButton, studyResult: RtQuiz)
}

final class StudyVideoRecordView: UIView {
    weak var delegate: StudyVideoRecordViewDelegate?
    
    let studyInfo: RtQuiz
    
    var questionTexts: [String] {
        let texts = try! JSONSerialization.jsonObject(with: Data(studyInfo.quizRepeat.diosttRepeatChunk.utf8)) as! [String]
        
        return texts
    }
    
    private var recordTryCount = 0
    
    private var isPlayingVideo = true
    private var isFinishPlayingVideo = false
    private var isShowVideoPlayerControlView = false
    
    private lazy var midView = UIView()
    private lazy var bottomView = UIView()
    
    private var videoPlayerView: VideoPlayerView
    
    private lazy var videoPlayerControlView = UIView().then {
        $0.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapVideoPlayerControlView)
        )
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tapGesture)
    }
    
    private lazy var videoPlayerPlayPauseButton = UIButton().then {
        $0.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.tintColor = .white
        $0.addTarget(
            self,
            action: #selector(didTapVideoPlayerPlayPauseButton),
            for: .touchUpInside
        )
        $0.isHidden = true
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "음성을 듣고 따라 말해보세요!"
        $0.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.textAlignment = .center
    }
    
    private lazy var questionBackgroundView = UIView().then {
        $0.backgroundColor = .init(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
    }
    
    private lazy var hintTextLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
    }
    
    private lazy var questionBoxView = UIView().then {
        $0.layer.borderColor = UIColor(red: 255 / 255, green: 144 / 255, blue: 0, alpha: 1).cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .white
    }
    
    private lazy var questionLabelBoxStackView = UIStackView().then {
        $0.spacing = 8
        $0.alignment = .center
    }
    
    private lazy var questionBoxQuestionMarkLabel = UILabel().then {
        $0.text = "?"
        $0.textColor = UIColor(red: 255 / 255, green: 144 / 255, blue: 0, alpha: 1)
        $0.font = .systemFont(ofSize: 16, weight: .bold)
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
    
    init(studyInfo: RtQuiz, videoPlayerView: VideoPlayerView, frame: CGRect) {
        self.studyInfo = studyInfo
        self.videoPlayerView = videoPlayerView
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
        
        videoPlayerView.delegate = self
        videoPlayerView.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        videoPlayerView.setupPlayerLayer()
    }
    
    @objc func didTapVideoPlayerControlView() {
        if isFinishPlayingVideo { return }
        
        let backgroundColor: UIColor = isShowVideoPlayerControlView ? .clear : .black.withAlphaComponent(0.5)
        
        videoPlayerControlView.backgroundColor = backgroundColor
        videoPlayerPlayPauseButton.isHidden = isShowVideoPlayerControlView
        
        isShowVideoPlayerControlView.toggle()
    }
    
    @objc func didTapVideoPlayerPlayPauseButton(_ sender: UIButton) {
        let imageName = isPlayingVideo ? "play.fill" : "pause.fill"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        
        if isPlayingVideo {
            videoPlayerView.pause()
        } else {
            videoPlayerView.play()
        }
        
        isPlayingVideo.toggle()
    }
    
    @objc func didFinishRecord(_ sender: UIButton) {
        if recordTryCount == 2 {
            delegate?.studyVideoRecordView(self, didFinishStep: sender, studyResult: studyInfo)
            
            return
        }
        
        hintTextLabel.text = (hintTextLabel.text ?? "") + " " + questionTexts[recordTryCount]
        
        let remainQuestionText = questionTexts[(recordTryCount + 1)...].joined(separator: " ")
        
        var boxWidth = (remainQuestionText as NSString).size(
            withAttributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)
            ]
        ).width + 32
        
        if remainQuestionText.isEmpty {
            boxWidth = 0
            
            questionBoxQuestionMarkLabel.removeFromSuperview()
        }
        
        recordTryCount += 1
        
        self.questionBoxView.snp.updateConstraints {
            $0.width.equalTo(boxWidth)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    private func setupLayout() {
        [
            midView,
            bottomView,
            videoPlayerView,
            videoPlayerControlView,
            descriptionLabel,
            questionBackgroundView,
            questionLabelBoxStackView,
            questionBoxQuestionMarkLabel,
            questionMeanLabel,
            micButton
        ].forEach {
            addSubview($0)
        }
        
        videoPlayerView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(videoPlayerView.snp.width).multipliedBy(9.0 / 16.0)
        }
        
        videoPlayerControlView.snp.makeConstraints {
            $0.edges.equalTo(videoPlayerView.snp.edges)
        }
        
        midView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(videoPlayerView.snp.bottom)
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(frame.height / 3)
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
        
        var boxWidth = (studyInfo.quizRepeat.repeatContentEng as NSString).size(
            withAttributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)
            ]
        ).width + 32
        
        if boxWidth < 80 {
            boxWidth = 80
        } else if boxWidth > frame.width - 32 {
            boxWidth = frame.width - 32
        }
        
        questionBoxView.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(boxWidth)
        }
        
        questionLabelBoxStackView.snp.makeConstraints {
            $0.centerX.equalTo(questionBackgroundView.snp.centerX)
            $0.bottom.equalTo(questionBackgroundView.snp.centerY).offset(-8)
        }
        
        questionLabelBoxStackView.addArrangedSubview(hintTextLabel)
        questionLabelBoxStackView.addArrangedSubview(questionBoxView)
        
        questionBoxQuestionMarkLabel.snp.makeConstraints {
            $0.center.equalTo(questionBoxView.snp.center)
        }
        
        questionMeanLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(questionBackgroundView.snp.centerY).offset(8)
        }
        
        micButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.center.equalTo(bottomView)
        }
        
        videoPlayerControlView.addSubview(videoPlayerPlayPauseButton)
        
        videoPlayerPlayPauseButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview().dividedBy(4.0)
        }
        
        videoPlayerPlayPauseButton.imageView?.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
    }
}

extension StudyVideoRecordView: VideoPlayerViewDelegate {
    func didFinishPlaying() {
        
        isFinishPlayingVideo = true
        
        videoPlayerControlView.backgroundColor = .clear
        videoPlayerPlayPauseButton.isHidden = true
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.alpha = 0.8
        visualEffectView.frame = videoPlayerControlView.frame
        videoPlayerControlView.addSubview(visualEffectView)
    }
}
