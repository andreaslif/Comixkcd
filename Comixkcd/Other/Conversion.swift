//
//  Conversion.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-17.
//

import Foundation
import UIKit

/// Returns a UIImage from the provided URL string, or nil if one cannot be found.
func imageFrom(imageUrlString: String) -> UIImage? {
    
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
func imageFrom(data: Data) -> UIImage? {

    if let image = UIImage(data: data) {

        return image
    } else {

        print("Failed to convert image from data.")
        return nil
    }
}
