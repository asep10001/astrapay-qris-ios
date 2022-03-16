//
//  PLMaucashQrisWebViewVM.swift
//  astrapay
//
//  Created by user on 04/01/22.
//  Copyright © 2022 Astra Digital Arta. All rights reserved.
//

import Foundation

struct QRPLMaucasQrisWebViewPayload{
    var id: Int = 0
}

enum QRPLMaucashQrisWebViewVMType {
    case file(url: String)
    case web(url: String)
    case contentHTML(url: String)
    
    func loadResourceFile(_ url: String) -> URL {
        let path = Bundle.main.url(forResource: url, withExtension: "html")!
        return path
    }
    
    func loadResourceWeb(_ url: String) -> URLRequest {
        let myURL = URL(string: url)!
        return URLRequest(url: myURL)
    }
}

protocol QRPLMaucashQrisWebViewProtocol {
    var resourceType: QRPLMaucashQrisWebViewVMType! { get set }
}

protocol QRPLMaucashQrisWebViewVMProtocol {
    func didSuccesPatchQris()
    func didFailurePatchQris()
    func didErrorPatchQris()


    //
    func didSuccessGetDetailTransaksiById(qrGetDetailTransaksiByIdResponse: QRGetDetailTransaksiByIdResponse)
}

class QRPLMaucashQrisWebViewVM {
    let service = QRClient()
    var productName : String = ""
    var productNameDetail: String = ""
    var isFromBiller : String = ""
    var orderNo : String = ""
    var mobile : String = ""
    var qrisPayment : QRISPaymentPLMCReq?
    var qrisPaymentResp : QRISPaymentResp?
    var inputAmount : String?
    var delegate: QRPLMaucashQrisWebViewVMProtocol?
    var status: String = ""
    var transactionNumber: String = ""
    var idTrx: Int {
        return self.qrPlMaucaseQrisWebViewPayload.id
    }
    
    static var url : String = ""
    var resourceType: QRPLMaucashQrisWebViewVMType? = .web(url: url)
    
    func setupUserData(){
        let me = Prefs.getUser()!
        self.mobile = me.profile?.phoneNumber ?? ""
    }


    var qrPlMaucaseQrisWebViewPayload: QRPLMaucasQrisWebViewPayload = QRPLMaucasQrisWebViewPayload()

    //init
    public convenience init(payload: QRPLMaucasQrisWebViewPayload){
        self.init()
        self.qrPlMaucaseQrisWebViewPayload = payload
    }


    func patchQrisTransactionsPLMC(id:Int) {
        self.service.patchQrisTrxPLMC(id: id, completion : {
            (result) in
            switch result.status {
            case true:
                self.status = result.data?.status ?? "-"
                self.transactionNumber = result.data?.transactionNumber ?? "-"
                self.delegate?.didSuccesPatchQris()
                break

            case false:
                if let isTimeout = result.isTimeOut {
                    if isTimeout {
                        self.delegate?.didErrorPatchQris()
                        break
                    }
                    self.delegate?.didFailurePatchQris()
                }
            }
        })
    }

}

extension QRPLMaucashQrisWebViewVM{
    func getDetailTransaksi(idTransaksi: String){
        self.getDetailTransaksiClient(idTransaksi: idTransaksi)
    }


    func getDetailTransaksiClient(idTransaksi: String){
        var transaksiId = idTransaksi
        self.service.getDetailTransaksiById(requestIdTransaksi: idTransaksi){ (result) in
            switch result.status {
            case true:
                guard let data = result.data else{
                    fatalError("QR Get Detail Transaksi Response is nil")
                }

                self.delegate?.didSuccessGetDetailTransaksiById(qrGetDetailTransaksiByIdResponse: data)
            case false:
                fatalError("Get Detail Transaksi By Id is failed")

            }
        }
    }
}
