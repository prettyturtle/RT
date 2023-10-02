//
//  FeedbackGageView.swift
//  RealTraining
//
//  Created by yc on 2023/10/02.
//

import UIKit
import SnapKit
import Then

final class FeedbackGageView: UIView {
    let level: Int
    let levelPercent: Int
    let score: Int
    let maxScore: Int
    
    private var levelGageBarView: UIView?
    private var scoreGageBarView: UIView?
    
    init(level: Int, levelPercent: Int, score: Int, maxScore: Int) {
        self.level = level
        self.levelPercent = levelPercent
        self.score = score
        self.maxScore = maxScore
        
        super.init(frame: .zero)
        
        setupLayout()
        startGageUpAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var gageTotalStackView = UIStackView().then {
        $0.spacing = 4
    }
    
    private func startGageUpAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.levelGageBarView?.transform = .identity
            self.scoreGageBarView?.transform = .identity
        } completion: { _ in
            print("HELLO World")
        }
    }
    
    private func generateGageView(
        title: String,
        gageNumber: Int,
        gagePercent: Double,
        gageColor: UIColor
    ) -> (gageView: UIView, gageBarView: UIView) {
        let gageView = UIView().then {
            $0.layer.borderColor = UIColor.separator.cgColor
            $0.layer.borderWidth = 0.4
        }
        
        let titleLabel = UILabel().then {
            $0.text = title
            $0.textColor = gageColor
            $0.font = .systemFont(ofSize: 12, weight: .bold)
        }
        
        let gageBarBackgroundView = UIView().then {
            $0.backgroundColor = .init(hexCode: "c5c4c4")
            $0.clipsToBounds = true
        }
        
        let gageBarView = UIView().then {
            $0.backgroundColor = gageColor
        }
        
        let numberLabel = UILabel().then {
            $0.text = "\(gageNumber)"
            $0.font = .systemFont(ofSize: 12, weight: .bold)
            $0.textColor = .white
        }
        
        [
            titleLabel,
            gageBarBackgroundView,
            numberLabel
        ].forEach {
            gageView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(4)
        }
        
        gageBarBackgroundView.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.top.trailing.bottom.equalToSuperview().inset(4)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.height.equalTo(18)
        }
        
        numberLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(gageBarBackgroundView).inset(4)
            $0.centerY.equalTo(gageBarBackgroundView)
        }
        
        gageBarBackgroundView.addSubview(gageBarView)
        
        let gageBarViewWidth = 50.0 * gagePercent
        
        gageBarView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(gageBarViewWidth)
        }
        
        gageBarView.transform = CGAffineTransform(translationX: -gageBarViewWidth, y: 0)
        
        return (gageView, gageBarView)
    }
    
    private func setupLayout() {
        let (levelGageView, levelGageBarView) = generateGageView(
            title: "Level",
            gageNumber: level,
            gagePercent: Double(levelPercent) / Double(100),
            gageColor: .init(hexCode: "4ab4fb")
        )
        
        let (scoreGageView, scoreGageBarView) = generateGageView(
            title: "Score",
            gageNumber: score,
            gagePercent: Double(score) / Double(maxScore),
            gageColor: .init(hexCode: "f16b59")
        )
        
        self.levelGageBarView = levelGageBarView
        self.scoreGageBarView = scoreGageBarView
        
        [
            levelGageView,
            scoreGageView
        ].forEach {
            gageTotalStackView.addArrangedSubview($0)
        }
        
        addSubview(gageTotalStackView)
        
        gageTotalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
