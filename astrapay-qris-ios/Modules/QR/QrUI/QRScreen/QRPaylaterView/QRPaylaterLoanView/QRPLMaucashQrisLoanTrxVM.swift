//
//  QRPLMaucashQrisLoanTrxVM.swift
//  astrapay
//
//  Created by user on 22/12/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import Foundation


// ini sepertinya buat di get qris tenor
struct QRPLMaucashQrisLoanTrxPayload: Encodable {
    var mobile : String
    var amount : String
    var itemType : String
    var itemName : String
    var productName : String
    var productNameDetail: String
}

struct QRPaylaterTransactionPayload{
    var amounTransaction: Int = 0
    var tipTransaction: Int = 0
    var totalAmountTransaction: Int = 0
    var qrInquiryDtoViewData: QRInquiryDtoViewData = QRInquiryDtoViewData()
}

protocol QRPLMaucashQrisLoanTrxVMProtocol {

    //Get tenor qris
    func didSuccesTenorTrxQris()
    func didFailureTenorTrxQris()
    func didErrorTenorTrxQris()
    func didFailureTenorTrxQrisErr422()

    func didSuccesQrisTransactionsPLMC()
    func didFailureQrisTransactionsPLMC(err: String)
    func didErrorQrisTransactionsPLMC()



    //Error Pin
    func didFailedPostToTransactionPinBecauseBadRequest()
    func didFailedPostToTransactionPinBecausePinIsWrong(retryPin: String)
    func didFailedPostToTransactionPinBecauseTemporaryLock()
    func didFailedPostToTransactionPinBecausePermanentLock()
    func didFailedPostToTransactionPinBecauseOtpRequestLimitExceeded()


    //Error Otp
    func didFailedPostToTransactionOtpBecauseBadRequest()
    func didFailedTransactionByOtpBecauseOtpNotMatch()
    func didFailedPostToTransactionOtpBecauseSubmitLock()
    func didFailedPostToTransactionOtpBecauseOtpExpired()


    //Error Resend Otp
    func didFailedResendOtpBecauseOtpRequestLimitExceeded()

    //Timeout Pin
    func didTransactionPinGetTimeOut()


    //Timout Otp
    func didTransactionOtpGetTimeOut()



    //Success transaksi pin
    func didSuccessPostToTransactionPin(qrTransactionPinResponse: QRTransactionPinResponse)


    //Flow transaksi Otp
    func didNeedOtp()
    func didSuccessPostToTransctionOtp(idTransaksi: String)



    //Get detail transaksi
    func didSuccessGetDetailTransaksiById(qrGetDetailTransaksiByIdResponse: QRGetDetailTransaksiByIdResponse)
    func didSuccessGetDetailTransaksiByToken(qrGetDetailTransaksiByIdResponse: QRGetDetailTransaksiByIdResponse)
    func didFailedGetDetailTransaksiByToken();
    func didGetDetailTransaksiByTokenGetTimeOut();


    // go to login page
    func didGoToLoginPageFromTransactionProcess()

}

class QRPLMaucashQrisLoanTrxVM {


    let qrClient = QRClient()
    let qrPaylaterClient = QRPaylaterClient()
    var delegate: QRPLMaucashQrisLoanTrxVMProtocol?
    var qrisTenorTrxPLMC : [QRTenorTrx]? = []
    var qrPlmcQrisLoanTrxPayload: QRPLMaucashQrisLoanTrxPayload?
    var qrInquiryDtoViewData: QRInquiryDtoViewData{
        return self.qrPaylaterTransactionPayload.qrInquiryDtoViewData
    }

    var productName : String = ""
    var productNameDetail: String = ""

    var merchantCode : String = "astraPay"
    var goodsCode : String = "00"
    var mobile : String = ""
    var amount : String = "16000"
    var transType : String = "QRIS"
    var itemType : String = ""
    var itemName : String = ""

    var jatuhTempo: String = ""
    var jumlahPinjaman: Int = 0
    var biayaLayanan: Int = 0
    var cicilan: Int = 0
    var tenor : String = ""
    var tenorLbl : String = ""
    var total : Int = 0
    var otpId: String = "0"

    var respUrlTrx : String = ""

