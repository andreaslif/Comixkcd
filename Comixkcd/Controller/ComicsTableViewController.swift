//
//  ComicsTableViewController.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-12.
//

import UIKit

class ComicsTableViewController: UITableViewController {

    // MARK: - Variables and constants
    
    /// Returns true if a fetch process has already been started, false if not.
    /// - Because fetching new comics is triggered by scrolling to the bottom, several requests could be triggered before one has finished. Keeping track of when a request has started allows us to block this.
    var fetchInProgress = false
    
    var comicViewModels = [ComicViewModel]()
    private var cellId = "ComicTableViewCell"
    private var segueId = "ComicIdentifier"
    
    // MARK: - viewDidLoad etc.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        loadAllSavedComics()
        fetchLatestComics()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: Is there a better place for this function call? We want to call it when transitioning back from viewing a comic to update read/favourite indicators.
        self.tableView.reloadData()
    }
    
    // MARK: - Table view

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comicViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ComicTableViewCell
        let comicViewModel = comicViewModels[indexPath.row]
        cell.comicViewModel = comicViewModel
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: self.segueId, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - Navigation bar
    
    private func setupNavigationBar() {
        
        navigationItem.title = "Comics"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedIndexPath = self.tableView.indexPathForSelectedRow else {
            print("Failed to get selected index path.")
            return
        }
        
        if let destinationViewController = segue.destination as? ComicViewController {
            
            destinationViewController.comicViewModel = comicViewModels[selectedIndexPath.row
            ]
            destinationViewController.comicsTableViewController = self
        }
    }

    // MARK: - Fetching comics
    
    /// Fetches all ComicViewModels that have been saved to CoreData and updates the UITableView with them.
    private func loadAllSavedComics() {

        let savedComicViewModels = CoreDataManager.shared.allSavedComicViewModels()
        updateTableViewWith(comicViewModels: savedComicViewModels)
    }
    
    /// Fetches the latest comics, the number of which are specified under Config.
    private func fetchLatestComics() {
        
        self.fetchInProgress = true
        
        var latestComic: Int? = nil
        var latestComicViewModels = [ComicViewModel]()
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        // Fetch the latest comic
        ComicService.shared.fetchLatestComic(completionHandler: { comic, error in
            
            guard error == nil else { return }
            guard comic != nil else { return }
            
            let latestComicViewModel = ComicViewModel(comic: comic!)
            latestComicViewModels.append(latestComicViewModel)
            latestComic = latestComicViewModel.number
            
            dispatchGroup.leave()
        })
        
        // Wait for latest comic to get fetched, so we know what other ones to fetch
        dispatchGroup.notify(queue: DispatchQueue.global(), execute: {
            
            let innerDispatchGroup = DispatchGroup()
            
            guard latestComic != nil else { return }
            let startIndex = latestComic! - Config.minimumNumberOfComics + 1
            guard startIndex >= 0 else { return }
            
            var latestComicNumbers: [Int] = Array(startIndex..<latestComic!)
            latestComicNumbers = self.removeAlreadyLoadedComicNumbers(from: latestComicNumbers)
            
            for comicNumber in latestComicNumbers {
                
                innerDispatchGroup.enter()
                
                ComicService.shared.fetchComic(number: comicNumber, completionHandler: { comic, error in
                    
                    guard error == nil else { return }
                    guard comic != nil else { return }
                    
                    let comicViewModel = ComicViewModel(comic: comic!)
                    latestComicViewModels.append(comicViewModel)
                    
                    innerDispatchGroup.leave()
                })
            }
            
            // Wait for all fetching to finish.
            innerDispatchGroup.notify(queue: DispatchQueue.global(), execute: {
                
                self.updateTableViewWith(comicViewModels: latestComicViewModels)
            })
        })
    }
    
    /// Fetches the the number of comics specified in Config.comicBatchSize and adds them to the table view.
    private func fetchMoreComics() {
        
        if fetchInProgress == false {
            
            self.fetchInProgress = true
            
            var newComicViewModels = [ComicViewModel]()
            
            let lastNumber = lastComicNumber()
            guard lastNumber != nil else { return }
            
            let startIndex = lastNumber! - Config.comicBatchSize + 1
            guard startIndex > 0 else { return }
            
            let comicsToFetch: [Int] = Array(startIndex..<lastNumber!)
            
            let dispatchGroup = DispatchGroup()
            
            for comicNumber in comicsToFetch {
                
                dispatchGroup.enter()
                
                ComicService.shared.fetchComic(number: comicNumber, completionHandler: { comic, error in
                    
                    guard error == nil else { return }
                    guard comic != nil else { return }
                    
                    let comicViewModel = ComicViewModel(comic: comic!)
                    newComicViewModels.append(comicViewModel)
                    
                    dispatchGroup.leave()
                })
            }
            
            // Wait for all fetching to finish.
            dispatchGroup.notify(queue: DispatchQueue.global(), execute: {
                
                self.updateTableViewWith(comicViewModels: newComicViewModels)
            })
        }
    }
    
    /// Returns the number of the last (oldest fetched) ComicViewModel, or nil if one cannot be found.
    private func lastComicNumber() -> Int? {
        
        let lastComicViewModel = self.comicViewModels.last
        guard lastComicViewModel != nil else { return nil }
        
        return lastComicViewModel?.number
    }
    
    /// Takes the input array of Ints, which represent ComicViewModel number parameters, and removes any that are already in self.comicViewModels.
    /// - A similar filtering is provied by updateTableViewWith(comicViewModels:), but that requires us to first fetch all the Comic objects and convert them to ComicViewModels. This way we can filter the numbers first and then fetch only the ones we need.
    private func removeAlreadyLoadedComicNumbers(from comicNumbers: [Int]) -> [Int] {
        
        var newNumbers = [Int]()
        
        for number in comicNumbers {
            if self.comicViewModels.contains(where: { $0.number == number }) == false {
                newNumbers.append(number)
            }
        }

        return newNumbers
    }
    
    /// Adds the provided ComicViewModel as an entry in the UITableView and updates it, if it's not already in there.
    private func updateTableViewWith(comicViewModels: [ComicViewModel]) {
        
        // If comicViewModel is not already in self.comicViewModels
        for comicViewModel in comicViewModels {
            if self.comicViewModels.contains(where: { $0.number == comicViewModel.number }) == false {
                
                self.comicViewModels.append(comicViewModel)
                self.comicViewModels.sort(by: { $0.number > $1.number })
            }
        }
        
        // Needs to run on main thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.fetchInProgress = false
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let tableViewHeight = self.tableView.frame.height
        let contentHeight = self.tableView.contentSize.height
        let scrollOffset = self.tableView.contentOffset.y
        
        // If reached bottom
        if scrollOffset > contentHeight - tableViewHeight {
            
            fetchMoreComics()
        }
    }
    
}
