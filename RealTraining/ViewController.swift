//
//  ViewController.swift
//  RealTraining
//
//  Created by yc on 2023/09/08.
//

import UIKit
import SwiftUI
import SnapKit
import Then

final class ViewController: UIViewController {
    
    private lazy var rtOpenButton = UIButton().then {
        $0.setTitle("SHOW", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(
            self,
            action: #selector(didTapRTOpenButton),
            for: .touchUpInside
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(rtOpenButton)
        rtOpenButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    @objc func didTapRTOpenButton(_ sender: UIButton) {
        let vc = RTViewController()
        let nc = UINavigationController(rootViewController: vc)
        
        nc.modalPresentationStyle = .overFullScreen
        
        present(nc, animated: true)
    }
    
}

struct UIViewControllerPreview: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    let vc: UIViewController
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return vc
    }
}

struct ViewController_Preview: PreviewProvider{
    static var previews: some View {
        UIViewControllerPreview(vc: UINavigationController(rootViewController: ViewController()))
    }
}
