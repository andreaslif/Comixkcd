//
//  Comic.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-12.
//

import Foundation

/// This object has the same structure as the JSON we're fetching.
struct Comic: Decodable {
    
    let month: String
    let num: Double
    let link: String
    let year: String
    let news: String
    let safe_title: String
    let transcript: String
    let alt: String
    let img: String
    let title: String
    let day: String
}
