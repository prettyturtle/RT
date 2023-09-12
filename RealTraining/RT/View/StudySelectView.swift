//
//  StudySelectView.swift
//  RealTraining
//
//  Created by yc on 2023/09/12.
//

import UIKit
import SnapKit
import Then

final class StudySelectView: UIView {
    
    let studyInfo: RtQuiz
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "한글 문장을 영어로 만들어보세요!"
        $0.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.textAlignment = .center
    }
    
    private lazy var questionBackgroundView = UIView().then {
        $0.backgroundColor = .init(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
    }
    
    private lazy var questionBoxTotalStackView = UIStackView().then {
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 8
        $0.axis = .vertical
    }
    
    private lazy var questionMeanLabel = UILabel().then {
        $0.text = studyInfo.contentKor
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private lazy var choiceButtonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    init(studyInfo: RtQuiz, frame: CGRect) {
        self.studyInfo = studyInfo
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setupQuestionBoxes()
        setupChoiceButtons()
    }
    
    private func setupQuestionBoxes() {
        let boxTexts = studyInfo.contentEng.split(separator: "|").map { String($0) }
        
        var currentWidth: CGFloat = 0
        
        var questionBoxStackView: UIStackView?
        
        for boxText in boxTexts {
            let boxView = UIView().then {
                $0.layer.borderColor = UIColor.darkGray.cgColor
                $0.layer.borderWidth = 1
                $0.layer.cornerRadius = 2
                $0.backgroundColor = .white
            }
            
            var boxWidth = (boxText as NSString).size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold)]).width + 32
            
            if boxWidth < 80 {
                boxWidth = 80
            } else if boxWidth > frame.width - 32 {
                boxWidth = frame.width - 32
            }
            
            boxView.snp.makeConstraints {
                $0.height.equalTo(32)
                $0.width.equalTo(boxWidth)
            }
            
            currentWidth += boxWidth
            
            if let stackView = questionBoxStackView {
                if currentWidth < frame.width - 32 {
                    stackView.addArrangedSubview(boxView)
                    
                } else {
                    questionBoxTotalStackView.addArrangedSubview(stackView)
                    
                    questionBoxStackView = UIStackView().then {
                        $0.distribution = .fill
                        $0.alignment = .center
                        $0.spacing = 4
                        $0.axis = .horizontal
                    }
                    
                    questionBoxStackView?.addArrangedSubview(boxView)
                    
                    currentWidth = boxWidth
                }
            } else {
                if currentWidth < frame.width - 32 {
                    questionBoxStackView = UIStackView().then {
                        $0.distribution = .fill
                        $0.alignment = .center
                        $0.spacing = 4
                        $0.axis = .horizontal
                    }
                    
                    questionBoxStackView?.addArrangedSubview(boxView)
                }
            }
        }
        
        if let questionBoxStackView = questionBoxStackView {
            questionBoxTotalStackView.addArrangedSubview(questionBoxStackView)
        }
    }
    
    private func setupChoiceButtons() {
        
    }
    
    private func setupLayout() {
        [
            descriptionLabel,
            questionBackgroundView,
            questionBoxTotalStackView,
            questionMeanLabel,
            choiceButtonStackView
        ].forEach {
            addSubview($0)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(40)
        }
        
        questionBackgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            $0.height.equalTo(frame.height / 3)
        }
        
        questionBoxTotalStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.greaterThanOrEqualTo(questionBackgroundView.snp.top)
            $0.bottom.equalTo(questionBackgroundView.snp.centerY).offset(-16)
        }
        
        questionMeanLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(questionBackgroundView.snp.centerY).offset(16)
        }
        
        choiceButtonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(questionBackgroundView.snp.bottom).offset(40)
        }
    }
}
