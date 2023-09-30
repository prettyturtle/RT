//
//  FeedbackResultTableViewCell.swift
//  RealTraining
//
//  Created by yc on 2023/09/30.
//

import UIKit
import SnapKit
import Then

final class FeedbackResultTableViewCell: UITableViewCell {
    static let identifier = "FeedbackResultTableViewCell"
    
    var result: RtQuiz?
    
    private lazy var resultSentenceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .left
    }
    
    private lazy var resultMeanLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textAlignment = .left
        $0.textColor = .secondaryLabel
    }
    
    private lazy var myVoicePlayButton = UIButton().then {
        $0.setTitle("내음성", for: .normal)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.layer.borderWidth = 0.4
        $0.layer.borderColor = UIColor.separator.cgColor
        $0.layer.cornerRadius = 13
    }
    
    private lazy var nativeVoicePlayButton = UIButton().then {
        $0.setTitle("원어민", for: .normal)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.layer.borderWidth = 0.4
        $0.layer.borderColor = UIColor.separator.cgColor
        $0.layer.cornerRadius = 13
    }
    
    func setupView() {
        guard let result = result else {
            return
        }
        
        setupLayout()
        
        resultSentenceLabel.text = result.contentEng.replacingOccurrences(of: "|", with: "")
        
        resultMeanLabel.text = result.contentKor
    }
    
    private func setupLayout() {
        [
            resultSentenceLabel,
            resultMeanLabel,
            myVoicePlayButton,
            nativeVoicePlayButton
        ].forEach {
            addSubview($0)
        }
        
        resultSentenceLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(16)
        }
        
        resultMeanLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(resultSentenceLabel.snp.bottom).offset(16)
        }
        
        myVoicePlayButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(resultMeanLabel.snp.bottom).offset(16)
            $0.width.equalTo(80)
            $0.height.equalTo(26)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        nativeVoicePlayButton.snp.makeConstraints {
            $0.leading.equalTo(myVoicePlayButton.snp.trailing).offset(8)
            $0.top.equalTo(resultMeanLabel.snp.bottom).offset(16)
            $0.width.equalTo(80)
            $0.height.equalTo(26)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}
