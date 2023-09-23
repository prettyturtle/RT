//
//  VideoPlayerView.swift
//  RealTraining
//
//  Created by yc on 2023/09/24.
//

import UIKit
import AVFoundation

final class VideoPlayerView: UIView {
    let videoURLString: String
    
    var avPlayer: AVPlayer?
    var avPlayerItem: AVPlayerItem?
    
    private lazy var avPlayerLayer = AVPlayerLayer()
    
    init(videoURLString: String) {
        self.videoURLString = videoURLString
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
    }
    
    func setupPlayer() {
        guard let videoURL = URL(string: videoURLString) else {
            return
        }
        
        avPlayerItem = AVPlayerItem(url: videoURL)
        avPlayer = AVPlayer(playerItem: avPlayerItem)
        
        avPlayerLayer.player = avPlayer
        
        layer.addSublayer(avPlayerLayer)
    }
    
    func setupPlayerLayer() {
        avPlayerLayer.frame = bounds
    }
    
    func play() {
        avPlayer?.play()
    }
    
    func pause() {
        avPlayer?.pause()
    }
}
