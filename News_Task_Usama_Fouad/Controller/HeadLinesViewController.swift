//
//  HeadLinesViewController.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 04/07/2022.
//

import UIKit
import Moya
import NVActivityIndicatorView
//import SafariServices

class HeadLinesViewController: UIViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var categoriesCV: UICollectionView!
    @IBOutlet weak var articlesTV: UITableView!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var headlinesView: UIView!
    
    
    // Variables
    var activityIndicatorView: NVActivityIndicatorView!
    var loading: NVActivityIndicatorView!
    var headlinesModel = HeadlinesModel()
    
//    private var articles: [Article]?
    
    private var selectedCategoryInd = 0 {
        didSet {
            topHeadlines.removeAll()
            headlinesModel.page = 1
        }
    }
    private var categories = [String]()
    
    var topHeadlines = [Article]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.articlesTV.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        configureActivityIndicatorView()
        configureLoadingMoreDataActivityIndicatorView()
        configureHeadlinesModel()
        loadNews()
        loadNewsCategories()
        configureArticlesTV()
        configureCategriesCV()
    }
    
    func configureHeadlinesModel() {
        headlinesModel.category = K.newsCategories.first!
        headlinesModel.languages = K.deviceLanguage ?? "en"
//        headlinesModel.country = K.localRegionCode ?? "eg"
        headlinesModel.pageSize = 20
        headlinesModel.page = 1
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
        
        activityIndicatorView.startAnimating()
    }
    
    func configureLoadingMoreDataActivityIndicatorView() {
        loadingView.isHidden = true
        loading = NVActivityIndicatorView(frame: loadingView.frame, type: .ballSpinFadeLoader, color: .gray, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(loading)

        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 20),
            loading.heightAnchor.constraint(equalToConstant: 20),
            loading.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
    }
    
    private func showHeadlineDetailsVC(for index: Int) {
//        let vc = SFSafariViewController(url: URL(string: (topHeadlines?[index].url)!)!)
//        present(vc, animated: true)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = mainStoryboard.instantiateViewController(withIdentifier: K.headlinesDetailsVCId) as? HeadlineDetailsViewController else { return }
        vc.urlString = topHeadlines[index].url
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureCategriesCV() {
        categoriesCV.delegate = self
        categoriesCV.dataSource = self
        
        categoriesCV.register(UINib(nibName: K.categoriesCVCellReuseId, bundle: nil), forCellWithReuseIdentifier: K.categoriesCVCellReuseId)
    }
    
    private func loadNewsCategories() {
        categories = K.newsCategories
        
        if K.deviceLanguage == "ar" {
            categoriesCV.semanticContentAttribute = .forceLeftToRight
        }
    }
    
    private func loadNews() {
        ApiSrvice.sharedArticleProvider.request(.getHeadlines(paramsModel: headlinesModel)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let articlesData = try JSONDecoder().decode(NewsApiResponse.self, from: response.data)
                    
                    guard let articles = articlesData.articles else {
                        // Show Error Message
                        return
                    }
                    
                    self?.topHeadlines += articles
//                    self?.articles += articlesData.articles
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                        self?.activityIndicatorView.stopAnimating()
                        self?.loading.stopAnimating()
                    }
                } catch {
                    print("Some ERROR happened while parsing api data!")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // UITableView only moves in one direction, y axis
        let currentOffset = articlesTV.contentOffset.y
        let maximumOffset = articlesTV.contentSize.height - articlesTV.frame.size.height

        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 20.0 {
            self.loadMoreNews()
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        UIView.transition(with: loadingView, duration: 0.4, options: .transitionCrossDissolve) { [weak self] in
            self?.loadingView.isHidden = true
        }
    }
    
    func loadMoreNews() {
        UIView.transition(with: loadingView, duration: 0.4, options: .transitionCrossDissolve) { [weak self] in
            self?.loading.startAnimating()
            self?.loadingView.isHidden = false
        }
        
        headlinesModel.page += 1
        loadNews()
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
        return self.topHeadlines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = articlesTV.dequeueReusableCell(withIdentifier: K.headlinesTVCellReuseId, for: indexPath) as? HeadlinesTVCell else { return UITableViewCell() }
        
        cell.configure(article: topHeadlines[indexPath.row])
            
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
        headlinesModel.category = selectedCat.lowercased()
        loadNews()
        categoriesCV.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoriesCV.dequeueReusableCell(withReuseIdentifier: K.categoriesCVCellReuseId, for: indexPath) as? CategoryCVCell else { return UICollectionViewCell() }
        
        cell.categoryLabel.text = categories[indexPath.item]
        cell.categoryLabel.text = NSLocalizedString(K.newsCategoriesLocalKeys[indexPath.item], comment: "")
//        String(localized: K.newsCategoriesLocalKeys[indexPath.item])
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
