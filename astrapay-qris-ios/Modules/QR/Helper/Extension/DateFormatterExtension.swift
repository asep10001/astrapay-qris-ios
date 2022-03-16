//
// Created by Gilbert on 03/02/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation

enum LocaleDateQR: String {
    case id = "id"
}

enum FromTypeDateQR: String {

    case defaultAstraPay = "dd/MM/yyyy HH:mm:ss"
    case defaultRegister = "dd MMMM yyyy"

    case ddMMyyyyStrip = "dd-MM-yyyy"
    case ddMMyyyySlash = "dd/MM/yyyy"
    case yyyyMMddStrip = "yyyy-MM-dd"
    case defaultTrxId = "yyyyMMddHHmmss"

    case yyyyMMdd = "yyyyMMdd"

    case ddMMMMyyWithTime = "dd MMMM yyyy - HH:mm:ss"
    case ddMMMMyyTimeNoSecond = "dd MMMM yyyy - HH:mm"
    case ddMMMyyyyHHmm = "dd MMM yyyy - HH:mm"
    case ddMMMyyyyHHmmss = "dd MMM yyyy - HH:mm:ss"

    case defaultListHistory = "yyyy-MM-dd HH:mm:ss"
    case currentListHistoryDate = "d MMM yyyy"
    case currentListHistoryTime = "HH:mm:ss"

    case timeServer = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    case yyyyMMMddStrip = "yyyy-MMM-dd"

    case yyyymm = "yyyyMM"
    case MMMyy = "MMM-yy"
}



enum DFCurrentDateFormatQR : String{
    case defaultAstraPay = "dd/MM/yyyy HH:mm:ss"
    case defaultRegister = "dd MMMM yyyy"
}

extension DateFormatter {
    static func generateCurrentDateQR(_ dateFormat : FromTypeDateQR) -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        dateFormatter.locale = Locale(identifier: LocaleDateQR.id.rawValue)
        let dateString = dateFormatter.string(from: Date())
        return dateString
    }

    static func dateConvertQR(valueDate: String, from: FromTypeDateQR, to: FromTypeDateQR, locale: LocaleDateQR = .id) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: locale.rawValue)
        inputFormatter.dateFormat = from.rawValue
        let showDate = inputFormatter.date(from: valueDate) ?? Date()
        inputFormatter.dateFormat = to.rawValue
        let resultString = inputFormatter.string(from: showDate)
        return resultString

    }
}