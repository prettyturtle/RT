//
//  SummaryView.swift
//  RealTraining
//
//  Created by yc on 2023/10/25.
//

import UIKit
import SnapKit
import Then

final class SummaryView: UIView {
    
    private lazy var capsuleTextLabel = UILabel().then {
        $0.backgroundColor = .init(red: 119 / 255, green: 164 / 255, blue: 246 / 255, alpha: 1)
        $0.text = "학습 결과"
        $0.textColor = .white
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    init(temp: Int, frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        
        [
            capsuleTextLabel
        ].forEach {
            addSubview($0)
        }
        
        capsuleTextLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(16)
            $0.width.equalTo(100)
            $0.height.equalTo(28)
        }
    }
}

