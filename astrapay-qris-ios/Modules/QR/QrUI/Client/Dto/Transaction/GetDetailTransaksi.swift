//
// Created by Gilbert on 29/12/21.
// Copyright (c) 2021 Astra Digital Arta. All rights reserved.
//

import Foundation
//QRGetDetailTransaksiByIdResponse
// MARK: - Welcome

struct QRGetDetailTransaksiByIdResponseDto: Codable {
        let content: [QRGetDetailTransaksiByIdResponse]?
        let number, size, totalElements: Int?
        let pageable: Pageable?
        let last: Bool?
        let totalPages: Int?
        let sort: Sort?
        let first: Bool?
        let numberOfElements: Int?
        let empty: Bool?
}

struct QRGetDetailTransaksiByIdResponse: Codable {
        var id: Int?
        var refMerchantCategoryCode, transactionNumber: String?
        var basicPrice, serviceCharge: Double?
        var includedServiceCharge: Double?
        var convenienceFee, tax, includedTaxPrice, farePrice: Double?
        var margin, tip, tipPercentage: Double?
        var tipType: String?
        var totalPrice: Double?
        var status, qrIssuer, merchantName, merchantCity: String?
        var merchantPostalCode, merchantCountryCode, additionalDataValue, terminalLabel: String?
        var merchantQrID: Int?
        var referenceNumberSwitcher: String?
        var transactionAt, currencyCode: String?
        var reconcileCode: String?
        var authorizationID, acquirerNns, issuerNns: String?
        var refMerchantPan: String?
        var refNationalMerchantID: String?
        var refMerchantID, refMerchantCriteria: String?
        var refCustomerPan, refCustomerName, refCustomerAccountType, mdrType: String?
        var switcher, correlationID: String?
        var refundStatus, postedAt, refTransactionAt: String?
        var transactionHasAcquirer: [TransactionHasAcquirer]?
        var transactionIssuer: TransactionIssuer?
        var maximumAmount: Double?
        var createdAt, updatedAt: String?

}

// MARK: - TransactionHasAcquirer
struct TransactionHasAcquirer: Codable {
        var id: Int?
        var globalUniqueIdentifier, merchantPan, merchantID, merchantCriteria: String?
        var createdAt, updatedAt: String?

}

// MARK: - TransactionIssuer
struct TransactionIssuer: Codable {
        var id: Int?
        var phoneNumber: String?
        var userID: Int?
        var userTokenLinked, transactionToken, paymentMethod: String?
        var transactionPayments: [TransactionPayment]?
        var qrType, qrFeature, createdAt, updatedAt: String?

}

// MARK: - TransactionPayment
struct TransactionPayment: Codable {
        var id: Int?
        var paymentMethod: String?
        var amount: Int?
        var posted: Bool?
        var postedAt, createdAt, updatedAt: String?
}