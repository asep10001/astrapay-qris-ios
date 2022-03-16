//
//  APFormatter.swift
//  astrapay
//
//  Created by Nur Irfan Pangestu on 07/04/20.
//  Copyright © 2020 Tirta Rivaldi. All rights reserved.
//

import Foundation

import UIKit

class QRAPFormatter {
    static func currency(type: QRCurrencyType = QRCurrencyType.rupiah, withSpacing: Bool = true, number: Int) -> String {
        let format = NumberFormatter()
        format.numberStyle = NumberFormatter.Style.decimal
        let numberFormat = format.string(from: NSNumber(value: number))!
        if withSpacing {
            return "\(type.rawValue) \(numberFormat)"
        }
        return "\(type.rawValue)\(numberFormat)"
    }
    
    static func currency(type: QRCurrencyType = QRCurrencyType.rupiah, minFractionDigits: Int = 1, maxFractionDigits: Int = 5 , withSpacing: Bool = true, number: Double) -> String {
        let format = NumberFormatter()
        format.numberStyle = NumberFormatter.Style.decimal
        format.minimumFractionDigits = minFractionDigits
        format.maximumFractionDigits = maxFractionDigits
        let numberFormat = format.string(from: NSNumber(value: number))!
        if withSpacing {
            return "\(type.rawValue) \(numberFormat)"
        }
        return "\(type.rawValue)\(numberFormat)"
    }
        
    static func removeCurrency(string: String, withSpacing: Bool = true, type: QRCurrencyType = .rupiah) -> Int {
        let valueString = string.isEmpty ? "0" : string
        
        let currency = withSpacing ? "\(type.rawValue) " : type.rawValue
        
        let format = NumberFormatter()
        format.numberStyle = NumberFormatter.Style.currency
        format.currencySymbol = currency
        format.decimalSeparator = valueString.contains(",") ? "," : "."
        format.number(from: valueString)
        return format.number(from: valueString) as? Int ?? 0
    }
    
    static func percentage(number: Int, maxNumber: Int, withSpacing: Bool = true) -> String {
        let total = (number / maxNumber) * 100
        if withSpacing {
            return "\(total) %"
        }
        return "\(total)%"
    }
    
    static func separated(character: String, separator: String) -> [String] {
        return character.components(separatedBy: separator)
    }
    
    static func distance(character: Double) -> String {
        return "\(character) Km"
    }
    
    static func timer(_ number: Int) -> String {
        var minuteStr = ""
        var secondStr = ""
        let minute: Int = number / 60
        let second: Int = number - (minute * 60)
        if minute < 10 {
            minuteStr = "0\(minute)"
        } else {
            minuteStr = "\(minute)"
        }
        
        if second < 10 {
            secondStr = "0\(second)"
        } else {
            secondStr = "\(second)"
        }
        
        return "\(minuteStr) : \(secondStr)"
    }
    
    static func msdn(number: String) -> String {
        var retstr = number
        
        retstr = retstr.replacingOccurrences(of: "(", with: "")
        retstr = retstr.replacingOccurrences(of: ")", with: "")
        
        retstr = retstr.replacingOccurrences(of: " ", with: "")
        retstr = retstr.replacingOccurrences(of: "-", with: "")
        retstr = retstr.replacingOccurrences(of: "*", with: "")
        
        retstr = retstr.replacingOccurrences(of: "+", with: "")
        retstr = retstr.replacingOccurrences(of: "+", with: "")
        
        //Dlog("Mesasgae Num,ber \(retstr)")
        if retstr.hasPrefix("0620")
        {
            retstr = retstr.replacingOccurrences(of: "0620", with: "0")
        }
        if retstr.hasPrefix("062")
        {
            retstr = retstr.replacingOccurrences(of: "062", with: "0")
        }
        
        
        if retstr.hasPrefix("+62")
        {
            retstr = retstr.replacingOccurrences(of: "+62", with: "0")
        }
        if   retstr.hasPrefix("62")
        {
            
            retstr = String(retstr.dropFirst())
            retstr = String(retstr.dropFirst())
            retstr = "0" + retstr
        }
        return retstr
    }
}

enum QRCurrencyType: String {
    case rupiah = "Rp"
    case none = ""
}
