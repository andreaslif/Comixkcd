//
//  CoreDataManager.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-15.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: NSObject {

    // MARK: - Variables and constants
    
    static let shared = CoreDataManager()
    
    static let entityName = "ComicEntity"
    
    /// String representations of each key in the CoreData model, so that we can use variables instead of typing the same strings in several places.
    struct ComicKeys {
        static let date = "date"
        static let alternativeCaption = "alternativeCaption"
        static let favourited = "favourited"
        static let number = "number"
        static let title = "title"
        static let transcript = "transcript"
        static let imageData = "imageData"
        static let link = "link"
    }
    
    // MARK: - Functions

    /// Saves the provided ComicViewModel to CoreData. Returns true if successful, false if not.
    func successfullySave(comicViewModel: ComicViewModel) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: CoreDataManager.entityName, in: managedContext)!
        let entry = NSManagedObject(entity: entity, insertInto: managedContext)
        
        entry.setValue(comicViewModel.date, forKeyPath: ComicKeys.date)
        entry.setValue(comicViewModel.alternativeCaption, forKeyPath: ComicKeys.alternativeCaption)
        entry.setValue(comicViewModel.favourited, forKeyPath: ComicKeys.favourited)
        entry.setValue(comicViewModel.number, forKeyPath: ComicKeys.number)
        entry.setValue(comicViewModel.title, forKeyPath: ComicKeys.title)
        entry.setValue(comicViewModel.transcript, forKeyPath: ComicKeys.transcript)
        
        if let imageData = comicViewModel.image?.pngData() {
            entry.setValue(imageData, forKeyPath: ComicKeys.imageData)
        } else {
            print("Failed to get image data from comicViewModel #\(comicViewModel.number)")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Failed to save comicViewModel: \(error)")
            return false
        }
        
        return true
    }
    
    /// Returns an array of all ComicViewModels that have been saved to CoreData.
    func allSavedComicViewModels() -> [ComicViewModel] {
        
        let managedObjects = allSavedEntries()
        let comicViewModels = comicViewModelsFrom(managedObjects: managedObjects)
        
        return comicViewModels
    }
    
    private func allSavedEntries() -> [NSManagedObject] {
        
        var entries: [NSManagedObject] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                print("Failed to fetch saved entries")
                return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataManager.entityName)
        
        do {
            entries = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Failed to fetch saved entries: \(error)")
        }
        
        return entries
    }
    
    private func comicViewModelsFrom(managedObjects: [NSManagedObject]) -> [ComicViewModel] {
        
        var comicViewModels = [ComicViewModel]()
        
        for managedObject in managedObjects {
            
            let comicViewModel = ComicViewModel(managedObject: managedObject)
            comicViewModels.append(comicViewModel)
        }
        
        return comicViewModels
    }
    
}
