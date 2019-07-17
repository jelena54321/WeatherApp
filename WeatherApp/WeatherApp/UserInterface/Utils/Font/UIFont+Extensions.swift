//
//  UIFont.swift
//  WeatherApp
//
//  Created by Jelena Šarić on 08/07/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum QuicksandFontStyle: String {
        case bold = "Bold"
        case light = "Light"
        case medium = "Medium"
        case regular = "Regular"
    }
    
    static func defaultFont() -> UIFont {
        return quicksand(style: .light, size: 27)
    }
    
    static func defaultBoldFont() -> UIFont {
        return quicksand(style: .bold, size: 27)
    }
    
    static func weatherDetailFont() -> UIFont {
        return quicksand(style: .light, size: 18)
    }
    
    static func cityTitleLight() -> UIFont {
        return quicksand(style: .light, size: 23)
    }
    
    static func cityTitleRegular() -> UIFont {
        return quicksand(style: .regular, size: 44)
    }
    
    static func maxTempRegular() -> UIFont {
        return quicksand(style: .regular, size: 28)
    }
    
    static func minTempRegular() -> UIFont {
        return quicksand(style: .regular, size: 20)
    }
    
    static func tempRegular() -> UIFont {
        return quicksand(style: .regular, size: 60)
    }
    
    static func backButtonLight() -> UIFont {
        return quicksand(style: .light, size: 20.0)
    }
    
    private static func quicksand(style: QuicksandFontStyle, size: CGFloat) -> UIFont {
        return UIFont(name: "Quicksand-\(style.rawValue)", size: size)!
    }
}
