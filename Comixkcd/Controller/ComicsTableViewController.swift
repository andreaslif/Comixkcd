//
//  ComicsTableViewController.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-12.
//

import UIKit

class ComicsTableViewController: UITableViewController {

    // MARK: - Variables and constants
    
    private var comicViewModels = [ComicViewModel]()
    private var cellId = "ComicTableViewCell"
    private var segueId = "ComicIdentifier"
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        loadLatestComics()
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
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedIndexPath = self.tableView.indexPathForSelectedRow else {
            print("Failed to get selected index path.")
            return
        }
        
        if let destinationViewController = segue.destination as? ComicViewController {
            
            destinationViewController.comicViewModel = comicViewModels[selectedIndexPath.row
            ]
        }
    }

    // MARK: - Navigation bar
    
    private func setupNavigationBar() {
        
        navigationItem.title = "Comics"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Fetching comics
    
    func loadLatestComics() {
                
        if latestComicNumberIsUnknown() {
            
            ComicService.shared.fetchComicFrom(url: ComicService.shared.urlForLatestComic()!, with: URLSession.shared, completionHandler: { comic, error in
                
                guard error == nil else { return }
                guard comic != nil else { return }
                
                let comicViewModel = ComicViewModel(comic: comic!)
                self.comicViewModels.append(comicViewModel)
                self.tableView.reloadData()
                
                //BasicStorage.shared.latestComic = comicViewModel.number
            })
            // Load x more comics
        }
    }

    // MARK: - Conditionals
 
    /// Returns true if the latest comic number is unknown, false otherwise. This should only really be true the first that time the app is launched.
    func latestComicNumberIsUnknown() -> Bool {
        return BasicStorage.shared.latestComic == 0
    }
    
}
