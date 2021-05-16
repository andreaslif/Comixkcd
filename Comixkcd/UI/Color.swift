//
//  Color.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-14.
//

import Foundation
import UIKit

/// To avoid mistyping strings in the Color struct below, all asset names are available here as variables instead.
/// - If an asset name changes, that change only needs to be updated in one place (here).
private struct AssetNames {
    
    static let greyHighContrast = "GreyHighContrast"
    static let greyLowContrast = "GreyLowContrast"
    static let teal = "Teal"
}

/// The purpose of this is to store any color related constants in one place, easily accessible as e.g. Color.Font.title.
/// - The assets in Assets.xcassets are named by their color, instead of their function, which is contrary to what Apple suggests. However, this allows the same color to be used for several functions, which makes changing them easier.
struct Color {
    
    struct Font {
        
        static let title: UIColor = UIColor(named: AssetNames.greyHighContrast) ?? UIColor.label
        static let tableViewMain: UIColor = UIColor(named: AssetNames.greyHighContrast) ?? UIColor.label
        static let tableViewDetailed: UIColor = UIColor(named: AssetNames.greyLowContrast) ?? UIColor.secondaryLabel
        static let caption: UIColor = UIColor(named: AssetNames.greyLowContrast) ?? UIColor.secondaryLabel
    }
    
    struct Accent {
        
        static let main: UIColor = UIColor(named: AssetNames.teal) ?? UIColor.systemTeal
    }
    
    struct Icon {
        
        static let favourite: UIColor = UIColor(named: AssetNames.greyLowContrast) ?? UIColor.secondaryLabel
    }
}
