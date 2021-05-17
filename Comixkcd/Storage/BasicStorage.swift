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
    static let readComics = "readComics"
}

/// A class for storing simple things to user defaults via the 'shared' singleton.
class BasicStorage: NSObject {

    /// Singleton
    static let shared = BasicStorage()
    
    // MARK: - Variables
    // In this section, we're setting up default values and using didSet to update UserDefaults.
    
    /// Each Int in this array represnets the number of a comic that has been read.
    /// - The purpose of storing the information this way, as opposed to as a variable in CoreData, is that we don't need to save the entire object (including image) to know if it was read.
    var readComics: [Int] = [] {
        didSet {
            UserDefaults.standard.setValue(readComics, forKey: Keys.readComics)
        }
    }
    
    // MARK: - Overriding init
    // When initialized, we check if there's anything already stored in UserDefaults and update the variables accordingly
    
    override init() {
        
        if UserDefaults.standard.object(forKey: Keys.readComics) != nil {
            readComics = UserDefaults.standard.object(forKey: Keys.readComics) as! [Int]
        }

    }
    
    // MARK: - Functions

    /// Adds the provided number to the list of comics that have been read, if it's not already in there.
    /// - Parameter number: The number of the comic. Typically accessed through the number parameter of a ComicViewModel instance.
    func addToReadList(number: Int) {
        if BasicStorage.shared.readComics.contains(number) == false {
            
            BasicStorage.shared.readComics.append(number)
            BasicStorage.shared.readComics.sort()
        }
    }
    
}
