//
//  HeadlineDetailsViewController.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 06/07/2022.
//

import UIKit
import WebKit

class HeadlineDetailsViewController: UIViewController {
    
    // MARK: - Variables
    var webView: WKWebView!
    var progressView: UIProgressView!
    var urlString: String?
    
    override func loadView() {
        configureWebView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let urlString else { return }
        guard let url = URL(string: urlString) else { return }
        addNavigationItems()
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func configureWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    func addNavigationItems() {
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        navigationItem.rightBarButtonItems = [refresh, progressButton]
    }
}


extension HeadlineDetailsViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        progressView.removeFromSuperview()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}
