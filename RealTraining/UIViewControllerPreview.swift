//
//  UIViewControllerPreview.swift
//  RealTraining
//
//  Created by yc on 2023/09/12.
//

import SwiftUI

struct UIViewControllerPreview: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    let vc: UIViewController
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return vc
    }
}
