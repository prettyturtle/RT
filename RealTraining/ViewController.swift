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
import XMLCoder

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
        sender.setTitle("Loading", for: .normal)
        
        API.getStudyInfo().request(method: "POST") { [weak self] result in
            DispatchQueue.main.async {
                sender.setTitle("SHOW", for: .normal)
            }
            
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let data):
                let xmlDecoder = XMLDecoder()
                do {
                    let studyInfos = try xmlDecoder.decode(RTModel.self, from: data)
                    
                    DispatchQueue.main.async {
                        let vc = RTViewController(studyInfos: studyInfos)
                        let nc = UINavigationController(rootViewController: vc)
                        
                        nc.modalPresentationStyle = .overFullScreen
                        
                        self.present(nc, animated: true)
                    }
                } catch {
                    print("ERROR : \(error)")
                }
            case .failure(let error):
                print("ERROR : \(error)")
            }
        }
    }
}

struct ViewController_Preview: PreviewProvider{
    static var previews: some View {
        UIViewControllerPreview(vc: UINavigationController(rootViewController: ViewController()))
    }
}
