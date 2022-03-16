//
// Created by Gilbert on 3/10/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation
import UIKit

class QRPaylaterRouter{

    let vc : UIViewController?

    init(viewController : UIViewController) {
        self.vc = viewController
    }


    var isAbleToNavigate = true


    func navigateToWebViewQrisTrx(urlLink:String, idTransaksi:Int){

        var qrPLMaucashQrisWebViewPayload = QRPLMaucasQrisWebViewPayload(id: idTransaksi)
    let vc = QRPLMaucashQrisWebViewVC(payload: qrPLMaucashQrisWebViewPayload)
        vc.viewModel.resourceType = .web(url: urlLink)
        self.vc?.navigationController?.pushViewController(vc, animated:true)
    }

    func navigateToTenorLoanPage(model: QRPaylaterTransactionPayload){
        if isAbleToNavigate && model != nil{
            self.isAbleToNavigate = false
            let vcInputAmount = QRPLMaucashQrisLoanTrxVC(qrPaylaterTransactionPayload: model)
            self.vc?.navigationController?.pushViewController(vcInputAmount, animated:true)
            self.isAbleToNavigate = true
        }
    }
}