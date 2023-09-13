//
//  ChoiceButton.swift
//  RealTraining
//
//  Created by yc on 2023/09/13.
//

import UIKit
import Then
import SnapKit

final class ChoiceButton: UIButton {
    
    var index: Int?
    let text: String
    
    private lazy var indexLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
    }
    
    private lazy var textLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
    }
    
    private lazy var resultIconImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    
    init(text: String, index: Int? = nil) {
        self.text = text
        self.index = index
        super.init(frame: .zero)
        setupLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCheckedView(isRight: Bool) {
        let icon = isRight ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "xmark.circle.fill")
        let imageColor: UIColor = isRight ? .systemGreen : .systemRed
        let borderColor: CGColor = isRight ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor
        
        resultIconImageView.image = icon
        resultIconImageView.tintColor = imageColor
        layer.borderColor = borderColor
        layer.borderWidth = 1.0
    }
    
    private func setupView() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 1).cgColor
        
        setupLabel()
    }
    
    private func setupLabel() {
        textLabel.text = text
        
        if let index = index,
           let indexEn = UnicodeScalar(65 + index) {
            indexLabel.text = "\(indexEn)."
        } else {
            indexLabel.text = ""
        }
    }
    
    private func setupLayout() {
        [
            indexLabel,
            textLabel,
            resultIconImageView
        ].forEach {
            addSubview($0)
        }
        indexLabel.snp.contentHuggingHorizontalPriority = 101.0
        textLabel.snp.contentHuggingHorizontalPriority = 100.0
        resultIconImageView.snp.contentHuggingHorizontalPriority = 101.0
        
        indexLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16.0)
        }
        textLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(indexLabel.snp.trailing).offset(8.0)
            $0.trailing.equalTo(resultIconImageView.snp.leading).inset(8.0)
        }
        resultIconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16.0)
            $0.size.equalTo(textLabel.snp.height)
        }
    }
}
