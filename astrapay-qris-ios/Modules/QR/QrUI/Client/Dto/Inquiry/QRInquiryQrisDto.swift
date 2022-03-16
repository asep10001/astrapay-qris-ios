//
// Created by Gilbert on 04/11/21.
// Copyright (c) 2021 Astra Digital Arta. All rights reserved.
//

import Foundation

//public class QrInquiryQrisDto {
//    private CustomerDto customer;
//    private MerchantDto merchant;

//    private TipDto tip;
//    private BigDecimal transactionAmount;
//}

struct QRInquiryQrisDtoViewData: Decodable {
    var customer: CustomerDtoViewData?
    var merchant: MerchantDtoViewData?

    var tip: TipDtoViewData?
    var transactionAmount: Double?
}

struct MerchantDtoViewData: Decodable {
    var categoryCode: String?
    var merchantName: String?
    var merchantCity: String?
}

struct TipDtoViewData: Decodable {
    var type: String?
    var amount: Double?
    var percentage: Double?
}

struct CustomerDtoViewData: Decodable {
    var name: String?
}
