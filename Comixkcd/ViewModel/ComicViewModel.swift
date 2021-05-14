//
//  ComicViewModel.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-12.
//

import Foundation
import UIKit

struct ComicViewModel {
    
    let number: Int
    let title: String
    let date: String
    let transcript: String
    let alternativeCaption: String
    let image: UIImage?
    var unread: Bool
    var favourited: Bool
    
    // Initialize ComicViewModel from a Comic instance.
    init(comic: Comic) {
        
        self.number = Int(comic.num)
        self.title = comic.title
        self.date = dateStringFrom(year: comic.year, month: comic.month, day: comic.day)
        self.transcript = comic.transcript
        self.alternativeCaption = comic.alt
        self.image = imageFrom(imageUrlString: comic.img)
        
        self.unread = true
        self.favourited = false
    }
}

// MARK: - Supporting functions

/// Returns a date from the specified year, month and day as a String. Localization not yet supported.
private func dateStringFrom(year: String, month: String, day: String) -> String {
    
    // TODO: Localize date according to users regional settings.
    return "\(year)-\(month)-\(day)"
}

/// Returns a UIImage from the provided URL string, or nil if one cannot be found.
private func imageFrom(imageUrlString: String) -> UIImage? {
    
    var image: UIImage? = nil
    
    guard let imageUrl = URL(string: imageUrlString) else {
        print("Failed to create url for image at: \(imageUrlString)")
        return nil
    }
    
    if let data = try? Data(contentsOf: imageUrl) {
        if let imageFromData = UIImage(data: data) {
            image = imageFromData
        } else {
            print("Failed to convert image data from \(imageUrl) to UIImage")
            return nil
        }
    } else {
        print("Failed to get image data from: \(imageUrl)")
        return nil
    }
    
    return image
}
