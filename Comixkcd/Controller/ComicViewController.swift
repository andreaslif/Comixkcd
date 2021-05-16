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
    
    var comicsTableViewController: ComicsTableViewController? = nil
    var comicViewModel: ComicViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComicImage()
        setupCaption()
        setupNavigationBar()
        flagComicAsRead()
        updateFavouriteButtonAppearance()
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
        
        updateFavouriteButtonAppearance()
    }
    
    private func updateFavouriteButtonAppearance() {
        
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
    
    /// Toggles the currently viewed comic as a favourite. Returns true if successful, false if not.
    private func successfullyToggleFavourite() -> Bool {
        
        guard self.comicViewModel != nil else {
            return false
        }
        
        switch self.comicViewModel!.favourited {
        case false:
            self.comicViewModel?.favourited = true
        case true:
            self.comicViewModel?.favourited = false
        }
        
        if CoreDataManager.shared.successfullySave(comicViewModel: self.comicViewModel!) {
            if successfullyUpdateViewModelInParentViewController() {
                return true
            } else {
                print("Failed to update ComicViewModel in ComicsTableViewController")
            }
        } else {
            print("Failed to save ComicViewModel to CoreData")
        }
        
        return false
    }
    
    private func flagComicAsRead() {
        
        guard self.comicViewModel?.number != nil else {
            print("Failed to flag comic as read.")
            return
        }
        
        BasicStorage.shared.addToReadList(number: comicViewModel!.number)
    }
    
    /// Updates the corresponding ComicViewModel in ComicsTableViewController's array comicViewModels to reflect any changes made, e.g. when the favourite variable has been changed.
    private func successfullyUpdateViewModelInParentViewController() -> Bool {

        guard self.comicViewModel != nil else { return false }
        guard self.comicsTableViewController != nil else { return false }
        
        if let index = comicsTableViewController!.comicViewModels.firstIndex(where: { $0.number == self.comicViewModel!.number }) {

            comicsTableViewController!.comicViewModels.remove(at: index)
            comicsTableViewController!.comicViewModels.insert(self.comicViewModel!, at: index)
            
            return true
        }
        
        return false
    }
        
    // MARK: - Interaction
    
    @IBAction func didTapFavouriteButton(_ sender: Any) {
        
        if successfullyToggleFavourite() {
            updateFavouriteButtonAppearance()
        }
    }
    
    @IBAction func didTapActionButton(_ sender: Any) {
        
        guard self.comicViewModel != nil else {
            print("Failed to share comic. Could not find ComicViewModel")
            return
        }
        
        let url = URL(string: self.comicViewModel!.link)
        guard url != nil else {
            print("Failed to share comic. Could not create URL")
            return
        }
        
        let activityViewController = UIActivityViewController.init(activityItems: [url!], applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
    }

}
