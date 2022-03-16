//
//  TransactionPin.swift
//  astrapay
//
//  Created by Gilbert on 30/11/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import Foundation


//MARK: Request
struct QRTransactionPinRequest: Codable{
    var tipAmount: String?
    var amount: String?
    var payments: [PaymentDto]?
    var pin: String?
}


//MARK: Response
struct QRTransactionPinResponse: Decodable{
    var id: Int?
    var transactionNumber: String?
//    var tokentTransactionDto: TokenTransactionDto?
    var status: String?
    var transactionPinToken: TokenTransactionDto?
    var otp: OtpDto?
    var needOtp: Bool?
    var paylaterWebUrl: String?
}


//MARK: Dalemannya request
struct PaymentDto: Codable{
    var method: String?
    var amount: Int?
    var partner: String?
    var tenor: String?
}

//MARK: Dalemannya response
struct TokenTransactionDto: Decodable{
    var tokenId: Int?
    var expiry: String?
    var type: String?
    var token: String?
}

struct OtpDto: Decodable{
    var phoneNumber: String?
    var otpId: Int?
//    var expiry: String?
}
