//
// Created by Gilbert on 17/11/21.
// Copyright (c) 2021 Astra Digital Arta. All rights reserved.
//

import Foundation


import Foundation

struct QRAPTransactionDetailsModel {
    var detailTrasaksi: [QRDetailTrasaksi]
    var titleTotal: String
    var valueTotal: String
    var valueBalance: String
    var resultTotal: String
}

struct QRDetailTrasaksi {
    var titles: String
    var values: String
}