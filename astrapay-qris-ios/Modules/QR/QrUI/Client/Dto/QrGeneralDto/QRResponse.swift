//
// Created by Gilbert on 04/11/21.
// Copyright (c) 2021 Astra Digital Arta. All rights reserved.
//

import Foundation


public struct QRResponse<T> {
    var status: Bool
    var errorCode: String?
    var message: String
    var data: T?
    var errorData: AstrapayErrorResponse?
    var isTimeOut: Bool?
    var responseCode: Int?
}