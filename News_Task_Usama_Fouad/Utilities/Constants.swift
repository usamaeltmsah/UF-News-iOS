//
//  Constants.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 04/07/2022.
//

import Foundation
import UIKit


struct K {
    static let apiKey = "71a91c64360d40508576adbd787c2556"
    
    
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
    
    static let newsCategories = ["General", "🎮 Entertainment", "💻 Technology", "📚 Science", "⛑ Health", "🏓 Sports", "👷‍♂️ Business"]
}
