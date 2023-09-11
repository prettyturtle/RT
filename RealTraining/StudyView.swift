//
//  StudyView.swift
//  RealTraining
//
//  Created by yc on 2023/09/09.
//

import UIKit
import SnapKit
import Then

protocol StudyViewDelegate: AnyObject {
    func studyView(_ sv: StudyView, didTapStartButton: UIButton)
}

final class StudyView: UIView {
    let studyInfo: RtQuiz
    
    weak var delegate: StudyViewDelegate?
    
    init(studyInfo: RtQuiz) {
        self.studyInfo = studyInfo
        
        super.init(frame: .zero)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var thumbnailView = UIImageView().then {
        $0.backgroundColor = .secondarySystemBackground
        let urlString = studyInfo.quizMakeup.bgImg
        let url = URL(string: urlString)!
        let data = try! Data(contentsOf: url)
        $0.image = UIImage(data: data)
    }
    
    private lazy var questionLabel = UILabel().then {
        $0.text = "주어진 문장을 영어로 생각해 보세요."
        $0.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.textAlignment = .center
    }
    
    private lazy var bubbleBorderView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.layer.borderColor = .init(
            red: 251 / 255,
            green: 184 / 255,
            blue: 70 / 255,
            alpha: 1
        )
        $0.layer.borderWidth = 3
    }
    
    private lazy var bubbleImageView = UIImageView().then {
        let urlString = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGAAAABHCAYAAAD4MUK2AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAACBpJREFUeNrsnAlsFUUYx2d2X0sflJa20FJOuVoutZSES4haUQwGULmiCUggaGIiBDWggiJBJCgYQZAIxiiYYCBRwBMkQTQREUoL1CK0thRaOVpKSwstfd0dv+91TJ6K+22vt7MLkwzTkOl72/3t/7tmZnng+4mCWTQ97TXGOw5lXm/1P81m7MblsH+vRk0wS/YIz9/9QLUjN98WAFF2hLMb5Z6+/+LaWce+W6OvzmBm8bfeVoCDD5hmZ5JZ/J1gZp13FeCQ+bENgAWucvPCAcOzBGrLFAeAT0nRbgAgPKqAchcAuHY2UlzO8qYC6ipMp77a5xu7iwfj4H2TOsKA4YD/f31B4Q6hJ6RzzwEwA9SDOAru08FWVQB8ARrCrZYqqMjl4kqO9+yQUUvNqA6XCXobnwfLh6Vwe733FEBGeLVhAQAqyIdhp6UKyo9FiIqT3nLCJvlM3QinE17BiHDHLPiM3W6tBABUcBSGb6xVkM08GxHdvLUNdxi6nDSb+VsCTHjDH3OuU39Im7ACABUcIlVQVRAhLv7oDYfsa0uF1u2dSMSWUL7AyN/KPVEj8rWjFBB2E4QqQCO/3To4K9XNc1+7H0BEO2pGN6dKEa9ikkzkBZDKX3G3D2gTT03p7ggAUEEeDJssP6H+OjPytrhbAZHxlA/o4ZQCsC2FXmHpkM/vZ6Lyd/cqwJ+opgKkCsrosFQw8+TG4OqZO6P8LtSMwU4qANt70PMsEVSfYeaZz92pABpAcv2+SUmOAQAVBGBYQCZn4JDF9fNuDEMh1UqgZqU5qQCEgPGm9SMOOYGZuw6rW+5TQfve1JR0RwHINg96laUpqshl5rkv3QcgpjeVjN3rOABQQYnMDayFkP+pENeK3QUgdgAVio4BPxDptAKwrYd+lDBF3MxZA2O9iwCkwj8aVY4Y4TgAUAHGmnOgByxNUVUBVkzd4wx8bQFCf2rWOBUUgBCyYVhJmqKzuzVRlukeFSQMoaZMUQKAbG9Az6QSNCN3raMbnxoFgN4FngJ+4C4lAMjcYCb0GsuJdZXMOLHKcIM/4NEQikbGUtOmqaIAhJALw0Jqnqg8rZunN6u/fMY50zoNp2bNABVoSgCQENaTCRoLbvDlZsle5Z0yTxpNTcHK6HhlAMg2G3ohCeHUB5ooP642gLg7sSxBqfUZpQCACiqlbbRenwQ/AP5AKF0vglxA65JBJWXjwQz1U0kBCOEIDC+SEwPV3MxeFnTOyjLoMjboD4j7tlApACFZMrlrCxVgZC8XuJqmJAB/Z8bj0ykzNBNU0FUpAKACIbNkcteWuJrHjeMrlS1XaD0mUGYI60KvqKYAhICP9aPQS0kI4JCNnNVKQuAJaZAX3EGpYG5zfYHWGhcPEPCcwQTopI0Rlw4ChDVCveVMyAl6TaVUEAH9TeUASAi4u+5J6AYN4WdunFitHASeeA+qgJo2BVSQoRwACWEXDM/ZmRuEcHwVU2qnHWbGfZ6wM3NDU9cKtNb+GwDCRmZjEScIofQQM7KWKRUd8U7DGY8hzTzWsV9SEoCEgJXTDbYgXMnhRuZik9VVqOMLUucGR6ItBhWkKQlANjRFH9qCUFWgGYcXMlFdpAaC2FTGk++jIiI0QZ8AhCglAcgc4Wnom21BqLnIjMOLTFF2WIkCnt53Bme6n5qGawVrVFXA3xCwkLXJ1i8YNZpxbIVmFmGx1eFqdpsEpvWbZWfms6CCqbbVJRw45QIXiAZ1rd0IqcEZjmD6oPnBtVvnmmBG5hL0U9REjCJGwAN3QkkAISBeZg2HAm0d/sYajTb4BbDJKc4hqLnAjF/m2zlbfA76UIBQqiwACWGW9As+e1LQIUOdDn1K8GdHIJzfz4zf3rUzFZPRcbJcryYACQFXmLZBj7FtkmL6Cm3gPM6jezpyzUbOO0xcOGBn6g/QH5E1MjUBSAgDYNgNva/9EMLHtJ6TG9SgRYaZQC1rRKiMECYChCplAUgIcVIJjdsAFZUY0Ps9pfOk0WGN6oLrGr8+z2xm7vh6gccAwillAUgIaNjxQMiixobJPG4w01Lm2Nnp3HIQsKSOK3z2SuqY3j8sC5VqAggBMZY1vL2lc+PSVg4h60im9Z5up5LZIs0s2cPMk+/bnY5mKEMu4aoLQELAUyl4AvChJhQQBE8cjhETD4cizKIvmJn3sd3pxTJEvaQ0gJCkDbPnVY2Jkv5pmgYxrdt4ADKSt2boahZsa8yLTHYAgGnKAwgB0UOWMJq+Qzkyrl7r+qDOk+/nNs6FhQPCMNcACFED7kfFndnJzfGdPKZPgCeN4TxxVAT3t+z5O8wPDPQJdLb8kasAhIDAl2cslbWkZicAvH0vxuPvFjw+zeQdBuhMj2o+hKpCZmQtpfY/nXElgBAQWBR6C/qkFvtQrhs8NpXz2BR03gaL7qnzdt2b5DvwnUpG1utM6VpQC4EYJXOHjFb5Arj5PBpckD9ZgLniLKoj45EdGMN3TGB1Vvcz7pMv/MBjTvh/8OSLy0epmpHwBIAQEGNkAoe1JTe8XvMPTwEIATEQhvnSYUcpfKmbPAkgBEQnGGZAx1X1/gpeYrqnAfwLxkgYZkGfDD1BgUv6ChKxCbcMgBAQGM7gqffHWcMe1q4OXAaukg3Bg++3HICbJHaDZPT0gAQT28pf+ydrWCXL8UwY2sLqwHcDDYOOZ1ZxoxUuFMW0wMfj9hpc61gQuk58G4A9MPhKLdyfiIkf1qTQuWOZPFH+jNm4X0Zc+DMmBbjJ9RJ0fNL3Qt8JN/4/5+j+EmAAA4oCgoJxJ2AAAAAASUVORK5CYII="
        let url = URL(string: urlString)!
        let data = try! Data(contentsOf: url)
        $0.image = UIImage(data: data)
    }
    