    var qrPaylaterTransactionPayload: QRPaylaterTransactionPayload = QRPaylaterTransactionPayload()

    var tipAmount: Int {
        return self.qrPaylaterTransactionPayload.tipTransaction
    }

    var amountTransaction: Int {
        return self.qrPaylaterTransactionPayload.amounTransaction
    }

    var totalAmountTransaction: Int {
        return self.qrPaylaterTransactionPayload.totalAmountTransaction
    }

    public convenience init (qrPaylaterTransactionPayload: QRPaylaterTransactionPayload){
        self.init()
        self.qrPaylaterTransactionPayload = qrPaylaterTransactionPayload
    }

    func setupUserData(){
        let me = Prefs.getUser()!
        self.mobile = me.profile?.phoneNumber ?? ""
        self.amount = qrPlmcQrisLoanTrxPayload?.amount ?? "0"
        self.itemType = qrPlmcQrisLoanTrxPayload?.itemType ?? ""
        self.itemName = qrPlmcQrisLoanTrxPayload?.itemName ?? ""
        self.productName = qrPlmcQrisLoanTrxPayload?.productName ?? ""
        self.productNameDetail = qrPlmcQrisLoanTrxPayload?.productNameDetail ?? ""
    }


    func setTrxQrisPLMCReq(pin:String) -> QRTransactionPinRequest {
        let req : QRTransactionPinRequest = QRTransactionPinRequest(tipAmount:String(self.tipAmount) , amount: String(self.amountTransaction), payments: self.setPaymentTrxQrisPLMC(), pin: pin)
        return req
    }


    func setQrisTenorLoanTrxPLMCPayload() -> QRPLMCQrisTenorLoanTrxTVCellPayload {
        let TenorLoanPayload : QRPLMCQrisTenorLoanTrxTVCellPayload = QRPLMCQrisTenorLoanTrxTVCellPayload(tenorLoanTrx: qrisTenorTrxPLMC ?? [],istenorLoanTrx: true)
        return TenorLoanPayload
    }

    func setQrisDetailLoanTrxPLMCPayload() -> QRPLMCDetailLoanTrxViewPayload {
        let loanDetailPayload : QRPLMCDetailLoanTrxViewPayload = QRPLMCDetailLoanTrxViewPayload(
                typeQR : true,
                tenor: self.tenorLbl,
                jatuhTempo: self.jatuhTempo,
                jumlahPinjaman: self.jumlahPinjaman,
                biayaLayanan: self.biayaLayanan,
                cicilan: self.cicilan)
        return loanDetailPayload
    }

    func setPaymentTrxQrisPLMC() -> [PaymentDto] {
        var arrayPaymentDto: [PaymentDto] = []

        let paymentTrxPaylater : PaymentDto = PaymentDto(method: "PAYLATER", amount: self.amountTransaction, partner: "MAUCASH", tenor: self.tenor)

        arrayPaymentDto.append(paymentTrxPaylater)
        if self.tipAmount > 0 {
            let paymentTrxAstrapay : PaymentDto = PaymentDto(method: "BALANCE", amount: self.tipAmount)
            arrayPaymentDto.append(paymentTrxAstrapay)

        }
        return arrayPaymentDto
    }

    func getQrisTenorTrxPLMC(){
        qrPaylaterClient.getQrisTenorTrxPLMC(merchantCode: self.merchantCode, goodsCode: self.goodsCode, mobile: self.mobile, amount: String(self.amountTransaction), transType: self.transType, completion: {
            result in
            switch result.status {
            case true:
                self.qrisTenorTrxPLMC = result.data?.content ?? []
                self.delegate?.didSuccesTenorTrxQris()
                break
            case false:
                if let isTimeout = result.isTimeOut {
                    if isTimeout {
                        self.delegate?.didErrorTenorTrxQris()
                        break
                    }
                }
                if result.responseCode == 422 {
                    self.delegate?.didFailureTenorTrxQrisErr422()
                    return
                }
                self.delegate?.didFailureTenorTrxQris()
            }
        })
    }


