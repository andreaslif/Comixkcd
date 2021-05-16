//
//  ComicViewController.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-14.
//

import UIKit

class ComicViewController: UIViewController {
    
    @IBOutlet weak var comicView: UIImageView!
    @IBOutlet weak var alternativeCaption: UITextView!
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    var comicViewModel: ComicViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComicImage()
        setupCaption()
        setupNavigationBar()
        flagComicAsRead()
    }
    
    private func setupComicImage() {
        
        comicView.image = comicViewModel?.image
    }
    
    private func setupCaption() {
        
        alternativeCaption.text = comicViewModel?.alternativeCaption
        alternativeCaption.font = Typography.Font.caption
        alternativeCaption.textColor = Color.Font.caption
    }
    
    private func setupNavigationBar() {
        
        guard comicViewModel != nil else { return }
        
        navigationItem.title = comicViewModel!.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupFavouriteButton() {
        
        updateFavouriteButton()
    }
    
    private func updateFavouriteButton() {
        
        switch comicViewModel?.favourited {
        case false:
            favouriteButton.image = UIImage(named: "Star")
        case true:
            favouriteButton.image = UIImage(named: "StarFill")
        default:
            favouriteButton.image = UIImage(named: "Star")
            print("Unexpected value found. This should never happen")
        }
    }
    
    private func toggleFavourite() {
        
        switch comicViewModel?.favourited {
        case false:
            comicViewModel?.favourited = true
        case true:
            comicViewModel?.favourited = false
        default:
            comicViewModel?.favourited = false
            print("Unexpected value found. This should never happen")
        }
    }
    
    private func flagComicAsRead() {
        
        guard self.comicViewModel?.number != nil else {
            print("Failed to flag comic as read.")
            return
        }
        
        BasicStorage.shared.addToReadList(number: comicViewModel!.number)
    }
    
    // MARK: - Interaction
    
    @IBAction func didTapFavouriteButton(_ sender: Any) {
        
        updateFavouriteButton()
        
        // TODO: Save change
        toggleFavourite()
    }
    
    @IBAction func didTapActionButton(_ sender: Any) {
        
        // TODO: Display share sheet
    }
    
}
