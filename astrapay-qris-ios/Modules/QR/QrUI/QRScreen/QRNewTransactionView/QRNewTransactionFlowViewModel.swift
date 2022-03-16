//
// Created by Gilbert on 16/11/21.
// Copyright (c) 2021 Astra Digital Arta. All rights reserved.
//

import Foundation

enum TransactionType{
    case pin
    case otp
}

//MARK: Protocol
protocol QRNewTransactionFlowViewModelProtocol {

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


    //Transaksi Paylater
    func didPostToTransactionPaylaterThroughPin()
    func didPostToTransactionPaylaterThroughOtp()

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


struct QRPaymentAfterInputPinPayload {
    var tip: String?
    var totalAmount: String?
    var pin: String?
    var paymentMethod: [PaymentDto]?
}


enum QRISNewTipType : String {
    case fixed = "FIXED"
    case any = "ANY"
    case percentage = "PERCENTAGE"
    case none = "NONE"
}

struct QRNewTransactionFlowViewModelPayload{

}

class QRNewTransactionFlowViewModel {

    var userBalanceAstrapay: Int?
    //Objek dari kelas lain
    var qrInquiryDtoViewData: QRInquiryDtoViewData?
    var delegate: QRNewTransactionFlowViewModelProtocol?
    var qrTransactionPinResponse: QRTransactionPinResponse?
    private let qrClient = QRClient()
    var qrQRISPaymentReqModel: QRISPaymentReqModel?
    var qrPaymentAfterInputPinPayload: QRPaymentAfterInputPinPayload?

    var isPaylater: Bool = false


    var otpId: String = "0"



    //Property for view controller (general)

    func initVM(qrInquiryDtoViewData: QRInquiryDtoViewData, baseAmountTransactionFromInputAmountView: Int){
        self.qrInquiryDtoViewData = qrInquiryDtoViewData
        self.amountTransaction = baseAmountTransactionFromInputAmountView
        self.totalAmountTransaction = baseAmountTransactionFromInputAmountView

        self.tipAmount = Int(qrInquiryDtoViewData.qrInquiryQrisDto?.tip?.amount ?? Double(0))
        self.tipPercentage = Int(qrInquiryDtoViewData.qrInquiryQrisDto?.tip?.percentage ?? Double(0))

//        self.userBalanceAstrapay = userBalanceAstrapay

        self.qrPaymentAfterInputPinPayloadBuilder()
    }



    //MARK: variabel

    var amountTransaction: Int?
    var tipAmount: Int?
    var totalAmountTransaction: Int?
    var tipPercentage: Int?

