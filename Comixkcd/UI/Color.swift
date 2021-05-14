//
//  Color.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-14.
//

import Foundation
import UIKit

/// The purpose of this is to store any color related constants in one place
/// - The assets in Assets.xcassets are named by their color, instead of their function, which is contrary to what Apple suggests. However, this allows the same color to be used for several functions, which makes changing them easier.
struct Color {
    
    struct Font {
        
        static let title: UIColor = UIColor(named: "GreyHighContrast") ?? UIColor.label
        static let tableViewMain: UIColor = UIColor(named: "GreyHighContrast") ?? UIColor.label
        static let tableViewDetailed: UIColor = UIColor(named: "GreyLowContrast") ?? UIColor.secondaryLabel
    }
    
    struct Accent {
        static let main: UIColor = UIColor(named: "Teal") ?? UIColor.systemTeal
    }
}
