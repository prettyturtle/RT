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
    
    let studyInfos: RTModel
    
    init(studyInfos: RTModel) {
        self.studyInfos = studyInfos
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private lazy var rightTestBarButton = UIBarButtonItem(
        image: UIImage(systemName: "testtube.2"),
        style: .plain,
        target: self,
        action: #selector(didTapTestButton)
    ).then {
        $0.tintColor = .black
    }
    
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
        let settingVC = SettingViewController(settingTypes: [.fxVolume(85), .recordFx(2)])
        
        settingVC.modalPresentationStyle = .overFullScreen
        
        present(settingVC, animated: false)
    }
    
    @objc func didTapTestButton(_ sender: UIBarButtonItem) {
        // MARK: - 피드백 화면 이동 테스트
        guard let feedback: RTFeedbackModel = decodeJSONInBundle(fileName: "Feedback") else {
            return
        }
        
        feedbackView = FeedbackView(
            studyInfos: studyInfos.rtQuizList.rtQuiz,
            feedback: feedback,
            frame: view.safeAreaLayoutGuide.layoutFrame
        )
        
        navigationItem.title = ""
        navigationItem.rightBarButtonItem = nil
        
        let feedbackGageView = FeedbackGageView(
            level: feedback.feedbackRTraining.updPlayerInfo.level,
            levelPercent: feedback.feedbackRTraining.updPlayerInfo.levelPercent,
            score: feedback.feedbackRTraining.getCellScore,
            maxScore: feedback.feedbackRTraining.maxCellScore
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: feedbackGageView)
        
        view.addSubview(feedbackView!)
        
        feedbackView!.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        feedbackView?.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.feedbackView?.transform = .identity
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.setLeftBarButton(leftBarButton, animated: true)
        navigationItem.setRightBarButtonItems([rightBarButton, rightTestBarButton], animated: true)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)]

