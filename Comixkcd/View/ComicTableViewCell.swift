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
            self.favouriteIndicator.tintColor = Color.Icon.favourite
            
            if BasicStorage.shared.readComics.contains(comicViewModel.number) {
                unreadIndicator.alpha = 0
            } else {
                unreadIndicator.alpha = 1
            }
            
            if comicViewModel.favourited {
                favouriteIndicator.alpha = 1
            } else {
                favouriteIndicator.alpha = 0
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Customize cell
        setupFonts()
        setupColors()
    }
    
    // MARK: - UI
    
    private func setupFonts() {
        
        self.numberLabel.font = Typography.Font.tableViewMain
        self.titleLabel.font = Typography.Font.tableViewMain
        self.dateLabel.font = Typography.Font.tableViewDetailed
    }
    
    private func setupColors() {
        
        self.numberLabel.textColor = Color.Font.tableViewMain
        self.titleLabel.textColor = Color.Font.tableViewMain
        self.dateLabel.textColor = Color.Font.tableViewDetailed
        
        self.unreadIndicator.backgroundColor = Color.Accent.main
    }

}
