//
//  RTViewController.swift
//  RealTraining
//
//  Created by yc on 2023/09/08.
//

import UIKit
import SnapKit
import Then

final class RTViewController: UIViewController {
    
    let studyInfos: RTModel? = decodeJSONInBundle(fileName: "StudyInfo")
    
    var currentStudyIdx = 0
    
    private var studyResults = [RtQuiz]()
    
    private lazy var leftBarButton = UIBarButtonItem(
        image: UIImage(systemName: "xmark"),
        style: .plain,
        target: self,
        action: #selector(didTapDismissButton)
    ).then {
        $0.tintColor = .black
    }
    
    private lazy var rightBarButton = UIBarButtonItem(
        image: UIImage(systemName: "ellipsis"),
        style: .plain,
        target: self,
        action: #selector(didTapSettingButton)
    ).then {
        $0.tintColor = .black
    }
    
    private lazy var mainView = UIView()
    
    private var introView: IntroView?
    private var studyThumbnailView: StudyThumbnailView?
    private var studySelectView: StudySelectView?
    private var studyVideoRecordView: StudyVideoRecordView?
    private var feedbackView: FeedbackView?
    
    private var videoPlayerView: VideoPlayerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupLayout()
        
        setupIntroViewLayout()
    }
    
    @objc func didTapDismissButton(_ sender: UIBarButtonItem) {
        
        if introView != nil {
            dismiss(animated: true)
        } else {
            let popupVC = PopupViewController()
            
            popupVC.isBackgroundTapDismissEnabled = true
            popupVC.modalPresentationStyle = .overFullScreen
            
            popupVC.setupView(
                title: "학습중지",
                message: "현재 학습중이던 에피소드를 중지하고 학습목록으로 이동하시겠습니까?",
                buttonType: .leftAndRight(
                    leftTitle: "취소",
                    leftAction: nil,
                    rightTitle: "확인",
                    rightAction: { [weak self] in
                        self?.dismiss(animated: true)
                    }
                )
            )
            
            present(popupVC, animated: false)
        }
    }
    
    @objc func didTapSettingButton(_ sender: UIBarButtonItem) {
        // MARK: - 피드백 화면 이동 테스트
        feedbackView = FeedbackView(
            studyResults: studyInfos!.rtQuizList.rtQuiz,
            frame: view.safeAreaLayoutGuide.layoutFrame
        )
        
        navigationItem.title = ""
        navigationItem.rightBarButtonItem = nil
        
        let resultGageView = UIStackView().then {
            $0.spacing = 4
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: resultGageView)
        
        let levelGageBox = UIView().then {
            $0.layer.borderColor = UIColor.separator.cgColor
            $0.layer.borderWidth = 0.4
        }
        
        let levelGageLabel = UILabel().then {
            $0.text = "Level"
            $0.textColor = .init(hexCode: "4ab4fb")
            $0.font = .systemFont(ofSize: 12, weight: .bold)
        }
        
        let levelGageBarBackgroundView = UIView().then {
            $0.backgroundColor = .init(hexCode: "c5c4c4")
        }
        
        let levelNumLabel = UILabel().then {
            $0.text = "25"
            $0.font = .systemFont(ofSize: 12, weight: .bold)
            $0.textColor = .white
        }
        
        let levelGageBarView = UIView().then {
            $0.backgroundColor = .init(hexCode: "4ab4fb")
        }
        
        [
            levelGageLabel,
            levelGageBarBackgroundView,
            levelGageBarView,
            levelNumLabel
        ].forEach {
            levelGageBox.addSubview($0)
        }
        
        levelGageLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(4)
        }
        levelGageBarBackgroundView.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.top.trailing.bottom.equalToSuperview().inset(4)
            $0.leading.equalTo(levelGageLabel.snp.trailing).offset(4)
            $0.height.equalTo(18)
        }
        levelGageBarView.snp.makeConstraints {
            $0.leading.top.bottom.equalTo(levelGageBarBackgroundView)
            $0.width.equalTo(levelGageBarBackgroundView).multipliedBy(0.25)
        }
        levelNumLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(levelGageBarBackgroundView).inset(4)
            $0.centerY.equalTo(levelGageBarBackgroundView)
        }
        
        levelGageBarView.transform = CGAffineTransform(scaleX: 0, y: 1)
        
        resultGageView.addArrangedSubview(levelGageBox)
        
        // ---
        
        let scoreGageBox = UIView().then {
            $0.layer.borderColor = UIColor.separator.cgColor
            $0.layer.borderWidth = 0.4
        }
        
        let scoreGageLabel = UILabel().then {
            $0.text = "Score"
            $0.textColor = .init(hexCode: "f16b59")
            $0.font = .systemFont(ofSize: 12, weight: .bold)
        }
        
        let scoreGageBarBackgroundView = UIView().then {
            $0.backgroundColor = .init(hexCode: "c5c4c4")
        }
        
        let scoreNumLabel = UILabel().then {
            $0.text = "750"
            $0.font = .systemFont(ofSize: 12, weight: .bold)
            $0.textColor = .white
        }
        
        let scoreGageBarView = UIView().then {
            $0.backgroundColor = .init(hexCode: "f16b59")
        }
        
        [
            scoreGageLabel,
            scoreGageBarBackgroundView,
            scoreGageBarView,
            scoreNumLabel
        ].forEach {
            scoreGageBox.addSubview($0)
        }
        
        scoreGageLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(4)
        }
        scoreGageBarBackgroundView.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.top.trailing.bottom.equalToSuperview().inset(4)
            $0.leading.equalTo(scoreGageLabel.snp.trailing).offset(4)
            $0.height.equalTo(18)
        }
        scoreGageBarView.snp.makeConstraints {
            $0.leading.top.bottom.equalTo(scoreGageBarBackgroundView)
            $0.width.equalTo(scoreGageBarBackgroundView).multipliedBy(0.75)
        }
        scoreNumLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(scoreGageBarBackgroundView).inset(4)
            $0.centerY.equalTo(scoreGageBarBackgroundView)
        }
        
        scoreGageBarView.transform = CGAffineTransform(scaleX: 0, y: 1)
        
        resultGageView.addArrangedSubview(scoreGageBox)
        
        mainView.addSubview(feedbackView!)
        
        feedbackView!.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        feedbackView?.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.feedbackView?.transform = .identity
        } completion: { _ in
            levelGageBarView.transform = CGAffineTransform(scaleX: 1, y: 1)
            scoreGageBarView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.setLeftBarButton(leftBarButton, animated: true)
        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    private func setupLayout() {
        view.addSubview(mainView)
        
        mainView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupIntroViewLayout() {
        introView = IntroView()
        introView?.delegate = self
        
        guard let introView = introView else {
            return
        }
        
        mainView.addSubview(introView)
        
        introView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension RTViewController: IntroViewDelegate {
    func introView(_ iv: IntroView, didTapStartButton startButton: UIButton) {
        studyThumbnailView = StudyThumbnailView(studyInfo: studyInfos!.rtQuizList.rtQuiz[currentStudyIdx])
        navigationItem.title = "Question \(currentStudyIdx + 1) of \(studyInfos!.rtQuizList.rtQuiz.count)"
        
        studyThumbnailView?.delegate = self
        
        mainView.addSubview(studyThumbnailView!)
        
        studyThumbnailView!.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        studyThumbnailView?.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.studyThumbnailView?.transform = .identity
        } completion: { [weak self] _ in
            startButton.isEnabled = true
            iv.removeFromSuperview()
            self?.introView = nil
        }
    }
}

extension RTViewController: StudyThumbnailViewDelegate {
    func studyView(_ sv: StudyThumbnailView, didTapStartButton startButton: UIButton) {
        videoPlayerView = VideoPlayerView(
            videoURLString: studyInfos!.rtQuizList.rtQuiz[currentStudyIdx].quizResource.movPath
        )
        
        videoPlayerView?.setupPlayer()
        
        studySelectView = StudySelectView(
            studyInfo: studyInfos!.rtQuizList.rtQuiz[currentStudyIdx],
            frame: view.safeAreaLayoutGuide.layoutFrame
        )
        
        studySelectView?.delegate = self
        
        mainView.addSubview(studySelectView!)
        
        studySelectView!.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        studySelectView?.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        
        UIView.animate(withDuration: 0.3) {
            self.studySelectView?.transform = .identity
        } completion: { [weak self] _ in
            startButton.isEnabled = true
            sv.removeFromSuperview()
            self?.studyThumbnailView = nil
        }
    }
}

extension RTViewController: StudySelectViewDelegate {
    func studySelectView(_ sv: StudySelectView, didTapNextButton nextButton: UIButton) {
        guard let videoPlayerView = videoPlayerView else { return }
        
        studyVideoRecordView = StudyVideoRecordView(
            studyInfo: studyInfos!.rtQuizList.rtQuiz[currentStudyIdx],
            videoPlayerView: videoPlayerView,
            frame: view.safeAreaLayoutGuide.layoutFrame
        )
        
        studyVideoRecordView?.delegate = self
        
        mainView.addSubview(studyVideoRecordView!)
        
        studyVideoRecordView!.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        studyVideoRecordView?.transform = CGAffineTransform(translationX: 0, y: -view.frame.height)
        
        UIView.animate(withDuration: 0.3) {
            self.studyVideoRecordView?.transform = .identity
        } completion: { [weak self] _ in
            nextButton.isEnabled = true
            sv.removeFromSuperview()
            self?.studySelectView = nil
        }
    }
}

extension RTViewController: StudyVideoRecordViewDelegate {
    func studyVideoRecordView(_ srv: StudyVideoRecordView, didFinishStep: UIButton, studyResult: RtQuiz) {
        studyResults.append(studyResult)
        
        currentStudyIdx += 1
        
        if currentStudyIdx == studyInfos!.rtQuizList.rtQuiz.count {
            // MARK: - 피드백 화면으로 이동
            
            feedbackView = FeedbackView(studyResults: studyResults, frame: view.safeAreaLayoutGuide.layoutFrame)
            
            navigationItem.title = ""
            navigationItem.rightBarButtonItem = nil
            
            let resultGageView = UIView().then {
                $0.backgroundColor = .red
            }
            
            navigationItem.titleView = resultGageView
            
            
            resultGageView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.trailing.equalToSuperview().inset(16)
                $0.width.equalTo(100)
            }
            
            
            
            
            mainView.addSubview(feedbackView!)
            
            feedbackView!.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            feedbackView?.transform = CGAffineTransform(scaleX: 0, y: 0)
            
            UIView.animate(withDuration: 0.3) {
                self.feedbackView?.transform = .identity
            } completion: { [weak self] _ in
                srv.removeFromSuperview()
                self?.studyVideoRecordView = nil
                self?.videoPlayerView = nil
            }
            
            return
        }
        
        studyThumbnailView = StudyThumbnailView(studyInfo: studyInfos!.rtQuizList.rtQuiz[currentStudyIdx])
        navigationItem.title = "Question \(currentStudyIdx + 1) of \(studyInfos!.rtQuizList.rtQuiz.count)"
        
        studyThumbnailView?.delegate = self
        
        mainView.addSubview(studyThumbnailView!)
        
        studyThumbnailView!.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        studyThumbnailView?.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.studyThumbnailView?.transform = .identity
        } completion: { [weak self] _ in
            srv.removeFromSuperview()
            self?.studyVideoRecordView = nil
            self?.videoPlayerView = nil
        }
    }
}
