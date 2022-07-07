//
//  Article.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 04/07/2022.
//

import Foundation

// MARK: - ArticleModel
struct NewsApiResponse: Codable {
    let status: String
    let totalResults: Int?
    let articles: [Article]?
}

// MARK: - Article
struct Article: Codable {
    let author: String?
    let title, description: String?
    let urlToImage: String?
    let url: String?
    let publishedAt: String?
    let content: String?
}
