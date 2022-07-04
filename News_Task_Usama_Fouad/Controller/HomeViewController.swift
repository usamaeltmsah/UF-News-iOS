//
//  HomeViewController.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 04/07/2022.
//

import UIKit
import Moya

class HomeViewController: UIViewController {

    var articles: [Article]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiSrvice.sharedArticleProvider.request(.everything(q: "technology")) { result in
            switch result {
            case .success(let response):
                do {
                    let articlesData = try JSONDecoder().decode(ArticleModel.self, from: response.data)
                    
                    self.articles = articlesData.articles
                } catch {
                    print("Some ERROR happened while parsing api data!")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


}

