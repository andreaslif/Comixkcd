//
//  NavigationViewController.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-14.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        self.navigationBar.tintColor = Color.Accent.main
        self.navigationBar.largeTitleTextAttributes  = [.foregroundColor : Color.Font.title]
        self.navigationBar.titleTextAttributes = [.foregroundColor : Color.Font.title]
    }

}

