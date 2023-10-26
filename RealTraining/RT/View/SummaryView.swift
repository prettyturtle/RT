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
    
    private lazy var circularProgressBarSubView = UIStackView().then { cv in
        cv.axis = .vertical
        cv.spacing = 8
        cv.alignment = .center
        
        [
            UIImageView().then { iv in
                iv.image = UIImage(systemName: "message")
                iv.tintColor = .init(red: 75 / 255, green: 75 / 255, blue: 75 / 255, alpha: 1)
                iv.contentMode = .scaleAspectFit
            },
            UILabel().then { lb in
                lb.text = "SCORE"
                lb.textColor = .init(red: 75 / 255, green: 75 / 255, blue: 75 / 255, alpha: 1)
                lb.font = .systemFont(ofSize: 20, weight: .bold)
            },
            UILabel().then { lb in
                lb.text = "855"
                lb.textColor = .init(red: 232 / 255, green: 102 / 255, blue: 97 / 255, alpha: 1)
                lb.font = .systemFont(ofSize: 36, weight: .bold)
            }
        ].forEach {
            cv.addArrangedSubview($0)
        }
    }
    
    private lazy var circularProgressBar = CircularProgressBar().then {
        $0.lineWidth = 16
        $0.centerView.addSubview(circularProgressBarSubView)
        
        circularProgressBarSubView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    init(temp: Int, frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCircularProgress(value: Double) {
        circularProgressBar.value = value
    }
    
    private func setupView() {
        backgroundColor = .white
        
        [
            capsuleTextLabel,
            circularProgressBar
        ].forEach {
            addSubview($0)
        }
        
        capsuleTextLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(16)
            $0.width.equalTo(100)
            $0.height.equalTo(28)
        }
        
        circularProgressBar.snp.makeConstraints {
            $0.top.equalTo(capsuleTextLabel.snp.bottom).offset(16)
            $0.size.equalTo(240)
            $0.centerX.equalToSuperview()
        }
    }
}
