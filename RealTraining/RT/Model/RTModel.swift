//
//  RTModel.swift
//  RealTraining
//
//  Created by yc on 2023/09/12.
//

import Foundation

// MARK: - RTModel
struct RTModel: Codable {
    let rtQuizList: RtQuizList
}

// MARK: - RtQuizList
struct RtQuizList: Codable {
    let rtQuiz: [RtQuiz]
}

// MARK: - RtQuiz
struct RtQuiz: Codable {
    let quizSeq, rtIdx: Int
    let contentEng, contentKor: String
    let quizResource: QuizResource
    let quizMakeup: QuizMakeup
    let quizRepeat: QuizRepeat
}

// MARK: - QuizMakeup
struct QuizMakeup: Codable {
    private let _chunkList: String
    var chunkList: [String: [String]] {
        guard let chunkListData = _chunkList.data(using: .utf8),
              let chunkListJSON = try? JSONSerialization.jsonObject(with: chunkListData) as? [String: [String]] else {
            return [:]
        }
        
        return chunkListJSON
    }
    
    let bgImg: String
    let boxType: String
    let boxPosX, boxPosY: Int
    
    enum CodingKeys: String, CodingKey {
        case _chunkList = "chunkList"
        case bgImg, boxType, boxPosX, boxPosY
    }
}

// MARK: - QuizRepeat
struct QuizRepeat: Codable {
    let repeatContentEng, repeatContentKor: String
    let repeatContentMp3: String
    private let _diosttRepeatScript, _diosttRepeatChunk: String
    
    var diosttRepeatScript: [String] {
        guard let diosttRepeatScriptData = _diosttRepeatScript.data(using: .utf8),
              let diosttRepeatScriptJSON = try? JSONSerialization.jsonObject(with: diosttRepeatScriptData) as? [String] else {
            return []
        }
        
        return diosttRepeatScriptJSON
    }
    
    var diosttRepeatChunk: [String] {
        guard let diosttRepeatChunkData = _diosttRepeatChunk.data(using: .utf8),
              let diosttRepeatChunkJSON = try? JSONSerialization.jsonObject(with: diosttRepeatChunkData) as? [String] else {
            return []
        }
        
        return diosttRepeatChunkJSON
    }
    
    enum CodingKeys: String, CodingKey {
        case repeatContentEng, repeatContentKor, repeatContentMp3
        case _diosttRepeatScript = "DIOSTT_repeatScript"
        case _diosttRepeatChunk = "DIOSTT_repeatChunk"
    }
}

// MARK: - QuizResource
struct QuizResource: Codable {
    let srcMOVPath: String
    let srcMOVDNPath: String
    let srcMOVBlurImg, scriptBegin, scriptEnd: String
    
    enum CodingKeys: String, CodingKey {
        case srcMOVPath = "srcMovPath"
        case srcMOVDNPath = "srcMovDnPath"
        case srcMOVBlurImg = "srcMovBlurImg"
        case scriptBegin, scriptEnd
    }
    
    var movPath: String {
        return srcMOVDNPath
            .replacingOccurrences(
                of: "maxData",
                with: "maxData_HD"
            )
            .replacingOccurrences(
                of: "/_mov",
                with: ""
            )
    }
}
