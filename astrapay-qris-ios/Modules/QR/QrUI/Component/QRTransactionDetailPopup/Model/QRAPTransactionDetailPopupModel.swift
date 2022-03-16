//
//  QRAPTransactionDetailPopupModel.swift
//  astrapay
//
//  Created by Nur Irfan Pangestu on 11/04/20.
//  Copyright © 2020 Tirta Rivaldi. All rights reserved.
//

import Foundation


struct QRAPTransactionDetailPopupModel {
    var nameImages: String
    var titles: String
    var contents: String
    var stateTrasactions: String
    var detailTrasaksi: [QRDetailTransaksi]
    var valueTotal: String
    var valueBalance: String
    var resultTotal: String
}

struct QRDetailTransaksi {
    var titles: String
    var values: String
}


