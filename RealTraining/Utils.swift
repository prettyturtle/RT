//
//  Utils.swift
//  RealTraining
//
//  Created by yc on 2023/09/12.
//

import UIKit
import AVFoundation

// MARK: - JSON Decoder In Bundle
func decodeJSONInBundle<T: Codable>(fileName: String) -> T? {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        return nil
    }
    
    guard let data = try? Data(contentsOf: url) else {
        return nil
    }
    
    let decoder = JSONDecoder()
    
    let decodedData = try? decoder.decode(T.self, from: data)
    
    return decodedData
}

// MARK: - Haptic
let haptic = UISelectionFeedbackGenerator()

// MARK: - FX Player

var fxPlayer: AVAudioPlayer?

func playFX(_ fileName: String) {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
        return
    }
    
    fxPlayer = try? AVAudioPlayer(contentsOf: url)
    fxPlayer?.play()
}