    private lazy var sentenceLabel = UILabel().then {
        $0.text = studyInfo.contentKor
        $0.font = .systemFont(ofSize: 16, weight: .heavy)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var startButton = UIButton().then {
        var titleConfig = AttributeContainer()
        
        titleConfig.foregroundColor = .white
        titleConfig.font = .systemFont(ofSize: 20, weight: .heavy)
        
        var buttonConfig = UIButton.Configuration.filled()
        
        buttonConfig.attributedTitle = AttributedString(
            "시작하기",
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
            action: #selector(didTapStartButton),
            for: .touchUpInside
        )
    }
    
    @objc func didTapStartButton(_ sender: UIButton) {
        delegate?.studyView(self, didTapStartButton: sender)
    }
    
    private func setupLayout() {
        [
            thumbnailView,
            questionLabel,
            bubbleBorderView,
            bubbleImageView,
            sentenceLabel,
            startButton
        ].forEach {
            addSubview($0)
        }
        
        thumbnailView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(3)
        }
        
        questionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(thumbnailView.snp.bottom).offset(32)
        }
        
        bubbleBorderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(questionLabel.snp.bottom).offset(32)
            $0.bottom.equalTo(snp.centerY).multipliedBy(1.4)
        }
        
        bubbleImageView.snp.makeConstraints {
            $0.top.equalTo(bubbleBorderView.snp.bottom).offset(-3)
            $0.trailing.equalTo(bubbleBorderView.snp.trailing).inset(32)
            $0.size.equalTo(30)
        }
        
        sentenceLabel.snp.makeConstraints {
            $0.centerY.equalTo(bubbleBorderView.snp.centerY)
            $0.leading.trailing.equalTo(bubbleBorderView).inset(16)
        }
        
        startButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
}
