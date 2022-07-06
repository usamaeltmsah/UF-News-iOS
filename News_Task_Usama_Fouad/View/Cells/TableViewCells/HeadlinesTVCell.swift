//
//  HeadlinesTVCell.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 06/07/2022.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class HeadlinesTVCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    // MARK: - Variables
    var activityIndicatorView: NVActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
        
        authorLabel.text = article?.author
        
        if let imageUrl = article?.urlToImage {
            articleImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder")) { [weak self] _, _, _, _ in
                self?.activityIndicatorView.stopAnimating()
            }
        }
    }
}
