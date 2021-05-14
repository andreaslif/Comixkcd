//
//  ComicTableViewCell.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-12.
//

import UIKit

class ComicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var unreadIndicator: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favouriteIndicator: UIImageView!
    
    var comicViewModel: ComicViewModel! {
        didSet {

            self.dateLabel.text = comicViewModel.date
            self.titleLabel.text = comicViewModel.title
            self.numberLabel.text = "#\(comicViewModel.number)"
            
            if comicViewModel.unread {
                unreadIndicator.alpha = 1
            } else {
                unreadIndicator.alpha = 0
            }
            
            if comicViewModel.favourited {
                favouriteIndicator.alpha = 1
            } else {
                favouriteIndicator.alpha = 0
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        // Customize cell
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
