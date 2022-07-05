//
//  ArticleService.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 04/07/2022.
//

import Foundation
import Moya

enum ArticleService {
    case everything(q: String)
    case topHeadlines(q: String)
}

extension ArticleService: TargetType {
    var baseURL: URL {
        return URL(string: "https://newsapi.org/v2")!
    }
    
    var path: String {
        switch self {
        case .everything(_):
            return "/everything"
        case .topHeadlines(_):
            return "/top-headlines"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .everything(_), .topHeadlines(_):
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .everything(let q), .topHeadlines(let q):
            return .requestParameters(parameters: ["q": q], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        let apiKey = "2a7bb0f32a634b7883e94b759d7696d9"
        return [
            "x-api-key": apiKey,
            "Content-type": "application/json"
        ]
    }
}
