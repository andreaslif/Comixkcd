//
//  Config.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-16.
//

import Foundation

class Config: NSObject {
    
    /// The minimum number of comics that should be loaded on the first screen, including favourites.
    static let minimumNumberOfComics: Int = 10
    
    // MARK: - Unit Tests
    
    /// Determines if we should test making a connection to the server or only test internally.
    /// - Depending on how often the tests are run, e.g. for continuous integration, you may or may not want to make a server connection everytime.
    static let shouldTestServerConnection = false
}
