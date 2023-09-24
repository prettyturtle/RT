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
    
    private var isPlayingVideo = true
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
        delegate?.studyVideoRecordView(self, didFinishRecord: sender)
    }
    
    private func setupLayout() {
        [
            midView,
            bottomView,
            videoPlayerView,
            videoPlayerControlView,
            descriptionLabel,
            questionBackgroundView,
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