    //transaksi pin
    func postQrisTransactionsPIN(req: QRTransactionPinRequest, qrInquiryDtoViewData: QRInquiryDtoViewData) {
        self.qrClient.postToTransactionPin(request: req, qrInquiryDtoViewData: qrInquiryDtoViewData, completion: {
            (result) in
            //MARK: dari result ini kan dia ngebalikin isNeedOtp, jika dia membutuhkan otp maka harus ada delegate untuk memunculkan otp
            switch result.status {
            case true:
                //MARK: jika response transaction pin is null, perlu dibikin logic negatif seperti apa?
                guard let qrTransactionPinResponse = result.data else {

                    //MARK: Harus dibikin logic atau alert jika nil
                    print("qrTransactionPinResponse is nil")
                    return
                }
                if qrTransactionPinResponse.needOtp == true {
                    self.otpId = String(qrTransactionPinResponse.otp?.otpId ?? 0)
                    self.delegate?.didNeedOtp()
                    return
                } else {
                    self.respUrlTrx = qrTransactionPinResponse.paylaterWebUrl ?? "-"
                    self.delegate?.didSuccessPostToTransactionPin(qrTransactionPinResponse: qrTransactionPinResponse)
                    return
                }
            case false:
                if let isTimeout = result.isTimeOut {
                    if isTimeout {
                        self.delegate?.didTransactionPinGetTimeOut()
                        return
                    }
                }

                guard let astrapayError = result.errorData else {
                    print("Error is nil")
                    return
                }

                var retryInPin = "0"

                for detail in astrapayError.details {
                    if detail.code == "PIN-NOT-MATCH"{
                        for additionalData in detail.additionalData {
                            if additionalData.key == "retryCount"{
                                retryInPin = additionalData.value ?? "0"
                                self.delegate?.didFailedPostToTransactionPinBecausePinIsWrong(retryPin: retryInPin)
                                return
                            }
                        }
                    }

                    if detail.code == "PIN-SUBMIT-TEMPORARY-LOCK"{
                        self.delegate?.didFailedPostToTransactionPinBecauseTemporaryLock()
                        return
                    }

                    if detail.code == "PIN-SUBMIT-PERMANENT-LOCK"{
                        self.delegate?.didFailedPostToTransactionPinBecausePermanentLock()
                        return
                    }

                    if detail.code == "OTP-REQUEST-LOCK" {
                        self.delegate?.didFailedPostToTransactionPinBecauseOtpRequestLimitExceeded()
                        return
                    }
                }


                if let responseCode = result.responseCode {
                    if responseCode == 401 {
                        self.delegate?.didGoToLoginPageFromTransactionProcess()
                        return
                    }
                    if responseCode >= 400{
                        self.delegate?.didFailedPostToTransactionPinBecauseBadRequest()
                        return
                    }
                }
                print(result.message + " ini adalah errornya")
                //MARK: Harus dibikin logic atau alert jika post ke transaction pin jika dia membalikkan error
                print("Post to transaction pin got error")
            }
        })
    }

}

//MARK: transaksi otp
extension QRPLMaucashQrisLoanTrxVM{
    func postToTransactionOtp(qrTransactionOtpRequest: QRTransactionOtpRequest, qrTransactionOtpRequestForPathAndHeader: QRTransactionOtpRequestForPathAndHeader) {
        self.postToTransactionOtpClient(qrTransactionOtpRequest: qrTransactionOtpRequest,qrTransactionOtpRequestForPathAndHeader: qrTransactionOtpRequestForPathAndHeader )
    }
    func postToTransactionOtpClient(qrTransactionOtpRequest: QRTransactionOtpRequest, qrTransactionOtpRequestForPathAndHeader: QRTransactionOtpRequestForPathAndHeader) {
        self.qrClient.postToTransactionOtpAfterInputPin(request: qrTransactionOtpRequest, requestForPathAndHeader: qrTransactionOtpRequestForPathAndHeader) { (result) in
            switch result.status {
            case true:
                if let result = result.data {
                    self.respUrlTrx = result.paylaterWebUrl ?? "-"
                    self.delegate?.didSuccessPostToTransctionOtp(idTransaksi: String(result.id ?? 0))
                }
                print(true)

            case false:


                if let isTimeout = result.isTimeOut {
                    if isTimeout {
                        self.delegate?.didTransactionOtpGetTimeOut()
                        return
                    }
                }
                if let astrapayError = result.errorData {
                    var code = astrapayError.details[0].code
                    if code == "OTP-NOT-MATCH"{
                        self.delegate?.didFailedTransactionByOtpBecauseOtpNotMatch()
                        return
                    }

                    if code == "OTP-SUBMIT-LOCK"{
                        self.delegate?.didFailedPostToTransactionOtpBecauseSubmitLock()
                        return
                    }

                    if code == "OTP-EXPIRED"{
                        self.delegate?.didFailedPostToTransactionOtpBecauseOtpExpired()
                        return
                    }
                }

                if let responseCode = result.responseCode {
                    if responseCode == 401 {
                        self.delegate?.didGoToLoginPageFromTransactionProcess()
                        return
                    }
                    if responseCode >= 400{
                        self.delegate?.didFailedPostToTransactionPinBecauseBadRequest()
                        return
                    }
                }
                //MARK: perlu dibikin logic jika error
                print(false)
            }

        }
    }
}

