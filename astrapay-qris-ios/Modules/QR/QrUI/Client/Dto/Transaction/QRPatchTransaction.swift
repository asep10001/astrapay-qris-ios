//
// Created by Gilbert on 3/12/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation
struct PatchTrxQrisPLMC: Decodable {
    var id: Int?
    var transactionNumber: String?
    var status: String?
    var message: String?
}