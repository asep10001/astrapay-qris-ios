//
// Created by Gilbert on 3/11/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation
//MARK: Request
struct QRTransactionRequest: Codable{
    var tipAmount: String?
    var amount: String?
    var payments: [PaymentDto]?
}