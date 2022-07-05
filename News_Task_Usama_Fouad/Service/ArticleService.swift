//
//  ArticleService.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 04/07/2022.
//

import Foundation
import Moya

enum ArticleService {
    case withQuery(q: String)
    case inLanguage(language: String)
//    case everything(page: Int=1)
    case withPages(pageSize: Int)
    case topHeadlines(q: String)
    case withCategory(categoery: String)
}

extension ArticleService: TargetType {
    var baseURL: URL {
        return URL(string: "https://newsapi.org/v2")!
    }
    
    var path: String {
        switch self {
        case .withQuery(_), .inLanguage(_), .withPages(_):
            return "/everything"
        case .topHeadlines(_), .withCategory(_):
            return "/top-headlines"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .withQuery(let q), .topHeadlines(let q):
            return .requestParameters(parameters: ["q": q], encoding: URLEncoding.default)
        case .inLanguage(let language):
            return .requestParameters(parameters: ["language": language], encoding: URLEncoding.default)
        case .withPages(let pageSize):
            return .requestParameters(parameters: ["pageSize": pageSize], encoding: URLEncoding.default)
        case .withCategory(let categoery):
            return .requestParameters(parameters: ["categoery": categoery], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [
            "x-api-key": K.apiKey,
            "Content-type": "application/json"
        ]
    }
}
