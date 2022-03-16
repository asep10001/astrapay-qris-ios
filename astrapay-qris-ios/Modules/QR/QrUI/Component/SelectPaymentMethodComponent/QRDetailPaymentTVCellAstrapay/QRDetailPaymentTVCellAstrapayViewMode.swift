//
// Created by Gilbert on 04/01/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation

protocol QRDetailPaymentTVCellAstrapayViewModelProtocol{
    func didUserBalanceIsNotEnoughCompareToAmount()
    func didUserBalanceIsEnoughCompareToAmount()

}

class QRDetailPaymentTVCellAstrapayViewModel{

    var content = QRSelectPaymentViewPayload()
    var userBalance = 0

    var delegate: QRDetailPaymentTVCellAstrapayViewModelProtocol?

    func initVM(content: QRSelectPaymentViewPayload, userBalance: Int){
        self.content = content
        self.userBalance = userBalance

        setupViewLogic()
    }


}

//MARK: Setup view logic
extension QRDetailPaymentTVCellAstrapayViewModel{

    /*Logicnya ada 3 yaitu
     1. jika user balance cukup
      2. jika user balance ga cukup
       3. jika loading terlalu lama*/
    func setupViewLogic(){

        guard let basicPrice = content.basicPrice else {
            return
        }
        guard let amountTransaction = content.amountTransaction else {
            return
        }
        if userBalance < basicPrice || userBalance < amountTransaction {
            self.delegate?.didUserBalanceIsNotEnoughCompareToAmount()
            return
        }
        self.delegate?.didUserBalanceIsEnoughCompareToAmount()
        return
    }
}