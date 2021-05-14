//
//  BasicStorage.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-12.
//

import UIKit

/// String representations of each key, so that we can use variables instead of typing the same strings in several places.
private struct Keys {
    static let latestComic = "latestComic"
}

/// A class for storing simple things to user defaults via the 'shared' singleton.
class BasicStorage: NSObject {

    /// Singleton
    static let shared = BasicStorage()
    
    // MARK: - Variables
    // In this section, we're setting up default values and using didSet to update UserDefaults.
    
    var latestComic: Int = 0 {
        didSet {
            UserDefaults.standard.setValue(latestComic, forKey: Keys.latestComic)
        }
    }
    
    // MARK: - Overriding init
    // When initialized, we check if there's anything already stored in UserDefaults and update the variables accordingly
    
    override init() {
        
        if UserDefaults.standard.object(forKey: Keys.latestComic) != nil {
            latestComic = UserDefaults.standard.object(forKey: Keys.latestComic) as! Int
        }
    
    }
}
