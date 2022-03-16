//
//  UIFontExtension.swift
//  astrapay
//
//  Created by Sandy Chandra on 21/10/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    enum FontTypeLibrary: String {

        //MARK: V1 Label
        case barlowBlack = "BarlowBlack"
        case barlowBold = "BarlowBold"
        case barlowExtraBold = "BarlowExtraBold"
        case barlowExtraLight = "BarlowExtraLight"
        case barlowLight = "BarlowLight"
        case barlowMedium = "BarlowMedium"
        case barlowRegular = "BarlowRegular"
        case barlowSemiBold = "BarlowSemiBold"
        case barlowThin = "BarlowThin"
        
        case interBlack = "InterBlack"
        case interBold = "InterBold"
        case interExtraBold = "InterExtraBold"
        case interExtraLight = "InterExtraLight"
        case interLight = "InterLight"
        case interMedium = "InterMedium"
        case interRegular = "InterRegular"
        case interSemiBold = "InterSemiBold"
        case interThin = "InterThin"
        
    }
    
    static func setupFont(size: CGFloat, fontType: FontTypeLibrary = FontTypeLibrary.interRegular) -> UIFont {
        return UIFont(name: fontType.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
