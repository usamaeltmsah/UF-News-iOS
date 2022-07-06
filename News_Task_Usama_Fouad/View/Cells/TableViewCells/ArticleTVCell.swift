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

    @IBOutlet weak var articleView: UIView!
    @IBOutlet weak var publishedAtLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Variables
    var activityIndicatorView: NVActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        articleView.dropShadow(color: .black, offSet: .zero, radius: 2)
        
        configureActivityIndicatorView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configureActivityIndicatorView() {
        activityIndicatorView = NVActivityIndicatorView(frame: articleImageView.frame, type: .ballClipRotateMultiple, color: .white, padding: 0)
//        activityIndicatorView.backgroundColor = .cyan
        activityIndicatorView.cornerRadius = 15
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        articleImageView.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 30),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 30),
            activityIndicatorView.centerXAnchor.constraint(equalTo: articleImageView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: articleImageView.centerYAnchor)
        ])
    }
    
    func configure(article: Article?) {
        activityIndicatorView.startAnimating()
        
        titleLabel.text = article?.title
        
        if let publishedAt = article?.publishedAt {
            publishedAtLabel.text = "Published at \(publishedAt)"
        } else {
//            publishedAtLabel.text = "Unkown puplish date"
            publishedAtLabel.isHidden = true
        }
        
        authorLabel.text = article?.author
        
        if let imageUrl = article?.urlToImage {
            articleImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder")) { [weak self] _, _, _, _ in
                self?.activityIndicatorView.stopAnimating()
            }
        }
        
        descriptionLabel.text = article?.description
    }
    
}
