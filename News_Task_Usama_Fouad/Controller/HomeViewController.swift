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
    @IBOutlet weak var articlesTV: UITableView!
    
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    
    // Variables
    var activityIndicatorView: NVActivityIndicatorView!
    var loading: NVActivityIndicatorView!
    
    private var articles: [Article] = [Article]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.articlesTV.reloadData()
            }
        }
    }
    
    private var currentArticles: [Article] = [Article]()
    
    private let searchController = UISearchController()
    
    var newsModel = EverythingNews()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        configureActivityIndicatorView()
        configureLoadingMoreDataActivityIndicatorView()
        configureNewsModel()
        activityIndicatorView.startAnimating()
        loadNews()
        configureArticlesTV()
    }
    
    func configureNewsModel() {
        newsModel.domains = "bbc.co.uk,techcrunch.com,engadget.com"
        newsModel.languages = "en"
        newsModel.pageSize = 20
        newsModel.page = 1
    }
    
    private func configureArticlesTV() {
        articlesTV.delegate = self
        articlesTV.dataSource = self
        
        articlesTV.register(UINib(nibName: K.articlesTVCellReuseId, bundle: nil), forCellReuseIdentifier: K.articlesTVCellReuseId)
    }
    
    private func configureActivityIndicatorView() {
        loadingView.isHidden = true
        activityIndicatorView = NVActivityIndicatorView(frame: newsView.frame, type: .lineScalePulseOutRapid, color: .gray, padding: 0)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        newsView.addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 80),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 80),
            activityIndicatorView.centerXAnchor.constraint(equalTo: newsView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: newsView.centerYAnchor)
        ])
    }
    
    func configureLoadingMoreDataActivityIndicatorView() {
        loading = NVActivityIndicatorView(frame: newsView.frame, type: .ballSpinFadeLoader, color: .gray, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(loading)

        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 20),
            loading.heightAnchor.constraint(equalToConstant: 20),
            loading.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
//        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
//        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func filterCurresntArticles(searchQuery: String) {
        if searchQuery.count > 0 {
            currentArticles = articles
            
            let filteredResults = currentArticles.filter {
                guard let title = $0.title, let description = $0.description else { return false }
                
                return title
                    .lowercased()
                    .contains(searchQuery.lowercased()) ||
                description
                    .lowercased()
                    .contains(searchQuery.lowercased())
            }
            
            currentArticles = filteredResults
            articlesTV.reloadData()
        }
    }
    
    private func restoreArticles() {
        currentArticles = articles
        articlesTV.reloadData()
    }
    
    private func loadNews() {
        ApiSrvice.sharedArticleProvider.request(.getEverythinNews(paramsModel: self.newsModel)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let articlesData = try JSONDecoder().decode(NewsApiResponse.self, from: response.data)
                    guard let articles = articlesData.articles else {
                        // Show Error Message
                        return
                    }
                    self?.articles += articles
                    self?.currentArticles += articles
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
    
    private func showArticleDetailsVC(for index: Int) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = mainStoryboard.instantiateViewController(identifier: K.articleDetailsVCId) as? ArticleDetailsViewController else { return }
        vc.article = currentArticles[index]
        self.navigationController?.pushViewController(vc, animated: true)
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
        
        newsModel.page += 1
        loadNews()
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showArticleDetailsVC(for: indexPath.row)
        articlesTV.deselectRow(at: indexPath, animated: true)
    }
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = articlesTV.dequeueReusableCell(withIdentifier: K.articlesTVCellReuseId, for: indexPath) as? ArticleTVCell else { return UITableViewCell() }
        
        cell.configure(article: currentArticles[indexPath.row])
            
        return cell
    }
    
    
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.contentSize.width, height: 30.0)
//    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText == "" {
            self.restoreArticles()
        } else {
            self.filterCurresntArticles(searchQuery: searchText)
        }
    }
}
