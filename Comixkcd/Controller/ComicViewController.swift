//
//  ComicViewController.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-14.
//

import UIKit

class ComicViewController: UIViewController {
    
    // MARK: - Variables and constants
    
    @IBOutlet weak var comicView: UIImageView!
    @IBOutlet weak var alternativeCaption: UITextView!
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    var comicsTableViewController: ComicsTableViewController? = nil
    var comicViewModel: ComicViewModel? = nil
    
    // MARK: - viewDidLoad() etc.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComicImage()
        setupCaption()
        setupNavigationBar()
        flagComicAsRead()
        updateFavouriteButtonAppearance()
    }
    
    // MARK: - Setup functions
    
    /// Loads the image stored in the ComicViewModel if there is one (if it's been favourited), and if not attempts to download one from the imageUrl also stored in the ComicViewModel.
    private func setupComicImage() {
        
        guard self.comicViewModel != nil else { return }
        
        if self.comicViewModel!.image != nil {
            
            self.comicView.image = self.comicViewModel!.image
        } else {
            
            let image = imageFrom(imageUrlString: self.comicViewModel!.imageUrl)
            self.comicView.image = image
            
            // Update the ComicViewModel, so that it gets saved in case the user favourites it.
            self.comicViewModel?.image = image
        }
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
    
    // MARK: - Favourites & read status
    
    private func updateFavouriteButtonAppearance() {
        
        guard self.comicViewModel != nil else { return }
        
        switch self.comicViewModel!.favourited {
        case false:
            favouriteButton.image = UIImage(named: "Star")
        case true:
            favouriteButton.image = UIImage(named: "StarFill")
        }
    }
    
    /// Toggles the currently viewed comic as a favourite. Returns true if successful, false if not.
    private func successfullyToggleFavourite() -> Bool {
        
        guard self.comicViewModel != nil else { return false }
        
        switch self.comicViewModel!.favourited {
        case false:
            self.comicViewModel?.favourited = true
        case true:
            self.comicViewModel?.favourited = false
        }
        
        if CoreDataManager.shared.successfullySave(comicViewModel: self.comicViewModel!) {
            if successfullyUpdateViewModelInComicsTableViewController() {
                
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
        
        guard self.comicViewModel != nil else { return }
        
        BasicStorage.shared.addToReadList(number: comicViewModel!.number)
    }
    
    /// Updates the corresponding ComicViewModel in ComicsTableViewController's array comicViewModels to reflect any changes made, e.g. when the favourite variable has been changed.
    private func successfullyUpdateViewModelInComicsTableViewController() -> Bool {

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
        
        // Only update the favourite button if we actually manage to save the change, so that we don't give the user a false sense of success if we for some reason can't.
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
