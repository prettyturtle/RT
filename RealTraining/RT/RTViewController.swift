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
    
    private var videoPlayerView: VideoPlayerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupLayout()
        
        setupIntroViewLayout()
    }
    
    @objc func didTapDismissButton(_ sender: UIBarButtonItem) {
//        dismiss(animated: true)
        
        let popupVC = PopupViewController()
        
        popupVC.isBackgroundTapDismissEnabled = true
        popupVC.modalPresentationStyle = .overFullScreen
        
        popupVC.setupView(
            title: "학습중지",
            message: "현재 학습중이던 에피소드를 중지하고 학습목록으로 이동하시겠습니까?",
            buttonType: .leftAndRight(
                leftTitle: "취소",
                leftAction: {
                    print("취소 누름")
                },
                rightTitle: "확인",
                rightAction: {
                    print("확인 누름")
                }
            )
        )
        
        present(popupVC, animated: false)
    }
    
    @objc func didTapSettingButton(_ sender: UIBarButtonItem) {
        let popupVC = PopupViewController()
        
        popupVC.isBackgroundTapDismissEnabled = true
        popupVC.modalPresentationStyle = .overFullScreen
        
        popupVC.setupView(
            title: "학습중지",
            message: "현재 학습중이던 에피소드를 중지하고 학습목록으로 이동하시겠습니까?",
            buttonType: .one(
                title: "확인",
                action: {
                    print("확인 누름")
                }
            )
        )
        
        present(popupVC, animated: false)
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
    func studyVideoRecordView(_ srv: StudyVideoRecordView, didFinishRecord: UIButton) {
        currentStudyIdx += 1
        
        if currentStudyIdx == studyInfos!.rtQuizList.rtQuiz.count {
            dismiss(animated: true)
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

final class PopupViewController: UIViewController {
    
    enum ButtonType {
        case one(title: String, action: () -> Void)
        case leftAndRight(
            leftTitle: String,
            leftAction: () -> Void,
            rightTitle: String,
            rightAction: () -> Void
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
        leftButtonAction?()
    }
    @objc func didTapRightButton() {
        rightButtonAction?()
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
