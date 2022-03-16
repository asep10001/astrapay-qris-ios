//
// Created by Gilbert on 2/25/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation

struct QRResendOtpDto: Codable {
    let phoneNumber: String
    let otpId: Int
    let expiry: String
}