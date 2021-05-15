//
//  Typography.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-12.
//

import Foundation
import UIKit

/// The purpose of this is to store any font related constants in one place
struct Typography {
    
    struct FontSize {
        static let tableViewMain: CGFloat = 18
        static let tableViewDetailed: CGFloat = 12
        static let caption: CGFloat = 12
    }
    
    struct Font {
        static let tableViewMain: UIFont = UIFont(name: "HelveticaNeue-Medium", size: Typography.FontSize.tableViewMain) ?? UIFont.systemFont(ofSize: 18)
        static let tableViewDetailed: UIFont = UIFont(name: "HelveticaNeue", size: Typography.FontSize.tableViewDetailed) ?? UIFont.systemFont(ofSize: 12)
        static let caption: UIFont = UIFont(name: "HelveticaNeue", size: Typography.FontSize.caption) ?? UIFont.systemFont(ofSize: 12)
    }
}
