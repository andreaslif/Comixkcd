//
//  ComicViewModel.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-12.
//

import Foundation
import UIKit
import CoreData

struct ComicViewModel: Equatable {
    
    let number: Int
    let title: String
    let date: String
    let transcript: String
    let alternativeCaption: String
    let image: UIImage?
    var favourited: Bool
    let link: String
    
    /// Initialize ComicViewModel from a Comic instance.
    init(comic: Comic) {
        
        self.number = Int(comic.num)
        self.title = comic.title
        self.date = dateStringFrom(year: comic.year, month: comic.month, day: comic.day)
        self.transcript = comic.transcript
        self.alternativeCaption = comic.alt
        self.image = imageFrom(imageUrlString: comic.img)
        
        self.favourited = false
        
        // Link seems to always be empty (perhaps not used by server?). Let's create our own link as long as that's the case.
        if comic.link.isEmpty {
            self.link = "https://xkcd.com/\(number)/"
        } else {
            self.link = comic.link
        }
    }
    
    /// Initialize ComicViewModel from NSManagedObject.
    init(managedObject: NSManagedObject) {
        
        self.number = managedObject.value(forKey: CoreDataManager.ComicKeys.number) as? Int ?? 0
        self.title = managedObject.value(forKey: CoreDataManager.ComicKeys.title) as? String ?? ""
        self.date = managedObject.value(forKey: CoreDataManager.ComicKeys.date) as? String ?? ""
        self.transcript = managedObject.value(forKey: CoreDataManager.ComicKeys.transcript) as? String ?? ""
        self.alternativeCaption = managedObject.value(forKey: CoreDataManager.ComicKeys.alternativeCaption) as? String ?? ""
        self.favourited = managedObject.value(forKey: CoreDataManager.ComicKeys.favourited) as? Bool ?? false
        self.link = managedObject.value(forKey: CoreDataManager.ComicKeys.link) as? String ?? ""
        
        if let imageData = managedObject.value(forKey: CoreDataManager.ComicKeys.imageData) as? Data {
            self.image = imageFrom(data: imageData)
        } else {
            self.image = nil
        }
    }
    
    /// Needed to conform to Equatable protocol, which is necessary to check if one ComicViewModel is equal to another. We're defining here that two ComicViewModels with the same number parameter are equal.
    static func == (lhs: ComicViewModel, rhs: ComicViewModel) -> Bool {
        return lhs.number == rhs.number
    }
}

// MARK: - Supporting functions

/// Returns a date from the specified year, month and day as a String. Localization not yet supported.
private func dateStringFrom(year: String, month: String, day: String) -> String {
    
    let month = insertLeadingZeroIfNeededFor(monthOrDay: month)
    let day = insertLeadingZeroIfNeededFor(monthOrDay: day)
    
    // TODO: Localize date according to users regional settings.
    return "\(year)-\(month)-\(day)"
}

// TODO: Add test?
/// Inserts a leading zero for single integer numbers that represents days or months. Can be used to e.g. turn '2021-5-12' into '2021-05-12'.
private func insertLeadingZeroIfNeededFor(monthOrDay: String) -> String {
    
    if monthOrDay.count == 1 {
        return "0\(monthOrDay)"
    }
    
    return monthOrDay
}

/// Returns a UIImage from the provided URL string, or nil if one cannot be found.
private func imageFrom(imageUrlString: String) -> UIImage? {
    
    var image: UIImage? = nil
    
    guard let imageUrl = URL(string: imageUrlString) else {
        print("Failed to create url for image at: \(imageUrlString)")
        return nil
    }
    
    if let data = try? Data(contentsOf: imageUrl) {
        image = imageFrom(data: data)
    } else {
        print("Failed to get image data from: \(imageUrl)")
    }
    
    return image
}

/// Returns a UIImage from the provided data, or nil if one cannot be created.
private func imageFrom(data: Data) -> UIImage? {
    
    if let image = UIImage(data: data) {
        return image
    } else {
        print("Failed to convert image from data.")
        return nil
    }
}
