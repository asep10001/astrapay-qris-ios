//
// Created by Gilbert on 05/11/21.
// Copyright (c) 2021 Astra Digital Arta. All rights reserved.
//

import Foundation
import UIKit

//MARK: BASE

protocol QRViewModelProtocol: class {
    func didRetrieveDataFromInquiryApi(resp: QRResponse<QRInquiryResponse>);
    func didRetrieveDataFromInquirApiAdjustAmountAllowedFalse(qrInquiryResponse: QRInquiryResponse)
    func didRetrieveQRFailed();

    func goToLoginPage()
}
class QRViewModel {
    
//    private var qrViewController = QRViewController()
    private let qrClient = QRClient()
    var userBalanceAstrapay: Int {
        return Int(Prefs.getUser()?.balance ?? 0)
    }
    var delegate: QRViewModelProtocol?



    //dto
    var qrInquiryResponse: QRInquiryResponse?
    func getInquiry(qrData: String){
        self.getQrInquiryFromClient(qrText: qrData)
    }
}




// seakan ini adalah repository, cuma dbnya adalah ke api (misalkan)
extension QRViewModel {
    func getQrInquiryFromClient(qrText: String){
        qrClient.getQrisInquiry(requestQrText: qrText, completion: {
            (result) in

            switch result.status {
            case true:
                if result.data?.transactionToken != nil {
                    self.qrInquiryResponse = result.data
                    if let result = result.data {
                        if self.qrInquiryResponse?.adjustAmountAllowed == false {
                            self.delegate?.didRetrieveDataFromInquirApiAdjustAmountAllowedFalse(qrInquiryResponse: result)
                            return
                        }
                    }
                    self.delegate?.didRetrieveDataFromInquiryApi(resp: result)
                    return
                }

            case false:

                if let responseCode = result.responseCode {
                    if responseCode == 401{
                        self.delegate?.goToLoginPage()
                        return
                    }
                }
                self.delegate?.didRetrieveQRFailed()

            }

        })
    }
}