//
//  Result.swift
//  PJIOnlineTransport
//
//  Created by Tirta Rivaldi on 8/20/18.
//  Copyright © 2018 Tirta Rivaldi. All rights reserved.
//

import Foundation

//
//public enum QRResult<Value> {
//    case success(Value)
//    case error(Error)
//    case failure([ErrorResponse])
//}

public enum QRResultStatusResp<Value> {
    case success(Value)
    case failure(String)
    case serverBussy
}

public enum QRResultResponse<Value> {
    case message(String)
    case status(Int)
    case error(Error)
    case data(Value)
}

//struct CauseError : Error {
//
//}
