//
// Created by Gilbert on 3/10/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation
struct QRTenorTrx: Decodable {
    var tenor: String?
    var valueTenor: String?
    var maxLimit: Int?
    var dueDate: String?
    var totalAmount : Int?
    var adminFee : Int?
    var totalLoan: Int?
    var loanPerMonth : Int?
}

struct QRTenorQrisTrxPLMCResp: Decodable {
    var content: [QRTenorTrx]?
}
