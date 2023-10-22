//
//  StudySelectView.swift
//  RealTraining
//
//  Created by yc on 2023/09/12.
//

import UIKit
import SnapKit
import Then

protocol StudySelectViewDelegate: AnyObject {
    func studySelectView(_ sv: StudySelectView, didTapNextButton nextButton: UIButton)
    func studySelectView(_ sv: StudySelectView, didFinishSelect: Bool)
}

final class StudySelectView: UIView {
    
    weak var delegate: StudySelectViewDelegate?
    
    let studyInfo: RtQuiz
    
    private var questionTexts: [String]
    
    private let questionDic: [String: [String]]
    
    var currentQuestionStep = 0
    
    lazy var choiceTexts = Array(repeating: "", count: questionTexts.count)
    
    var questionBoxes = [UIView]()
    var oxImageViews = [UIImageView]()
    var choiceTextLabels = [UILabel]()
    
    var isSetNextButton = false
    var isFinishSelect = false
    
    private lazy var container = UIView()
    
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
    
    private lazy var choiceButtonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    private lazy var nextButton = UIButton().then {
        var titleConfig = AttributeContainer()
        
        titleConfig.foregroundColor = .white
        titleConfig.font = .systemFont(ofSize: 20, weight: .heavy)
        
        var buttonConfig = UIButton.Configuration.filled()
        
        buttonConfig.attributedTitle = AttributedString(
            "트레이닝 시작",
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
            action: #selector(didTapNextButton),
            for: .touchUpInside
        )
    }
    
    init(studyInfo: RtQuiz, frame: CGRect) {
        self.studyInfo = studyInfo
        self.questionDic = studyInfo.quizMakeup.chunkList
        self.questionTexts = studyInfo.quizRepeat.diosttRepeatChunk
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapChoiceButton(_ sender: ChoiceButton) {
        haptic.selectionChanged()
        
        let choiceText = sender.text
        
        choiceTexts[currentQuestionStep] = choiceText
        
        UIView.animate(withDuration: 0.5) {
            self.choiceButtonStackView.arrangedSubviews.forEach { subView in
                subView.transform = CGAffineTransform(translationX: 0, y: 100)
                subView.alpha = 0
            }
        } completion: { [weak self] _ in
            guard let self = self else { return }
            
            self.choiceButtonStackView.arrangedSubviews.forEach { subview in
                subview.removeFromSuperview()
            }
            
            // TODO: - 선지 선택 처리 : 빈칸 채우기
            let currentQuestionBox = self.questionBoxes[self.currentQuestionStep]
            
            currentQuestionBox.backgroundColor = .init(
                red: 215 / 255,
                green: 215 / 255,
                blue: 215 / 255,
                alpha: 1
            )
            
            let choiceTextLabel = UILabel().then {
                $0.text = choiceText
                $0.textColor = .black
                $0.font = .systemFont(ofSize: 16, weight: .bold)
                $0.textAlignment = .center
            }
            
            choiceTextLabels.append(choiceTextLabel)
            
            currentQuestionBox.addSubview(choiceTextLabel)
            
            choiceTextLabel.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
            
            choiceTextLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
            
            UIView.animate(withDuration: 0.1) {
                choiceTextLabel.transform = .identity
            }
            
            setupQuestionBoxBorderColor(isLight: false)
            
            if self.currentQuestionStep < self.questionTexts.count - 1 {
                
                self.currentQuestionStep += 1
                
                self.setupChoiceButtons()
                
                self.setupQuestionBoxBorderColor(isLight: true)
            } else {
                // TODO: - 최종 채점
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.giveOX(0)
                }
            }
        }
    }
    
    private func giveOX(_ step: Int) {
        if step == questionTexts.count {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                for oxImageView in self.oxImageViews {
                    oxImageView.removeFromSuperview()
                }
                
                UIView.animate(withDuration: 0.2) {
                    for i in 0..<self.questionTexts.count {
                        let isCorrect = self.questionTexts[i] == self.choiceTexts[i]
                        
                        self.questionBoxes[i].backgroundColor = .init(hexCode: "0bc871")
                        self.questionBoxes[i].layer.borderColor = UIColor(hexCode: "0bc871").cgColor
                        
                        if !isCorrect {
                            self.choiceTextLabels[i].text = self.questionTexts[i]
                        }
                    }
                }
            }
            
            isFinishSelect = true
            delegate?.studySelectView(self, didFinishSelect: true)
            return
        }
        
        let isCorrect = questionTexts[step] == choiceTexts[step]
        
        let oxImageView = UIImageView()
        oxImageViews.append(oxImageView)
        
        if isCorrect {
            oxImageView.image = UIImage(named: "icon_answer_o")
        } else {
            oxImageView.image = UIImage(named: "icon_answer_x")
        }
        
        addSubview(oxImageView)
        
        oxImageView.snp.makeConstraints {
            $0.center.equalTo(questionBoxes[step])
            $0.size.equalTo(questionBoxes[step].frame.height * 1.3)
        }
        
        oxImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        if isCorrect {
            playFX("sfx_correct")
        } else {
            playFX("sfx_wrong")
        }
        
        choiceTextLabels[step].textColor = .white
        questionBoxes[step].backgroundColor = isCorrect ? .init(hexCode: "57b0f3") : .init(hexCode: "e12c1e")
        questionBoxes[step].layer.borderColor = isCorrect ? UIColor(hexCode: "57b0f3").cgColor : UIColor(hexCode: "e12c1e").cgColor
        questionBoxes[step].layer.shadowOpacity = 0
        
