//
//  HeadLinesViewController.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 04/07/2022.
//

import UIKit
import Moya
import NVActivityIndicatorView

class HeadLinesViewController: UIViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var categoriesCV: UICollectionView!
    @IBOutlet weak var articlesTV: UITableView!
    
    @IBOutlet weak var headlinesView: UIView!
    
    
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
    
    var topHeadlines: [Article]?
    override func viewDidLoad() {
        super.viewDidLoad()

        configureActivityIndicatorView()
        loadNews(for: "general")
        loadNewsCategories()
        configureArticlesTV()
        configureCategriesCV()
    }
    
    private func configureArticlesTV() {
        articlesTV.delegate = self
        articlesTV.dataSource = self
        
        articlesTV.register(UINib(nibName: K.headlinesTVCellReuseId, bundle: nil), forCellReuseIdentifier: K.headlinesTVCellReuseId)
    }
    
    private func configureActivityIndicatorView() {
        activityIndicatorView = NVActivityIndicatorView(frame: headlinesView.frame, type: .lineScalePulseOutRapid, color: .gray, padding: 0)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        headlinesView.addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 80),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 80),
            activityIndicatorView.centerXAnchor.constraint(equalTo: headlinesView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: headlinesView.centerYAnchor)
        ])
    }
    
    private func showHeadlineDetailsVC(for index: Int) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = mainStoryboard.instantiateViewController(identifier: K.headlinesDetailsVCId) as? HeadlineDetailsViewController else { return }
        vc.urlString = articles?[index].url
        self.navigationController?.pushViewController(vc, animated: true)
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
        activityIndicatorView.startAnimating()
        ApiSrvice.sharedArticleProvider.request(.withCategory(category: category)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let articlesData = try JSONDecoder().decode(ArticleModel.self, from: response.data)
                    
                    self?.topHeadlines = articlesData.articles
                    self?.articles = articlesData.articles
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                        self?.activityIndicatorView.stopAnimating()
                    }
                } catch {
                    print("Some ERROR happened while parsing api data!")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}


extension HeadLinesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showHeadlineDetailsVC(for: indexPath.row)
        articlesTV.deselectRow(at: indexPath, animated: true)
    }
}


extension HeadLinesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = articlesTV.dequeueReusableCell(withIdentifier: K.headlinesTVCellReuseId, for: indexPath) as? HeadlinesTVCell else { return UITableViewCell() }
        
        cell.configure(article: articles?[indexPath.row])
            
        return cell
    }
    
    
}


extension HeadLinesViewController: UICollectionViewDelegateFlowLayout {
    
}

extension HeadLinesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedCategoryInd == indexPath.row {
            // Don't reload the data again!
            return
        }
        
        selectedCategoryInd = indexPath.item
        var selectedCat = categories[selectedCategoryInd]
        if selectedCategoryInd > 0 {
            selectedCat = String(selectedCat.dropFirst(2))
        }
        loadNews(for: selectedCat.lowercased())
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
