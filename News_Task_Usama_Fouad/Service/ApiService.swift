//
//  ApiService.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 05/07/2022.
//

import Foundation
import Moya

class ApiSrvice {
    static let sharedArticleProvider = MoyaProvider<ArticleService>()
}
