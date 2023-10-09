//
//  API.swift
//  RealTraining
//
//  Created by yc on 2023/10/09.
//

import Foundation

enum API {
    static var host: String {
        return getConstantInBundle(key: "API_Host")
    }
    
    enum Path {
        case studyInfo
        
        var value: String {
            switch self {
            case .studyInfo:
                return getConstantInBundle(key: "API_Path_StudyInfo")
            }
        }
    }
    
    static func getStudyInfo() -> NetworkRequest {
        let queryItems: [String: String] = getConstantInBundle(key: "API_Param_StudyInfo")
        
        return NetworkRequest(path: .studyInfo, queryItems: queryItems)
    }
}
