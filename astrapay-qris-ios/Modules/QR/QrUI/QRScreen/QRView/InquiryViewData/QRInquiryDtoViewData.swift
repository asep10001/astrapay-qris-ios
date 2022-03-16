//
// Created by Gilbert on 2/26/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation


public struct QRInquiryDtoViewData: Decodable {
    init(){

    }
    init(qrInquiryResponse: QRInquiryResponse?){
        self.id = qrInquiryResponse?.id
        self.transactionToken = qrInquiryResponse?.transactionToken
        self.paymentMethods = qrInquiryResponse?.paymentMethods
        self.adjustAmountAllowed = qrInquiryResponse?.adjustAmountAllowed
        self.qrFeature = qrInquiryResponse?.qrFeature
        self.maximumAmount = qrInquiryResponse?.maximumAmount
        self.createdAt = qrInquiryResponse?.createdAt

        var qrInquiryQrisDtoViewData = QRInquiryQrisDtoViewData()
        var merchantDtoViewData = MerchantDtoViewData()
        var tipDtoViewData = TipDtoViewData()
        var customerDtoViewData = CustomerDtoViewData()

        //setup merchant
        merchantDtoViewData.merchantCity = qrInquiryResponse?.qrInquiryQrisDto?.merchant?.merchantCity
        merchantDtoViewData.categoryCode = qrInquiryResponse?.qrInquiryQrisDto?.merchant?.categoryCode
        merchantDtoViewData.merchantName = qrInquiryResponse?.qrInquiryQrisDto?.merchant?.merchantName

        //setup tip
        tipDtoViewData.type = qrInquiryResponse?.qrInquiryQrisDto?.tip?.type
        tipDtoViewData.amount = qrInquiryResponse?.qrInquiryQrisDto?.tip?.amount
        tipDtoViewData.percentage = qrInquiryResponse?.qrInquiryQrisDto?.tip?.percentage


        //setup customer
        customerDtoViewData.name = qrInquiryResponse?.qrInquiryQrisDto?.customer?.name

        //setup qrInquiryQrisDtoViewData
        qrInquiryQrisDtoViewData.transactionAmount = qrInquiryResponse?.qrInquiryQrisDto?.transactionAmount
        qrInquiryQrisDtoViewData.merchant = merchantDtoViewData
        qrInquiryQrisDtoViewData.customer = customerDtoViewData
        qrInquiryQrisDtoViewData.tip = tipDtoViewData



        self.qrInquiryQrisDto = qrInquiryQrisDtoViewData


    }

    var id: Int?
    var transactionToken: String?
    var paymentMethods: [String]?
    var qrInquiryQrisDto: QRInquiryQrisDtoViewData?
    var adjustAmountAllowed: Bool?
    var qrFeature: String?
    var maximumAmount: Double?
    var createdAt: String?
}