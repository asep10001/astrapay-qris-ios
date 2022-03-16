//
// Created by Gilbert on 19/02/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation


struct QRTransactionDetailViewModel{
    var qrGetDetailTransaksiByIdDtoViewData: QRGetDetailTransaksiByIdDtoViewData?

    var nominalTransaction: String {
        if var qrGetDetailTransaksiResponse = self.qrGetDetailTransaksiByIdDtoViewData {
            return self.valueIDR(value: String(qrGetDetailTransaksiResponse.basicPrice ?? 0))
        } else {
            return "0"
        }
    }

    var valueTotal: String {
        if var qrGetDetailTransaksiResponse = self.qrGetDetailTransaksiByIdDtoViewData {
            return self.valueIDR(value: String(qrGetDetailTransaksiResponse.totalPrice ?? 0))
        } else {
            return "0"
        }
    }

    var valueBalance: String{
        if var qrGetDetailTransaksiResponse = self.qrGetDetailTransaksiByIdDtoViewData {
            return self.valueIDR(value: String(qrGetDetailTransaksiResponse.totalPrice ?? 0))
        } else {
            return "0"
        }
    }

    var resultTotal: String {
        if var qrGetDetailTransaksiResponse = self.qrGetDetailTransaksiByIdDtoViewData {
            return self.valueIDR(value: String(qrGetDetailTransaksiResponse.totalPrice ?? 0))
        } else {
            return "0"
        }
    }



    var statusTransaction: String {
        var status = self.qrGetDetailTransaksiByIdDtoViewData?.status

        switch status{
        case "SUCCESS" :
            return "Berhasil"
        case "VOID":
            return "GAGAL"
        case "PENDING":
            return "Dalam Proses"
        default :
            return "Dalam Proses"
        }
    }


    private func valueIDR(value: String?) -> String {
        var currentValue: String = value ?? "0"
        if value == nil {
            currentValue = "0"
        }
        if currentValue.contains(".,") {
            if !(currentValue.isEmpty) {
                return QRAPFormatter.currency(number: Int(currentValue) ?? 0)
            } else {
                return "Rp -"
            }
        } else {
            if !(currentValue.isEmpty) {
                let feeTotal = Double(currentValue) ?? 0.0
                let feeResult = Int(feeTotal)
                return QRAPFormatter.currency(number: feeResult)
            } else {
                return "Rp -"
            }
        }
        return "-"
    }

}