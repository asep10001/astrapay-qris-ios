//
// Created by Gilbert on 2/24/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation
struct AstrapayErrorResponse: Codable {
    let status: Int
    let message, error, path, timestamp: String
    let details: [Detail]
}

// MARK: - Detail
struct Detail: Codable {
    let code, objectName, defaultMessage, field: String
    let rejectedValue: String
    let additionalData: [QRAdditionalData]
}

// MARK: - AdditionalData
struct QRAdditionalData: Codable {
    let key: String
    let value: String?
}