    var userBalanceEnoughCompareToTotalAmount: Bool {
        return self.userBalanceAstrapay ?? 0 > self.totalAmountTransaction ?? 0
    }

}

//MARK Builder
extension QRNewTransactionFlowViewModel{
    func qrPaymentAfterInputPinPayloadBuilder(){
        var qrPaymentAfterInputPinPayload: QRPaymentAfterInputPinPayload = QRPaymentAfterInputPinPayload()
        let totalAmount = Int(self.amountTransaction ?? 0) + Int(self.tipAmount ?? 0)
        let paymentMethod: [PaymentDto] = [
            PaymentDto(method: "BALANCE", amount: totalAmount)
        ]
        qrPaymentAfterInputPinPayload = QRPaymentAfterInputPinPayload(tip: String(self.tipAmount ?? 0), totalAmount: String(self.amountTransaction ?? 0), paymentMethod: paymentMethod)

        self.qrPaymentAfterInputPinPayload = qrPaymentAfterInputPinPayload
    }
    func qrPaymentAfterInputPinPayloadBuilder(indexPathRow: Int, selectedImageFromAstrapay: Bool, selectedImageFromPLMC: Bool){
        var qrPaymentAfterInputPinPayload: QRPaymentAfterInputPinPayload = QRPaymentAfterInputPinPayload()
        if indexPathRow == 0 && selectedImageFromAstrapay == true{
            let totalAmount = Int(self.amountTransaction ?? 0) + Int(self.tipAmount ?? 0)
            let paymentMethod: [PaymentDto] = [
                PaymentDto(method: "BALANCE", amount: totalAmount)
            ]
            qrPaymentAfterInputPinPayload = QRPaymentAfterInputPinPayload(tip: String(self.tipAmount ?? 0), totalAmount: String(self.totalAmountTransaction ?? 0), paymentMethod: paymentMethod)
        } else if indexPathRow == 1{
            if selectedImageFromPLMC == true {
                var paymentMethod: [PaymentDto] = [
                    PaymentDto(method: "PAYLATER", amount: Int(self.amountTransaction ?? 0))
                ]
                if Int(self.tipAmount ?? 0) > 0 {
                    paymentMethod = [
                        PaymentDto(method: "PAYLATER", amount: Int(self.amountTransaction ?? 0)),
                        PaymentDto(method: "BALANCE", amount: Int(self.tipAmount ?? 0))
                    ]
                }

                qrPaymentAfterInputPinPayload = QRPaymentAfterInputPinPayload(tip: String(self.tipAmount ?? 0), totalAmount: String(self.amountTransaction ?? 0), paymentMethod: paymentMethod)
            } else {
                let totalAmount = Int(self.amountTransaction ?? 0) + Int(self.tipAmount ?? 0)
                let paymentMethod: [PaymentDto] = [
                    PaymentDto(method: "BALANCE", amount: totalAmount)
                ]
                qrPaymentAfterInputPinPayload = QRPaymentAfterInputPinPayload(tip: String(self.tipAmount ?? 0), totalAmount: String(self.amountTransaction ?? 0), paymentMethod: paymentMethod)
            }

        }

        self.qrPaymentAfterInputPinPayload = qrPaymentAfterInputPinPayload
    }
}
//MARK: GETco
extension QRNewTransactionFlowViewModel {
    func getQRMerchantInfoTvCellPayload() -> QRMerchantInfoCellPayload{
        var qrMerchantInfoCellPayload = QRMerchantInfoCellPayload(
                nameMerchant: "",
                lokasi: "",
                isUseDate: false,
                isBuyTo: false,
                date: "")
        //MARK: Fatal harus di hilangin nanti ini hanya untuk sebagai informan
        guard let qrInquiryDtoViewData = self.qrInquiryDtoViewData else {
            fatalError("qr inquiry is null")
        }
        guard let qrInquiryDto = qrInquiryDtoViewData.qrInquiryQrisDto else {
            fatalError("qr inquiry qris dto is null")
        }
        guard let merchant = qrInquiryDto.merchant else {
            fatalError("merchant is null")
        }
        guard let merchantName = merchant.merchantName else {
            fatalError("merchant name is null")
        }
        guard let merchantCity = merchant.merchantCity else {
            fatalError("merchant city is null")
        }
        guard let createdAt = qrInquiryDtoViewData.createdAt else {
            fatalError("created at is null")
        }
        qrMerchantInfoCellPayload = QRMerchantInfoCellPayload(nameMerchant: merchantName, lokasi: merchantCity ,isUseDate: true, isBuyTo: false, date: createdAt)
    return qrMerchantInfoCellPayload
    }
}
//MARK: Parsingan data dari view controller untuk nge hit endpoint transaction pin
extension QRNewTransactionFlowViewModel {
    func postToTransactionPin(qrPaymentAfterInputPinPayload: QRPaymentAfterInputPinPayload){
        self.postToTransactionPinToClient(qrPaymentAfterInputPinPayload: qrPaymentAfterInputPinPayload)
    }
    func postToTransactionPinToClient(qrPaymentAfterInputPinPayload: QRPaymentAfterInputPinPayload){
        var qrTransactionPinRequest: QRTransactionPinRequest = QRTransactionPinRequest(tipAmount: qrPaymentAfterInputPinPayload.tip , amount: qrPaymentAfterInputPinPayload.totalAmount, payments: qrPaymentAfterInputPinPayload.paymentMethod, pin: qrPaymentAfterInputPinPayload.pin)
        //MARK:  perlu bikin negatif case jika inquirynya aja udah null
        guard let qrInquiryDtoViewData = self.qrInquiryDtoViewData else {
            return
        }
        //ini perlu dibikin request struct tersendiri aja
        self.qrClient.postToTransactionPin(request: qrTransactionPinRequest, qrInquiryDtoViewData: qrInquiryDtoViewData, completion: {
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
                    self.delegate?.didNeedOtp()
                    self.qrTransactionPinResponse = qrTransactionPinResponse
                    self.otpId = String(qrTransactionPinResponse.otp?.otpId ?? 0)
                } else {
                    if self.isPaylater {
                        self.delegate?.didPostToTransactionPaylaterThroughPin()
                        return
                    }
                    self.delegate?.didSuccessPostToTransactionPin(qrTransactionPinResponse: qrTransactionPinResponse)
                }
                    print("Post to transaction pin is sukses")
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
                    }
                print(result.message + " ini adalah errornya")
                //MARK: Harus dibikin logic atau alert jika post ke transaction pin jika dia membalikkan error
                    print("Post to transaction pin got error")
            }
        })
        
    }
}
//MARK: hit transaction otp endpoint
extension QRNewTransactionFlowViewModel {
    func postToTransactionOtp(qrTransactionOtpRequest: QRTransactionOtpRequest, qrTransactionOtpRequestForPathAndHeader: QRTransactionOtpRequestForPathAndHeader) {
        self.postToTransactionOtpClient(qrTransactionOtpRequest: qrTransactionOtpRequest,qrTransactionOtpRequestForPathAndHeader: qrTransactionOtpRequestForPathAndHeader )
    }
    func postToTransactionOtpClient(qrTransactionOtpRequest: QRTransactionOtpRequest, qrTransactionOtpRequestForPathAndHeader: QRTransactionOtpRequestForPathAndHeader) {
        self.qrClient.postToTransactionOtpAfterInputPin(request: qrTransactionOtpRequest, requestForPathAndHeader: qrTransactionOtpRequestForPathAndHeader) { (result) in
            switch result.status {
            case true:
                if let result = result.data {
                    if self.isPaylater {
                        self.delegate?.didPostToTransactionPaylaterThroughOtp()
                        return
                    }
                    self.delegate?.didSuccessPostToTransctionOtp(idTransaksi: String(result.id ?? 0))
                    return
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
                //MARK: perlu dibikin logic jika error
                print(false)

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
            }

        }
    }
}
//MARK: Hit resend otp
extension QRNewTransactionFlowViewModel{
    func getResendOtp(inquiryId: String){
        DispatchQueue.main.async {
            self.getResendOtpClient(inquiryId: inquiryId)
        }
    }
    func getResendOtpClient(inquiryId: String){
        self.qrClient.getResendOtp(requestIdInquiry: String(self.qrInquiryDtoViewData?.id ?? 0), completion: {
            (result) in
            switch result.status {
            case true:
                guard let resendOtpDtoResponse = result.data else {
                    assertionFailure("resend otp dto is null")
                    return
                }
                self.otpId = String(resendOtpDtoResponse.otpId)
                break
            case false:
                guard let astrapayError = result.errorData else {
                    print("Error is is nil on otp")
                    return
                }



                for detail in astrapayError.details{
                    if detail.code == "OTP-REQUEST-LOCK" {
                        self.delegate?.didFailedResendOtpBecauseOtpRequestLimitExceeded()
                    }
                }
                break
            }
        })
    }
}

//MARK: Hit get transaction by token
extension QRNewTransactionFlowViewModel{
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
            }
        })
    }
}


