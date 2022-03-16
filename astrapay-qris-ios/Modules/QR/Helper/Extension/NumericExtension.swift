//
// Created by Gilbert on 14/12/21.
// Copyright (c) 2021 Astra Digital Arta. All rights reserved.
//

import Foundation


extension Numeric {

    func toIDRQR(withSymbol: Bool = true, isCommaSeparator : Bool = false) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        if withSymbol {
            formatter.currencySymbol = "Rp "
        }else{
            formatter.currencySymbol = ""
        }
        if isCommaSeparator {
            formatter.currencyGroupingSeparator = ","
        }
        formatter.usesGroupingSeparator = true
        return formatter.string(from: self as! NSNumber)
    }
}