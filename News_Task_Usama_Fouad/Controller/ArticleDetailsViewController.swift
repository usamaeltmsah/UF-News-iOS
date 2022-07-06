//
//  ArticleDetailsViewController.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 06/07/2022.
//

import UIKit

class ArticleDetailsViewController: UIViewController {

    @IBOutlet weak var articleDetailsTV: UITableView!
    
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureArticleTV()
    }
    
    private func configureArticleTV() {
        articleDetailsTV.delegate = self
        articleDetailsTV.dataSource = self
        
        articleDetailsTV.register(UINib(nibName: K.articleDetailTVCellReuseId, bundle: nil), forCellReuseIdentifier: K.articleDetailTVCellReuseId)
    }
}


extension ArticleDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = articleDetailsTV.dequeueReusableCell(withIdentifier: K.articleDetailTVCellReuseId, for: indexPath) as? ArticleDetailsTVCell else { return UITableViewCell() }
        
        cell.configure(article: article)
            
        return cell
    }
    
    
}
