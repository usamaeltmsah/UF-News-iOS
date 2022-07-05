//
//  ArticleTVCell.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 05/07/2022.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class ArticleTVCell: UITableViewCell {

    @IBOutlet weak var publishedAtLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    // MARK: - Variables
    var activityIndicatorView: NVActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        startAnimation()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func startAnimation() {
        activityIndicatorView = NVActivityIndicatorView(frame: articleImageView.frame, type: .ballClipRotateMultiple, color: .secondarySystemGroupedBackground, padding: 0)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        articleImageView.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 30),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 30),
            activityIndicatorView.centerXAnchor.constraint(equalTo: articleImageView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: articleImageView.centerYAnchor)
        ])
        activityIndicatorView.startAnimating()
    }
    
    private func stopAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.activityIndicatorView.stopAnimating()
            self?.activityIndicatorView.removeFromSuperview()
        }
    }
    
    func configure(article: Article?) {
        titleLabel.text = article?.title
        
        if let publishedAt = article?.publishedAt {
            publishedAtLabel.text = "Published at \(publishedAt)"
        } else {
//            publishedAtLabel.text = "Unkown puplish date"
            publishedAtLabel.isHidden = true
        }
        
        if let author = article?.author {
            authorLabel.text = author
        } else {
//            authorLabel.text = "Unkown author"
            authorLabel.isHidden = true
        }
        
        if let imageUrl = article?.urlToImage {
            articleImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
            
            stopAnimation()
        }
    }
    
}
