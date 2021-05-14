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
    }

}
