//
// Created by Gilbert on 02/02/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation
import UIKit
class QRInputLoginTextField: UITextField {
    var backspaceCalled: (()->())?
    override func deleteBackward() {
        super.deleteBackward()
        backspaceCalled?()
    }
}