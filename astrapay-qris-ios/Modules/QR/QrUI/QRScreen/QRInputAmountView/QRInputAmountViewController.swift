//
// Created by Gilbert on 05/11/21.
// Copyright (c) 2021 Astra Digital Arta. All rights reserved.
//

import Foundation
import UIKit

class QRInputAmountViewController: UIViewController {


    @IBOutlet weak var profileHeadImage: UIImageView!
    @IBOutlet weak var infoProfileLabel: QRUILabelInterSemiBold!
    @IBOutlet weak var titleContentHeader: QRUILabelInterRegular!
    @IBOutlet weak var jumlahTransferLabel: QRUILabelInterSemiBold!
    @IBOutlet weak var amountLabel: QRUILabelInterRegular!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var inputAmountKeyboardView: QRInputKeyboardView!

    @IBOutlet weak var viewButton: QRAPButtonAtom!


//    var qrPopUP: QRPopUp?
    var amountInputed: Double = 1000_000.0
    let popUpLimit = QRPopUp()
    //For QRIS, already set at QRRouter
    var maximumAmount : Int?

    struct QRNewPayloadViewProperty{
        var response : QRInquiryDtoViewData?
    }

    var qrPayload = QRNewPayloadViewProperty()

    var viewModel: QRInputAmountViewModel?

    
    
    //MARK: initializer
    func initQRPayload(payload : QRInquiryDtoViewData){
        self.qrPayload.response = payload

        self.viewModel = QRInputAmountViewModel(qrInquiryDtoViewData: payload)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupQrUIInfoFromInquiry()
        setupQRRouter()
        setupActions()
        setupProtocol()
        setupUserBalance()
    }
    // variabel dari kelas lain
    var qrNewRouter: QRNewRouter?
}
extension QRInputAmountViewController {
    func setupActions (){
        self.viewButton.coreButton.addTapGestureRecognizer {
//            print("Aneh")
        guard let qrInquiryDtoViewData = self.viewModel?.qrInquiryDtoViewData else {
           return
        }
            guard let amountTransaction = self.amountLabel.text else {
                return
            }
            self.qrNewRouter?.navigateToTransactionDetailAfterInputAmount(qrInquiryDtoViewData: qrInquiryDtoViewData, amountTransaction: Int(self.amountInputed))
        }
    }
    func setupProtocol(){
        self.viewModel?.delegate = self
    }

    func setupUserBalance(){
        self.viewModel?.userBalanceAstrapay = Int(Prefs.getUser()?.balance ?? 0)
    }
}

extension QRInputAmountViewController {
    func setupQRRouter(){
        self.qrNewRouter = QRNewRouter(viewController: self)
    }
}

// extension yang berhubungan dengan qris
extension QRInputAmountViewController {

    private func setupUI(){
        self.inputAmountKeyboardView.delegate = self
        self.viewButton.backgroundColor = UIColor.clear
        self.inputAmountKeyboardView.setupView(withMaximumAmount: self.viewModel?.maximumAmount)
        self.amountLabel.text = "Rp 0"
        self.viewButton.setAtomic(type: .disabled, title: "LANJUTKAN")
        self.tipsLabel.isHidden = true
    }
}




//MARK: (Bukan Masalah) setup input amount dari input keyboard view protocol
extension QRInputAmountViewController: QRInputKeyboardViewProtocol {
    func maximumAmountCounted() {
        self.setupPopUp()
    }
    
    func currentAmount(amount: Double) {
        self.amountInputed = amount
        self.amountLabel.text = amountInputed.toIDR()
        self.isEnableButtonAmount()
    }
}



//extension yang berhubungan dengan view button
extension QRInputAmountViewController {
    private func isEnableButtonAmount() {
        let qrCondition = (self.amountInputed > 0)
        self.viewModel?.amountInputedValidation(amountInputed: self.amountInputed, maximumAmount: self.viewModel?.maximumAmount)
        //MARK: (Masalah) kita harus buat ada muncul pop up jika amount melebihi batas
        self.viewModel?.amountMoreThanMaximumAmount(amountInputed: amountInputed, maximumAmount: self.viewModel?.maximumAmount)

    }
}

// extension yang berhubungan dengan qr inquiry
extension QRInputAmountViewController{
    func setupQrUIInfoFromInquiry(){
        self.infoProfileLabel.text = self.viewModel?.merchantName
        self.jumlahTransferLabel.text = "Jumlah Nominal Transaksi"
        self.titleContentHeader.text = "\(self.viewModel?.merchantCity ?? "-")" +
                "\n \(self.viewModel?.createdAt ?? "-")"
        self.titleContentHeader.font = UIFont.setupFont(size: 12, fontType: .interThin)
        self.titleContentHeader.isHidden = false
        self.tipsLabel.font = UIFont.setupFont(size: 12, fontType: .interRegular)
        self.tipsLabel.textColor = QRBaseColor.disabledTitleColor

    }
}



//MARK: untuk register pop up
extension QRInputAmountViewController: QRPopUpProtocol {
    func setupPopUp(){
        popUpLimit.setupQrPopUp(qrPopUpType: QRPopUpType.limitAmount, qrPopUpLimitAmountType: QRPopUpLimitAmountType.classic)
        popUpLimit.delegate = self
        self.showPopUpViewQR(withView: popUpLimit)
    }
    func didActionButtonPressed(){
        self.dismissPopUpViewQR()
    }
}

//MARK: implement QRInputAmountViewModelProtocol
extension QRInputAmountViewController: QRInputAmountViewModelProtocol {
    func amountInputedValidationPassed(){
        DispatchQueue.main.async {
            self.viewButton.setAtomic(type: .filled, title: "LANJUTKAN")
        }
    }
    func amountInputedValidationFailed(){
        DispatchQueue.main.async {
            self.viewButton.setAtomic(type: .disabled, title: "LANJUTKAN")
        }
    }
    func amountMoreThanMaximumAmountIsTrue(){
        DispatchQueue.main.async {
            self.setupPopUp()
        }
    }
}
