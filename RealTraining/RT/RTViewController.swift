//
//  RTViewController.swift
//  RealTraining
//
//  Created by yc on 2023/09/08.
//


import UIKit
import SwiftUI
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
        action: #selector(didTapDismissButton)
    ).then {
        $0.tintColor = .black
    }
    
    private lazy var mainView = UIView()
    
    private var introView: IntroView?
    private var studyThumbnailView: StudyThumbnailView?
    private var studySelectView: StudySelectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupLayout()
        
        setupIntroViewLayout()
    }
    
    @objc func didTapDismissButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
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
    func introView(_ iv: IntroView, didTapStartButton: UIButton) {
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
        } completion: { _ in
            iv.removeFromSuperview()
        }
    }
}

extension RTViewController: StudyThumbnailViewDelegate {
    func studyView(_ sv: StudyThumbnailView, didTapStartButton: UIButton) {
        studySelectView = StudySelectView(studyInfo: studyInfos!.rtQuizList.rtQuiz[currentStudyIdx], frame: view.safeAreaLayoutGuide.layoutFrame)
        
        mainView.addSubview(studySelectView!)
        
        studySelectView!.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        studySelectView?.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        
        UIView.animate(withDuration: 0.3) {
            self.studySelectView?.transform = .identity
        } completion: { _ in
            sv.removeFromSuperview()
        }
    }
}


struct RTViewController_Preview: PreviewProvider{
    static var previews: some View {
        UIViewControllerPreview(
            vc: UINavigationController(
                rootViewController: RTViewController()
            )
        )
    }
}
