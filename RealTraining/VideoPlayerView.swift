//
//  VideoPlayerView.swift
//  RealTraining
//
//  Created by yc on 2023/09/24.
//

import UIKit
import AVFoundation

protocol VideoPlayerViewDelegate: AnyObject {
    func didFinishPlaying()
    func didFinishPrepareVideoPlayer(_ isFinish: Bool)
}

final class VideoPlayerView: UIView {
    
    weak var delegate: VideoPlayerViewDelegate?
    
    let videoURLString: String
    
    var avPlayer: AVPlayer?
    var avPlayerItem: AVPlayerItem?
    
    private lazy var avPlayerLayer = AVPlayerLayer()
    
    var isFinishLoad = false
    
    var videoLoadObserver: NSKeyValueObservation?
    
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
        
        videoLoadObserver = avPlayerItem?.observe(\.isPlaybackLikelyToKeepUp, options: .new) { [weak self] _, _ in
            guard let self = self else {
                return
            }
            
            if self.avPlayerItem?.isPlaybackLikelyToKeepUp == true {
                self.delegate?.didFinishPrepareVideoPlayer(true)
            }
        }
        
        NotificationCenter.default
            .addObserver(self,
            selector: #selector(didFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: avPlayerItem
        )
        
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
    
    @objc func didFinishPlaying() {
        delegate?.didFinishPlaying()
    }
    
    deinit {
        videoLoadObserver?.invalidate()
    }
}
