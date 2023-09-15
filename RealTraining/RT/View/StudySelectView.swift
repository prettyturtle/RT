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
}

final class StudySelectView: UIView {
    
    weak var delegate: StudySelectViewDelegate?
    
    let studyInfo: RtQuiz
    
    var questionTexts: [String] {
        let texts = try! JSONSerialization.jsonObject(with: Data(studyInfo.quizRepeat.diosttRepeatChunk.utf8)) as! [String]
        
        return texts
    }
    
    var questionDic: [String: [String]] {
        
        let chunkList = studyInfo.quizMakeup.chunkList
        let jsonChunkList = try! JSONSerialization.jsonObject(with: Data(chunkList.utf8)) as! [String: [String]]
        
        return jsonChunkList
    }
    
    var currentQuestionStep = 0
    
    lazy var choiceTexts = Array(repeating: "", count: questionTexts.count)
    
    var questionBoxes = [UIView]()
    
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
            setupNextButton()
            return
        }
        
        let isCorrect = questionTexts[step] == choiceTexts[step]
        
        let oxImageView = UIImageView()
        
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
        
        UIView.animate(withDuration: 0.4) {
            oxImageView.transform = .identity
        } completion: { [weak self] _ in
            self?.giveOX(step + 1)
        }
    }
    
    private func setupNextButton() {
        addSubview(nextButton)
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(50)
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
        let choiceTexts = questionDic[questionTexts[currentQuestionStep]]!.shuffled()
        
        for i in 0..<choiceTexts.count {
            let choiceButton = ChoiceButton(text: choiceTexts[i], index: i)
            
            choiceButton.addTarget(
                self,
                action: #selector(didTapChoiceButton),
                for: .touchUpInside
            )
            
            choiceButton.snp.makeConstraints {
                $0.width.equalTo(frame.width - 32)
                $0.height.equalTo(64)
            }
            
            choiceButtonStackView.addArrangedSubview(choiceButton)
        }
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
            $0.centerX.equalToSuperview()
            $0.top.equalTo(questionBackgroundView.snp.bottom).offset(40)
        }
    }
}