        UIView.animate(withDuration: 0.3) {
            oxImageView.transform = .identity
        } completion: { [weak self] _ in
            
            self?.giveOX(step + 1)
        }
    }
    
    func setupNextButton() {
        isSetNextButton = true
        
        if OrientationManager.landscapeSupported {
            container.addSubview(nextButton)
            
            nextButton.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.height.equalTo(50)
                $0.width.equalToSuperview().dividedBy(2.0)
                $0.bottom.equalToSuperview().inset(16)
                $0.top.equalTo(questionBackgroundView.snp.bottom).offset(16)
            }
        } else {
            addSubview(nextButton)
            
            nextButton.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview().inset(16)
                $0.height.equalTo(50)
            }
        }
    }
    
    @objc func didTapNextButton(_ sender: UIButton) {
        sender.isEnabled = false
        delegate?.studySelectView(self, didTapNextButton: sender)
    }
    
    private func setupView() {
        setupQuestionBoxes()
        setupQuestionBoxBorderColor(isLight: true)
        setupChoiceButtons()
    }
    
    private func setupQuestionBoxBorderColor(isLight: Bool) {
        let currentQuestionBox = questionBoxes[currentQuestionStep]
        
        currentQuestionBox.layer.borderColor = isLight ? UIColor(red: 255 / 255, green: 144 / 255, blue: 0, alpha: 1).cgColor : UIColor(red: 121 / 255, green: 121 / 255, blue: 121 / 255, alpha: 1).cgColor
        
        currentQuestionBox.layer.shadowColor = UIColor(red: 255 / 255, green: 239 / 255, blue: 117 / 255, alpha: 1).cgColor
        currentQuestionBox.layer.shadowRadius = 14
        currentQuestionBox.layer.shadowOpacity = isLight ? 1 : 0
        
        if isLight {
            currentQuestionBox.addSubview(questionBoxQuestionMarkLabel)
            
            questionBoxQuestionMarkLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        } else {
            questionBoxQuestionMarkLabel.removeFromSuperview()
        }
    }
    
    private func setupQuestionBoxes() {
        let boxTexts = questionTexts
        
        var currentWidth: CGFloat = 0
        
        var questionBoxStackView: UIStackView?
        
        for boxText in boxTexts {
            let boxView = UIView().then {
                $0.layer.borderColor = UIColor(red: 121 / 255, green: 121 / 255, blue: 121 / 255, alpha: 1).cgColor
                $0.layer.borderWidth = 2
                $0.layer.cornerRadius = 2
                $0.backgroundColor = .white
            }
            
            questionBoxes.append(boxView)
            
            var boxWidth = (boxText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)]).width + 32
            
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
        let choiceTexts = questionDic[questionTexts[currentQuestionStep]]!.shuffled()
        
        for i in 0..<choiceTexts.count {
            if choiceTexts[i] == "" { continue }
            
            let choiceButton = ChoiceButton(text: choiceTexts[i], index: i)
            
            choiceButton.addTarget(
                self,
                action: #selector(didTapChoiceButton),
                for: .touchUpInside
            )
            
            if OrientationManager.landscapeSupported {
                let buttonWidth = choiceTexts.count > 3 ? (frame.width - 32) / CGFloat(choiceTexts.count) : (frame.width - 32) / 3
                
                choiceButton.snp.makeConstraints {
                    $0.width.equalTo(buttonWidth)
                    $0.height.equalTo(53)
                }
            } else {
                choiceButton.snp.makeConstraints {
                    $0.width.equalTo(frame.width - 32)
                    $0.height.equalTo(64)
                }
            }
            
            choiceButtonStackView.addArrangedSubview(choiceButton)
        }
    }
    
    private func setupLayout() {
        if OrientationManager.landscapeSupported {
            backgroundColor = .clear
            choiceButtonStackView.axis = .horizontal
            questionBackgroundView.layer.cornerRadius = 12
            
            container.layer.borderWidth = 4.0
            container.layer.borderColor = UIColor(hexCode: "ffb820").cgColor
            container.clipsToBounds = true
            container.layer.cornerRadius = 12
            container.backgroundColor = .white
            
            addSubview(container)
            
            container.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(16)
            }
            
            [
                descriptionLabel,
                questionBackgroundView,
                choiceButtonStackView
            ].forEach {
                container.addSubview($0)
            }
            
            descriptionLabel.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.top.equalToSuperview().inset(16)
            }
            
            questionBackgroundView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            }
            
            questionBackgroundView.addSubview(questionBoxTotalStackView)
            questionBackgroundView.addSubview(questionMeanLabel)
            
            questionBoxTotalStackView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.greaterThanOrEqualToSuperview().inset(16)
                $0.bottom.equalTo(questionBackgroundView.snp.centerY).offset(-8)
            }
            
            questionMeanLabel.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.top.equalTo(questionBackgroundView.snp.centerY).offset(8)
                $0.bottom.greaterThanOrEqualToSuperview().inset(16)
            }
            
            choiceButtonStackView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(questionBackgroundView.snp.bottom).offset(16)
                $0.bottom.equalToSuperview().inset(16)
            }
        } else {
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
                $0.centerX.equalToSuperview()
                $0.top.equalTo(questionBackgroundView.snp.bottom).offset(40)
            }
        }
    }
}
