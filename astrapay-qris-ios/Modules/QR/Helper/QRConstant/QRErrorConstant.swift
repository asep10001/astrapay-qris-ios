//
// Created by Gilbert on 3/4/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation
struct QRErrorConstant {

    /*
     Perbedaan antarar suffix "RESPONSE_ERROR_CODE" dengan ERROR_CODE
      adalah kalo RESPONSE_ERROR_CODE itu dari http error response code
       kalo ERROR_CODE itu dari mappingan si alamofire (error._code)
      */
    static let UNAUTHORIZED_RESPONSE_ERROR_CODE = 401
    static let BAD_REQUEST_RESPONSE_ERROR_CODE = 400


    static let TIMEOUT_ERROR_CODE = 13

}