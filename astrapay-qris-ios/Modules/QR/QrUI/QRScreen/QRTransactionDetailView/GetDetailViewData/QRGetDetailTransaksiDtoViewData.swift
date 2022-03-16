//
// Created by Gilbert on 2/26/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation


struct QRGetDetailTransaksiByIdDtoViewData{
    var transactionNumber: String?
    var basicPrice: Double?
    var totalPrice: Double?
    var status, merchantName, merchantCity: String?
    var terminalLabel: String?
    var reconcileCode: String?
    var refCustomerPan: String?
    var merchantQrID : Int?

    var createdAt: String?

    //from transaction has acquirer
    var merchantPanFromTransactionHasAcquirer: String?

    //from transaction issuer
    var phoneNumberFromTransactionIssuer: String?

    init(status: String?){
        self.status = status

    }



    init(qrGetDetailTransaksiResponse: QRGetDetailTransaksiByIdResponse?){
        self.basicPrice = qrGetDetailTransaksiResponse?.basicPrice
        self.totalPrice = qrGetDetailTransaksiResponse?.totalPrice
        self.status = qrGetDetailTransaksiResponse?.status
        self.createdAt = qrGetDetailTransaksiResponse?.createdAt
        self.merchantName = qrGetDetailTransaksiResponse?.merchantName
        self.transactionNumber = qrGetDetailTransaksiResponse?.transactionNumber
        self.refCustomerPan = qrGetDetailTransaksiResponse?.refCustomerPan
        self.reconcileCode = qrGetDetailTransaksiResponse?.reconcileCode


        if let transactionHasAcquirer = qrGetDetailTransaksiResponse?.transactionHasAcquirer{
            self.merchantPanFromTransactionHasAcquirer = transactionHasAcquirer[0].merchantPan
        }
        self.merchantCity = qrGetDetailTransaksiResponse?.merchantCity
        self.terminalLabel = qrGetDetailTransaksiResponse?.terminalLabel
        self.phoneNumberFromTransactionIssuer = qrGetDetailTransaksiResponse?.transactionIssuer?.phoneNumber
        self.merchantQrID = qrGetDetailTransaksiResponse?.merchantQrID
    }
}