//        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    private func setupLayout() {
//        view.addSubview(mainView)
//        
//        mainView.snp.makeConstraints {
//            $0.edges.equalTo(view.safeAreaLayoutGuide)
//        }
    }
    
    private func setupIntroViewLayout() {
        introView = IntroView(mode: .rt)
        introView?.delegate = self
        
        guard let introView = introView else {
            return
        }
        
        view.addSubview(introView)
        
        introView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension RTViewController: IntroViewDelegate {
    func rotate() {
        
        OrientationManager.landscapeSupported = !OrientationManager.landscapeSupported
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        
        if #available(iOS 16.0, *) {
            windowScene?.requestGeometryUpdate(.iOS(
                interfaceOrientations: OrientationManager.landscapeSupported ? .landscape : .portrait
            ))
            
            self.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
        
    }
    func introView(_ iv: IntroView, didTapStartButton startButton: UIButton) {
        studyThumbnailView = StudyThumbnailView(studyInfo: studyInfos.rtQuizList.rtQuiz[currentStudyIdx])
        navigationItem.title = "Question \(currentStudyIdx + 1) of \(studyInfos.rtQuizList.rtQuiz.count)"
        
        studyThumbnailView?.delegate = self
        
        view.addSubview(studyThumbnailView!)
        
        if OrientationManager.landscapeSupported {
            studyThumbnailView!.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            studyThumbnailView!.snp.makeConstraints {
                $0.edges.equalTo(view.safeAreaLayoutGuide)
            }
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
            videoURLString: studyInfos.rtQuizList.rtQuiz[currentStudyIdx].quizResource.movPath
        )
        
        videoPlayerView?.delegate = self
        videoPlayerView?.setupPlayer()
        
        studySelectView = StudySelectView(
            studyInfo: studyInfos.rtQuizList.rtQuiz[currentStudyIdx],
            frame: view.safeAreaLayoutGuide.layoutFrame
        )
        
        studySelectView?.delegate = self
        
        view.addSubview(studySelectView!)
        
        if OrientationManager.landscapeSupported {
            studySelectView!.snp.makeConstraints {
                $0.edges.equalTo(view.safeAreaLayoutGuide)
            }
            
            studySelectView?.transform = CGAffineTransform(scaleX: 0, y: 0)
            
            UIView.animate(withDuration: 0.3) {
                self.studySelectView?.transform = .identity
            } completion: { _ in
                startButton.isEnabled = true
            }
        } else {
            studySelectView!.snp.makeConstraints {
                $0.edges.equalTo(view.safeAreaLayoutGuide)
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
}

extension RTViewController: StudySelectViewDelegate {
    func studySelectView(_ sv: StudySelectView, didTapNextButton nextButton: UIButton) {
        guard let videoPlayerView = videoPlayerView else { return }
        
        studyVideoRecordView = StudyVideoRecordView(
            studyInfo: studyInfos.rtQuizList.rtQuiz[currentStudyIdx],
            videoPlayerView: videoPlayerView,
            frame: view.safeAreaLayoutGuide.layoutFrame
        )
        
        studyVideoRecordView?.delegate = self
        
        view.addSubview(studyVideoRecordView!)
        
        studyVideoRecordView!.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        studyVideoRecordView?.transform = CGAffineTransform(translationX: 0, y: -view.frame.height)
        
        UIView.animate(withDuration: 0.3) {
            self.studyVideoRecordView?.transform = .identity
        } completion: { [weak self] _ in
            nextButton.isEnabled = true
            sv.removeFromSuperview()
            self?.studySelectView = nil
            
            if OrientationManager.landscapeSupported {
                self?.studyThumbnailView?.removeFromSuperview()
                self?.studyThumbnailView = nil
            }
        }
    }
    
    func studySelectView(_ sv: StudySelectView, didFinishSelect: Bool) {
        if videoPlayerView?.isFinishLoad == true {
            sv.setupNextButton()
        }
    }
}

extension RTViewController: StudyVideoRecordViewDelegate {
    func studyVideoRecordView(_ srv: StudyVideoRecordView, didFinishStep: UIButton, studyResult: RtQuiz) {
        studyResults.append(studyResult)
        
        currentStudyIdx += 1
        
        if currentStudyIdx == studyInfos.rtQuizList.rtQuiz.count {
            // MARK: - 피드백 화면으로 이동
            guard let feedback: RTFeedbackModel = decodeJSONInBundle(fileName: "Feedback") else {
                return
            }
            
            feedbackView = FeedbackView(
                studyInfos: studyInfos.rtQuizList.rtQuiz,
                feedback: feedback,
                frame: view.safeAreaLayoutGuide.layoutFrame
            )
            
            navigationItem.title = ""
            navigationItem.rightBarButtonItem = nil
            
            let feedbackGageView = FeedbackGageView(
                level: feedback.feedbackRTraining.updPlayerInfo.level,
                levelPercent: feedback.feedbackRTraining.updPlayerInfo.levelPercent,
                score: feedback.feedbackRTraining.getCellScore,
                maxScore: feedback.feedbackRTraining.maxCellScore
            )
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: feedbackGageView)
            
            view.addSubview(feedbackView!)
            
            feedbackView!.snp.makeConstraints {
                $0.edges.equalTo(view.safeAreaLayoutGuide)
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
        
        studyThumbnailView = StudyThumbnailView(studyInfo: studyInfos.rtQuizList.rtQuiz[currentStudyIdx])
        navigationItem.title = "Question \(currentStudyIdx + 1) of \(studyInfos.rtQuizList.rtQuiz.count)"
        
        studyThumbnailView?.delegate = self
        
        view.addSubview(studyThumbnailView!)
        
        studyThumbnailView!.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
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

extension RTViewController: VideoPlayerViewDelegate {
    func didFinishPlaying() {}
    
    func didFinishPrepareVideoPlayer(_ isFinish: Bool) {
        if isFinish {
            if let studySelectView = studySelectView {
                if studySelectView.isFinishSelect {
                    studySelectView.setupNextButton()
                } else {
                    videoPlayerView?.isFinishLoad = true
                }
            }
        }
    }
}
