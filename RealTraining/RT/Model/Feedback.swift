//
//  Feedback.swift
//  RealTraining
//
//  Created by yc on 2023/10/03.
//

import Foundation

struct RTFeedbackModel: Codable {
    let feedbackRTraining: FeedbackRTraining
}

struct FeedbackRTraining: Codable {
    let updPlayerInfo: UPDPlayerInfo
    let getThisScore: Int
    let getCellScore: Int
    let maxCellScore: Int
    let returnStamp: String
    let returnData: ReturnData
    let getBadgeList: String
    let getCoreExprList: String
    let maxUpInfo: MaxUpInfo
}

struct UPDPlayerInfo: Codable {
    let level: Int
    let exp: Int
    let nextExp: Int
    let levelPercent: Int
    let freeTrialCnt: Int
    let promotionInfo: PromotionInfo
}

struct PromotionInfo: Codable {
    let isPromoted: Int
    let levelupImage: String
}

struct ReturnData: Codable {
    let returnGradeCount: ReturnGradeCount
    let returnGradeList: ReturnGradeList
}

struct ReturnGradeCount: Codable {
    let cntRed: Int
    let cntOrange: Int
    let cntGreen: Int
    let cntTryAgain: Int
    let cntOk: Int
    let cntGood: Int
    let cntExcellent: Int
}

struct ReturnGradeList: Codable {
    let returnGrade: [String]
    
    var decodedReturnGrade: [ReturnGrade] {
        
        let jsonDecoder = JSONDecoder()
        
        let decodedDatas: [ReturnGrade?] = returnGrade.map { grade in
            guard let data = grade.data(using: .utf8) else { return nil }
            
            do {
                return try jsonDecoder.decode(ReturnGrade.self, from: data)
            } catch {
                print("ERROR : \(error.localizedDescription)")
                return nil
            }
        }
        
        return decodedDatas.compactMap { $0 }
    }
}

struct ReturnGrade: Codable {
    let quiz: [Quiz]
    let `repeat`: [Repeat]
    let idx: String
    let repeatPhase: Int
    
    struct Quiz: Codable {
        let result: String
        let chunk: String
    }
    
    struct Repeat: Codable {
        let word: String
        let wordScore: Int
        let grade: String
    }
}

struct MaxUpInfo: Codable {
    let status: String
    let errorCode: Int
    let isMaxUpApply: Int
    let getCoin: Int
    let mumInfoJson: String
    let isGetBooster: Int
    let getBoosterInfoJson: String
    let isSuccBooster: Int
    let mumBstSuccGetCoin: Int
    let mucPayAvailListJson: String
    let isCompDayExp: Int
    let compPopupInfoJson: String
}