//MARK: get detail transaksi
extension QRPLMaucashQrisLoanTrxVM{
    func getDetailTransaksi(idTransaksi: String){
        self.getDetailTransaksiClient(idTransaksi: idTransaksi)
    }


    func getDetailTransaksiClient(idTransaksi: String){
        self.qrClient.getDetailTransaksiById(requestIdTransaksi: idTransaksi){ (result) in
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

//MARK: Get detail transaksi by token
extension QRPLMaucashQrisLoanTrxVM{
    func getDetailTransaksiByToken(requestTokenTransaksi: String, transactionType: TransactionType){
        self.getDetailTransaksiByTokenClient(requestTokenTransaksi: requestTokenTransaksi, transactionType: transactionType)
    }

    func getDetailTransaksiByTokenClient(requestTokenTransaksi: String, transactionType: TransactionType){
        self.qrClient.getDetailTransaksiByToken(requestTokenTransaksi: requestTokenTransaksi, completion: {
            (result) in
            switch result.status {
            case true:
                guard let data = result.data else {
                    self.delegate?.didFailedGetDetailTransaksiByToken()
                    return
                }
                guard let listGetDetailTransaksi = data.content else {
                    self.delegate?.didFailedGetDetailTransaksiByToken()
                    return
                }
                if listGetDetailTransaksi.count <= 0{
                    self.delegate?.didFailedGetDetailTransaksiByToken()
                    return
                }
                self.delegate?.didSuccessGetDetailTransaksiByToken(qrGetDetailTransaksiByIdResponse: listGetDetailTransaksi[0])
            case false:
                if let isTimeout = result.isTimeOut {
                    if isTimeout {
                        switch transactionType{
                        case TransactionType.pin:
                            self.delegate?.didFailedGetDetailTransaksiByToken()
                            return
                        case TransactionType.otp:
                            self.delegate?.didGetDetailTransaksiByTokenGetTimeOut()
                            return
                        }
                    }
                }

                if let responseCode = result.responseCode {
                    if responseCode == 401 {
                        self.delegate?.didGoToLoginPageFromTransactionProcess()
                        return
                    }
                }
            }
        })
    }
}


//MARK: resend otp
extension QRPLMaucashQrisLoanTrxVM{
    func getResendOtp(inquiryId: String){
        self.getResendOtpClient(inquiryId: inquiryId)
    }
    func getResendOtpClient(inquiryId: String){
        self.qrClient.getResendOtp(requestIdInquiry: inquiryId, completion: {
            (result) in
            switch result.status {
            case true:
                guard let resendOtpDtoResponse = result.data else {
                    assertionFailure("resend otp dto is null")
                    return
                }

                self.otpId = String(resendOtpDtoResponse.otpId)
            case false:
                guard let astrapayError = result.errorData else {
                    print("Error is is nil on otp")
                    return
                }

                if let responseCode = result.responseCode {
                    if responseCode == 401 {
                        self.delegate?.didGoToLoginPageFromTransactionProcess()
                        return
                    }
                }


                for detail in astrapayError.details{
                    if detail.code == "OTP-REQUEST-LOCK" {
                        self.delegate?.didFailedResendOtpBecauseOtpRequestLimitExceeded()
                    }
                }
            }
        })
    }
}
