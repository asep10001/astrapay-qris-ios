//
// Created by Gilbert on 05/11/21.
// Copyright (c) 2021 Astra Digital Arta. All rights reserved.
//

import Foundation
import UIKit

class QRNewRouter {

    let vc : UIViewController?

    init(viewController : UIViewController) {
        self.vc = viewController
    }


    var isAbleToNavigate = true
    
    //MARK: navigasi ke input amount setelah kita scan qr


    func navigateToHistoryPage(){
        DispatchQueue.main.async {
            guard let vcHist = UIStoryboard(name:MainTransactionHistoryVC.storyboardName, bundle:nil).instantiateViewController(withIdentifier: MainTransactionHistoryVC.identifierVC) as? MainTransactionHistoryVC else {
                print(HomeRouter.defaultIdentifierStoryboardMessage("TransactionView"))
                return
            }

            self.vc?.navigationController?.pushViewController(vcHist, animated: true)
        }
    }

    func navigateToInputAmountAfterScan(model : QRInquiryDtoViewData?){
        if isAbleToNavigate && model != nil{
            self.isAbleToNavigate = false
            let vcInputAmount = QRInputAmountViewController()
            vcInputAmount.initQRPayload(payload: model!)
            self.vc?.navigationController?.pushViewController(vcInputAmount, animated:true)
            self.isAbleToNavigate = true
        }
    }

    func navigateToTransactionDetailAdjustAmountAllowedFalse(qrInquiryDtoViewData: QRInquiryDtoViewData, userBalanceAstrapay: Int){
        DispatchQueue.main.async {
            guard let qrTransactionVC = UIStoryboard(name:QRConstant.qrStoryBoardName, bundle:nil).instantiateViewController(withIdentifier: QRNewTransactionFlowViewController.identifier) as? QRNewTransactionFlowViewController else {
                return
            }
            qrTransactionVC.initVM(qrInquiryDtoViewData: qrInquiryDtoViewData, amountTransaction: Int(qrInquiryDtoViewData.qrInquiryQrisDto?.transactionAmount ?? 0))

            self.vc?.navigationController?.pushViewController(qrTransactionVC, animated:true)
        }
    }

    
    //MARK: Navigasi ke transaction detail
    func navigateToTransactionDetailAfterInputAmount(qrInquiryDtoViewData: QRInquiryDtoViewData, amountTransaction: Int){
        DispatchQueue.main.async {
            guard let qrTransactionVC = UIStoryboard(name:QRConstant.qrStoryBoardName, bundle:nil).instantiateViewController(withIdentifier: QRNewTransactionFlowViewController.identifier) as? QRNewTransactionFlowViewController else {
                return
            }
            qrTransactionVC.initVM(qrInquiryDtoViewData: qrInquiryDtoViewData, amountTransaction: amountTransaction)

            self.vc?.navigationController?.pushViewController(qrTransactionVC, animated:true)
        }
    }
    
    
    //MARK: navigasi ke result payment setelah kita click bayar dan memasukkan pin
    func navigateToResulPaymentAfterClickBayarAndInputPin(qrGetDetailTransaksiByIdDtoViewData: QRGetDetailTransaksiByIdDtoViewData){
      
        if isAbleToNavigate && qrGetDetailTransaksiByIdDtoViewData != nil{
            self.isAbleToNavigate = false
            let qrResultPaymentViewController = QRResultPaymentViewController()
            var qrPayloadViewProperty = QRResultPaymentViewController.QRPayloadViewProperty(qrGetDetailTransaksiByIdDtoViewData: qrGetDetailTransaksiByIdDtoViewData)
            qrResultPaymentViewController.initQRPayload(payload: qrPayloadViewProperty)
            
            self.vc?.navigationController?.pushViewController(qrResultPaymentViewController, animated: true)
            self.isAbleToNavigate = true
        }
    }

    func navigateToGetDetailTransaksi(qrGetDetailTransaksiByIdDtoViewData: QRGetDetailTransaksiByIdDtoViewData) {
        if isAbleToNavigate && qrGetDetailTransaksiByIdDtoViewData != nil{
            self.isAbleToNavigate = false
            let qrDetailTransactionViewController = QRTransactionDetailViewController()
            var qrPayloadViewProperty = QRTransactionDetailViewController.QRPayloadViewProperty(qrGetDetailTransaksiByIdDtoViewData: qrGetDetailTransaksiByIdDtoViewData)
            qrDetailTransactionViewController.initQRPayload(payload: qrPayloadViewProperty)

            self.vc?.navigationController?.pushViewController(qrDetailTransactionViewController, animated: true)
            self.isAbleToNavigate = true
        }
    }

    func navigateToTransactionIsProcess(qrTransactionIsProcessPayload: QRTransactionIsProcessPayload){
        if isAbleToNavigate && qrTransactionIsProcessPayload != nil{
            self.isAbleToNavigate = false
            let qrTransactionIsProcessViewController = QRTransactionIsProcessViewController(qrTransactionIsProcessPayload: qrTransactionIsProcessPayload)

            self.vc?.navigationController?.pushViewController(qrTransactionIsProcessViewController, animated: true)
            self.isAbleToNavigate = true
        }
    }
}
