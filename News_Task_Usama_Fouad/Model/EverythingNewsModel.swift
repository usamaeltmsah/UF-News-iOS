//
//  EverythingNews.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 07/07/2022.
//

import Foundation

struct EverythingNewsModel {
    var q: String = ""
    var domains:String = ""
    var languages: String = ""
    var pageSize: Int = 0
    var page: Int = 0
    
    func getParams() -> [String:Any] {
        var params = [String:Any]()
        
        if q.count > 0 {
            params["q"] = q
        }
        
        if domains.count > 0 {
            params["domains"] = domains
        }
        
        if languages.count > 0 {
            params["language"] = languages
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
