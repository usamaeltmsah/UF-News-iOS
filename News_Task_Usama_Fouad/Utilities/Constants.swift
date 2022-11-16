//
//  Constants.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 04/07/2022.
//

import Foundation
import UIKit


struct K {
    static let apiKey = {API_KEY}
    
    static var deviceLanguage: String?
    static var localRegionCode: String?
    
    static let articlesTVCellReuseId = "ArticleTVCell"
    static let categoriesCVCellReuseId = "CategoryCVCell"
    
    static let articleDetailTVCellReuseId = "ArticleDetailsTVCell"
    static let articleDetailsVCId = "ArticleDetailsViewController"
    
    static let headlinesTVCellReuseId = "HeadlinesTVCell"
    static let headlinesDetailsVCId = "HeadlineDetailsViewController"
    
    struct Colors {
        static let defaultCategoryBackgound = UIColor(named: "Category Background Color")
        static let defaultCategoryLabel = UIColor(named: "Category Label Color")
        static let selectedCategoryBackgound = UIColor(named: "Selected Category Background Color")
        static let selectedCategoryLabel = UIColor.white
    }
    
    static let newsCategoriesLocalKeys: [String.LocalizationValue] = ["news_cat_general", "news_cat_entertainment", "news_cat_technology", "news_cat_science", "news_cat_health", "news_cat_sports", "news_cat_business"]
    static var newsCategories = ["General", "🎮 Entertainment", "💻 Technology", "📚 Science", "⛑ Health", "🏓 Sports", "👷‍♂️ Business"]
}