//MARK: Hit detail transaksi
extension QRNewTransactionFlowViewModel {
    func getDetailTransaksi(idTransaksi: String){
        self.getDetailTransaksiClient(idTransaksi: idTransaksi)
    }


     func getDetailTransaksiClient(idTransaksi: String){
         var transaksiId = idTransaksi
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

//MARK: if is paylater
extension QRNewTransactionFlowViewModel {
    func ifIsPaylater(){
        if self.isPaylater {
            self.delegate?.didPostToTransactionPaylaterThroughPin()
            return
        }
    }
}



//MARK: cara hitung total payment dan set tip type (All related to QRDetailTransactionCell)
extension QRNewTransactionFlowViewModel {
    func getTotalPayment() -> Int{
        var totalAmount: Int = 0

        let tipType = self.getTipType()
        guard let jumlahTransaksi = amountTransaction else {
            print("amount transaction is null")
            return 0
        }

        //ini buat ngetest doang
        var tipeTip: QRISNewTipType = .any


        switch tipType {
        case .fixed :
            totalAmount = Int(jumlahTransaksi) + Int (self.tipAmount ?? 0)
            return totalAmount

                //MARK: ini perlu dibikin lagi logicnya
        case .any :
            totalAmount = Int(jumlahTransaksi) + Int (self.tipAmount ?? 0)
            return totalAmount
        case .percentage :
            let percentage = self.tipPercentage  ?? 0
            let amount = jumlahTransaksi + ((percentage/100) * jumlahTransaksi)
            let intAmount = Int(amount)
            return intAmount
        default :
            //
            return Int(jumlahTransaksi)
        }
    }

    func getTipType() -> QRISNewTipType {
        //MARK: 1 //fixed -> Ditampilin berupa Rp. *tidak editable
        let conditionTipFixed = self.qrInquiryDtoViewData?.qrInquiryQrisDto?.tip?.type == "FIXED"
        if conditionTipFixed {
            return .fixed
        }

        //MARK: 2 //any -> Ditampilin editable Rp.
        let conditionTipAny = self.qrInquiryDtoViewData?.qrInquiryQrisDto?.tip?.type == "ANY"
        if conditionTipAny {
            return .any
        }

        //MARK: 3 //percentage -> Ditampilin kiri ada percentage && kanan Rp. & tidak bisa di edit
        let conditionTipPercentage = self.qrInquiryDtoViewData?.qrInquiryQrisDto?.tip?.type == "PERCENTAGE"
        if conditionTipPercentage {
            return .percentage
        }
        return .none
    }

    func getQRDetailTransactionTvCellPayload() -> QRDetailTransactionCellPayload {

        let tipType = self.getTipType()

        var tips = self.tipAmount ?? 0

        guard let jumlahTransaksi = amountTransaction else {
            //MARK: Perlu dibikin logic untuk jika amount transaction is null
            print("DEBUG: amount transaction is null")

            //MARK: ini harus dihapus
            fatalError("Amount transaction is null")
//            return
        }

        if tipType == .percentage {
            let incrementPercentage = self.tipPercentage ?? 0
            let incrementValue = incrementPercentage / 100 * jumlahTransaksi
            tips = incrementValue
        }

        if tipType == .any {
            tips = self.tipAmount ?? 0
        }

        let tipsPercentage = String(
                self.tipPercentage ?? 0
        )

        self.totalAmountTransaction = getTotalPayment()




        var qrDetailTransactionCellPayload = QRDetailTransactionCellPayload(jumlahTransaksi: Int(jumlahTransaksi),

                //TODO ini harusnya dibikin logic untuk jika tips nya percentage atau any gitu
                //MARK: harusnya di bikin logic untuk apakah menggunakan tips atau tidak
                totalPayment: Int(self.totalAmountTransaction ?? 0),
//                isUseTips: true,


                //MARK: untuk masalah tips, percentage, tiptype harusnnya dibikin logic
                tips: tips,
                tipsPercentage: tipsPercentage,
                tipType: tipType
        )
//        if (tipType != .none){
//            qrDetailTransactionCellPayload.isUseTips = true
//        }

//        var qrDetailTransactionCellPayload = QRDetailTransactionCellPayload()
//        qrDetailTransactionCellPayload.totalPayment =

        return qrDetailTransactionCellPayload
    }
}
