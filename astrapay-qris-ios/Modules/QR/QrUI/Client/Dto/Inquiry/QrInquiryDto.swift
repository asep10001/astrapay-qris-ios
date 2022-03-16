//
// Created by Gilbert on 04/11/21.
// Copyright (c) 2021 Astra Digital Arta. All rights reserved.
//

import Foundation

public enum PaymentMethod {
    case BALANCE
    case PAYLATER
    case POINT
}

public enum QrFeature {
    case MPM
    case CPM
}

public enum TipType {
    case ANY
    case FIXED
    case PERCENTAGE
    case NONE
}

struct QRInquiryRequest: Encodable {
    var qrText: String?
}


public struct QRInquiryResponse: Decodable {
    var id: Int?
    var transactionToken: String?
    var paymentMethods: [String]?
    var qrInquiryQrisDto: QRInquiryQrisDto?
    var adjustAmountAllowed: Bool?
    var qrFeature: String?
    var maximumAmount: Double?
    var createdAt: String?
}