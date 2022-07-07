//
//  ArticleService.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 04/07/2022.
//

import Foundation
import Moya

enum ArticleService {
    case getEverythinNews(paramsModel: EverythingNewsModel)
//    case getHeadlinesWithQuery(q: String)
//    case getHeadlinesWithCategory(category: String)
    case getHeadlines(paramsModel: HeadlinesModel)
}

extension ArticleService: TargetType {
    var baseURL: URL {
        return URL(string: "https://newsapi.org/v2")!
    }
    
    var path: String {
        switch self {
        case .getEverythinNews(_):
            return "/everything"
//        case .getHeadlinesWithQuery(_), .getHeadlinesWithCategory(_):
        case .getHeadlines(_):
            return "/top-headlines"
        }
    }
    
    var method: Moya.Method {
        switch self {
        // It's a GET only Api
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getEverythinNews(let paramsModel):
            let parameters = paramsModel.getParams()
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getHeadlines(let paramsModel):
            let parameters = paramsModel.getParams()
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
//        case .getHeadlinesWithQuery(let q):
//            return .requestParameters(parameters: ["q": q], encoding: URLEncoding.default)
//        case .getHeadlinesWithCategory(let category):
//            return .requestParameters(parameters: ["category": category], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [
            "x-api-key": K.apiKey,
            "Content-type": "application/json"
        ]
    }
}
