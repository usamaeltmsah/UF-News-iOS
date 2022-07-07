//
//  HeadlinesModel.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 07/07/2022.
//

import Foundation

struct HeadlinesModel {
    var q: String = ""
    var category: String = ""
    var country: String = ""
    var languages: String = ""
    var sources: String = ""
    var pageSize: Int = 0
    var page: Int = 0
    
    func getParams() -> [String:Any] {
        var params = [String:Any]()
        
        if q != "" {
            params["q"] = q
        }
        
        if category != "" {
            params["category"] = category
        }
        
        if country != "" {
            params["country"] = country
        }
        
        if languages != "" {
            params["language"] = languages
        }
        
        if sources != "" {
            params["sources"] = sources
        }
        
        if pageSize > 0 {
            params["pageSize"] = pageSize
        }
        
        if page > 0 {
            params["page"] = page
        }
        
        return params
    }
}
