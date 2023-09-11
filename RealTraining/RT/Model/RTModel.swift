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
    let chunkList: String
    let bgImg: String
    let boxType: String
    let boxPosX, boxPosY: Int
}

// MARK: - QuizRepeat
struct QuizRepeat: Codable {
    let repeatContentEng, repeatContentKor: String
    let repeatContentMp3: String
    let diosttRepeatScript, diosttRepeatChunk: String
    
    enum CodingKeys: String, CodingKey {
        case repeatContentEng, repeatContentKor, repeatContentMp3
        case diosttRepeatScript = "DIOSTT_repeatScript"
        case diosttRepeatChunk = "DIOSTT_repeatChunk"
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
}
