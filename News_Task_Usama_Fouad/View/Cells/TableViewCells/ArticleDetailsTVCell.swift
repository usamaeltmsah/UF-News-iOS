//
//  ArticleDetailsTVCell.swift
//  News_Task_Usama_Fouad
//
//  Created by Usama Fouad on 06/07/2022.
//

import UIKit
import NVActivityIndicatorView

class ArticleDetailsTVCell: UITableViewCell {

    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publishedFromLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(article: Article?) {
        authorLabel.text = article?.author
        publishedFromLabel.text = ""
        titleLabel.text = article?.title
        dateLabel.text = article?.publishedAt
        contentLabel.text = article?.content
        
        if let imageUrl = article?.urlToImage {
            articleImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
        }
    }
    
}
