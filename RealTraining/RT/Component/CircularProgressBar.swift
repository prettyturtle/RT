//
//  CircularProgressBar.swift
//  RealTraining
//
//  Created by yc on 2023/10/25.
//

import UIKit
import SnapKit

final class CircularProgressBar: UIView {
    
    var lineWidth: CGFloat = 20
    var centerView: UIView = UIView()
    
    var value: Double? {
        didSet {
            guard let _ = value else { return }
            setProgress(self.bounds)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
        
        let bezierPath = UIBezierPath()
        
        bezierPath.addArc(
            withCenter: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.midX - ((lineWidth - 1) / 2),
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        )
        
        bezierPath.lineWidth = lineWidth
        UIColor.systemGray4.set()
        bezierPath.stroke()
    }
    
    func setProgress(_ rect: CGRect) {
        guard let value = value else { return }
        
        subviews.forEach { $0.removeFromSuperview() }
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let bezierPath = UIBezierPath()
        
        bezierPath.addArc(
            withCenter: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.midX - ((lineWidth - 1) / 2),
            startAngle: -.pi / 2,
            endAngle: ((.pi * 2) * value) - (.pi / 2),
            clockwise: true
        )
        
        let shapeLayer = CAShapeLayer()
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        shapeLayer.add(animation, forKey: nil)
        
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.lineCap = .round    // 프로그래스 바의 끝을 둥글게 설정
        
        let color: UIColor = .systemBlue
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        
        self.layer.addSublayer(shapeLayer)
        
        // 프로그래스바 중심에 수치 입력을 위해 UILabel 추가
        addSubview(centerView)
        centerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset((lineWidth + 8) * 2)
        }
    }
}
