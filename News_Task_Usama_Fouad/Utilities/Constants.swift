//
//  Constants.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 04/07/2022.
//

import Foundation
import UIKit


struct K {
    static let articleTVCellReuseId = "ArticleTVCell"
    static let categoriesCVCellReuseId = "CategoryCVCell"
    
    struct Colors {
        static let defaultCategoryBackgound = UIColor(named: "Category Background Color")
        static let defaultCategoryLabel = UIColor(named: "Category Label Color")
        static let selectedCategoryBackgound = UIColor(named: "Selected Category Background Color")
        static let selectedCategoryLabel = UIColor.white
    }
    
    static let newsCategories = ["All", "🌍 World", "🎮 Games", "💻 Technology", "📚 Education", "⚡️ Energy", "⛑ Health", "🏓 Sport", "🎨 Arts", "👷‍♂️ Business"]
}
