//
// Created by Gilbert on 02/01/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation

protocol QRResultPaymentViewModelProtocol{
    func didTransactionStatusSuccess()
    func didTransactionStatusVoid()

    func buttonSetupForTransactionSuccess()
    func buttonSetupForTransactionFailed()
}

struct QRResultPaymentViewModelPayload{
    var qrGetDetailTransaksiByIdDtoViewData: QRGetDetailTransaksiByIdDtoViewData?
}

class QRResultPaymentViewModel{

    var delegate: QRResultPaymentViewModelProtocol?

    var qrResultPaymentViewModelPayload: QRResultPaymentViewModelPayload?

    func initVM(qrResultPaymentViewModelPayload: QRResultPaymentViewModelPayload?){
        guard let qrResultPaymentViewModelPayload = qrResultPaymentViewModelPayload else {
            return
        }
        self.qrResultPaymentViewModelPayload = qrResultPaymentViewModelPayload
    }


    func setupUILogic(){
        let statusTransaction = qrResultPaymentViewModelPayload?.qrGetDetailTransaksiByIdDtoViewData?.status
        if statusTransaction == "SUCCESS"{
            self.delegate?.didTransactionStatusSuccess()
        } else{
            self.delegate?.didTransactionStatusVoid()
        }
    }

    func setupButtonLogic(){
        let statusTransaction = qrResultPaymentViewModelPayload?.qrGetDetailTransaksiByIdDtoViewData?.status
        if statusTransaction == "SUCCESS"{
            self.delegate?.buttonSetupForTransactionSuccess()
        } else{
            self.delegate?.buttonSetupForTransactionFailed()
        }

        // ini buat nge test
//        self.delegate?.buttonSetupForTransactionFailed()

    }

}