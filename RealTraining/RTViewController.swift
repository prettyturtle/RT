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
    private var studyView : StudyView?
    
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
        studyView = StudyView(studyInfo: studyInfos!.rtQuizList.rtQuiz.first!)
        navigationItem.title = "Question \(currentStudyIdx + 1) of \(studyInfos!.rtQuizList.rtQuiz.count)"
        
        studyView?.delegate = self
        
        mainView.addSubview(studyView!)
        
        studyView!.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        studyView?.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.studyView?.transform = .identity
        } completion: { _ in
            iv.removeFromSuperview()
        }
    }
}

extension RTViewController: StudyViewDelegate {
    func studyView(_ sv: StudyView, didTapStartButton: UIButton) {
        currentStudyIdx += 1
        
        dismiss(animated: true)
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



// MARK: - RTModel
struct RTModel: Codable {
    let rtQuizList: RtQuizList
}

// MARK: - RtQuizList
struct RtQuizList: Codable {
    let rtQuiz: [RtQuiz]
}

// MARK: - RtQuiz
struct RtQuiz: Codable {
    let quizSeq, rtIdx: Int
    let contentEng, contentKor: String
    let quizResource: QuizResource
    let quizMakeup: QuizMakeup
    let quizRepeat: QuizRepeat
}

// MARK: - QuizMakeup
struct QuizMakeup: Codable {
    let chunkList: String
    let bgImg: String
    let boxType: String
    let boxPosX, boxPosY: Int
}

// MARK: - QuizRepeat
struct QuizRepeat: Codable {
    let repeatContentEng, repeatContentKor: String
    let repeatContentMp3: String
    let diosttRepeatScript, diosttRepeatChunk: String

    enum CodingKeys: String, CodingKey {
        case repeatContentEng, repeatContentKor, repeatContentMp3
        case diosttRepeatScript = "DIOSTT_repeatScript"
        case diosttRepeatChunk = "DIOSTT_repeatChunk"
    }
}

// MARK: - QuizResource
struct QuizResource: Codable {
    let srcMOVPath: String
    let srcMOVDNPath: String
    let srcMOVBlurImg, scriptBegin, scriptEnd: String

    enum CodingKeys: String, CodingKey {
        case srcMOVPath = "srcMovPath"
        case srcMOVDNPath = "srcMovDnPath"
        case srcMOVBlurImg = "srcMovBlurImg"
        case scriptBegin, scriptEnd
    }
}

func decodeJSONInBundle<T: Codable>(fileName: String) -> T? {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        return nil
    }
    
    guard let data = try? Data(contentsOf: url) else {
        return nil
    }
    
    let decoder = JSONDecoder()
    
    let decodedData = try? decoder.decode(T.self, from: data)
    
    return decodedData
}