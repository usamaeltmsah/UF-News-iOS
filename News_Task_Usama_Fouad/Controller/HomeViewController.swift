//
//  HomeViewController.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 04/07/2022.
//

import UIKit
import Moya
import NVActivityIndicatorView

class HomeViewController: UIViewController {

    
    // MARK: - @IBOutlets
    @IBOutlet weak var categoriesCV: UICollectionView!
    @IBOutlet weak var articlesTV: UITableView!
    
    @IBOutlet weak var newsView: UIView!
    
    
    // Variables
    var activityIndicatorView: NVActivityIndicatorView!
    
    private var articles: [Article]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.articlesTV.reloadData()
            }
        }
    }
    private var selectedCategoryInd = 0
    private var categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startAnimation()
        loadNews(for: "all")
        loadNewsCategories()
        configureArticlesTV()
        configureCategriesCV()
    }
    
    private func configureArticlesTV() {
        articlesTV.delegate = self
        articlesTV.dataSource = self
        
        articlesTV.register(UINib(nibName: K.articleTVCellReuseId, bundle: nil), forCellReuseIdentifier: K.articleTVCellReuseId)
    }
    
    private func startAnimation() {
        activityIndicatorView = NVActivityIndicatorView(frame: newsView.frame, type: .lineScalePulseOutRapid, color: .gray, padding: 0)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        newsView.addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 80),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 80),
            activityIndicatorView.centerXAnchor.constraint(equalTo: newsView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: newsView.centerYAnchor)
        ])
        activityIndicatorView.startAnimating()
    }
    
    private func stopAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.activityIndicatorView.stopAnimating()
            self?.activityIndicatorView.removeFromSuperview()
        }
    }
    
    private func configureCategriesCV() {
        categoriesCV.delegate = self
        categoriesCV.dataSource = self
        
        categoriesCV.register(UINib(nibName: K.categoriesCVCellReuseId, bundle: nil), forCellWithReuseIdentifier: K.categoriesCVCellReuseId)
    }
    
    private func loadNewsCategories() {
        categories = K.newsCategories
    }
    
    private func loadNews(for category: String) {
        startAnimation()
        ApiSrvice.sharedArticleProvider.request(.everything(q: category)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let articlesData = try JSONDecoder().decode(ArticleModel.self, from: response.data)
                    
                    self?.articles = articlesData.articles
                    
                    self?.stopAnimation()
                } catch {
                    print("Some ERROR happened while parsing api data!")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = articlesTV.dequeueReusableCell(withIdentifier: K.articleTVCellReuseId, for: indexPath) as? ArticleTVCell else { return UITableViewCell() }
        
        cell.configure(article: articles?[indexPath.row])
            
        return cell
    }
    
    
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.contentSize.width, height: 30.0)
//    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryInd = indexPath.item
        loadNews(for: categories[indexPath.item])
        categoriesCV.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoriesCV.dequeueReusableCell(withReuseIdentifier: K.categoriesCVCellReuseId, for: indexPath) as? CategoryCVCell else { return UICollectionViewCell() }
        
        cell.categoryLabel.text = categories[indexPath.item]
        
        if selectedCategoryInd == indexPath.item {
            cell.categoryView.backgroundColor = K.Colors.selectedCategoryBackgound
            cell.categoryLabel.textColor = K.Colors.selectedCategoryLabel
        } else {
            cell.categoryView.backgroundColor = K.Colors.defaultCategoryBackgound
            cell.categoryLabel.textColor =  K.Colors.defaultCategoryLabel
        }
            
        return cell
    }
    
    
}
