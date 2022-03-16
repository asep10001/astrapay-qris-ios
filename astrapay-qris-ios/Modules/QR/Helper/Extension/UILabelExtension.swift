//
//  UILabelExtension.swift
//  astrapay
//
//  Created by Sandy Chandra on 21/10/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func setupLabel(text: String, size: CGFloat, type: UIFont.FontTypeLibrary, color: UIColor) {
        self.text = text
        self.font = UIFont.setupFont(size: size, fontType: type)
        self.textColor = color
    }
}
