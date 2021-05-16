//
//  ComicService.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-12.
//

import Foundation
import UIKit

class ComicService: NSObject {

    // MARK: - Variables and constants
    
    static let shared = ComicService()

    // MARK: - Fetcing comics
    
    func fetchComicFrom(url: URL, with session: URLSession, completionHandler: @escaping (Comic?, Error?) -> ()) {
        
        session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            // Check if we get an error back and return if we do.
            if let error = error {
                completionHandler(nil, error)
                print("Failed to fetch data: \(error)")
                return
            }
            
            // If there's no error, data should not be nil. But just to be safe, let's guard against it, in case that changes.
            guard data != nil else {
                completionHandler(nil, nil)
                print("Failed to get data. This should never happen")
                return
            }
            
            do {
                let comic = try JSONDecoder().decode(Comic.self, from: data!)
                
                // Needs to run on main thread
                DispatchQueue.main.async {
                    completionHandler(comic, nil)
                }

            } catch let jsonError {
                print("Failed to decode JSON: ", jsonError)
                completionHandler(nil, jsonError)
            }
        }).resume()
    }
    
    func fetchLatestComic(completionHandler: @escaping (Comic?, Error?) -> ()) {

        if let url = urlForLatestComic() {
            
            fetchComicFrom(url: url, with: URLSession.shared, completionHandler: completionHandler)
        } else {
            print("Failed to fetch latest comic")
        }
    }
    
    func fetchComic(number: Int, completionHandler: @escaping (Comic?, Error?) -> ()) {

        if let url = urlForComic(number: number) {
            
            fetchComicFrom(url: url, with: URLSession.shared, completionHandler: completionHandler)
        } else {
            print("Failed to fetch comic number \(number)")
        }
    }
    
    // MARK: - Source URLs
    
    /// Returns the url for the latest comic, or nil if an URL cannot be created.
    func urlForLatestComic() -> URL? {
        
        let urlString = "https://xkcd.com/info.0.json"
        
        guard let url = URL(string: urlString) else {
            print("Failed to create URL for latest comic")
            return nil
        }
        
        return url
    }
    
    /// Returns the url for the comic with the provided number, or nil if an URL cannot be created.
    private func urlForComic(number: Int) -> URL? {
                
        let urlString = "https://xkcd.com/\(String(number))/info.0.json"
        
        guard let url = URL(string: urlString) else {
            print("Failed to create URL for comic number \(number)")
            return nil
        }
        
        return url
    }
    
}
