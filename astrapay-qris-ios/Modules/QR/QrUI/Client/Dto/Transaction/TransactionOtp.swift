//
// Created by Gilbert on 03/12/21.
// Copyright (c) 2021 Astra Digital Arta. All rights reserved.
//

import Foundation

struct QRTransactionOtpRequest: Encodable {
    var tipAmount: String?
    var amount: String?
    var payments: [PaymentDto]?
    var otpValue: String?
}

struct QRTransactionOtpRequestForPathAndHeader: Encodable{
    var otpId: String?
    var transactionToken: String?
}

struct QRTransactionOtpResponse: Decodable {
    var id: Int?
    var transactionNumber: String?
    var paylaterWebUrl: String?
}
