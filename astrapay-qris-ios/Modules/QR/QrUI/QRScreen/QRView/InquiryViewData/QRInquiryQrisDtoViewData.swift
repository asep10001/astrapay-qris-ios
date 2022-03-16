//
// Created by Gilbert on 2/26/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation
struct QRInquiryQrisDto: Decodable {
    var customer: CustomerDto?
    var merchant: MerchantDto?

    var tip: TipDto?
    var transactionAmount: Double?
}

struct MerchantDto: Decodable {
    var categoryCode: String?
    var merchantName: String?
    var merchantCity: String?
}

struct TipDto: Decodable {
    var type: String?
    var amount: Double?
    var percentage: Double?
}




struct CustomerDto: Decodable {
    var name: String?
}