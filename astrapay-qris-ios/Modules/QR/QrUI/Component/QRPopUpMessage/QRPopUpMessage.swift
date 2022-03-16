//
//  QRPopUpMessage.swift
//  astrapay
//
//  Created by Guntur Budi on 05/08/20.
//  Copyright © 2020 Tirta Rivaldi. All rights reserved.
//

import UIKit

protocol QRPopUpMessageProtocol : class {
    func didPressMainButton()
}

protocol QRPopUpMessageRegisterProtocol : class {
    func didPressButtonRegister()
}

protocol QRPopUpMessageForgotChangePinProtocol: class {
    func didPressButton()
}

protocol QRPopUpMessagePBBProtocol : class {
    func didPressButttonPBBNotFound()
}

protocol QRPopUpMessageLogoutProtocol: class {
    func didPressFirstButton()
    func didPressSecondButton()
}

class QRPopUpMessage: UIView {

    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var imgPopUP : UIImageView!
    @IBOutlet weak var lblPopUp : UILabelInterRegular!
    @IBOutlet weak var firstBtnPopUp : APButtonAtom!
    @IBOutlet weak var secondBtnPopUp: APButtonAtom!
    
    struct VCProperty{
        static let constantHeightPopUp = 360
        static let identifier : String = "qrPopUpMessageIdentifier"
        static let nibName : String = "QRPopUpMessage"
        static let popUpHeight : CGFloat = 350
        static let constantMoreThanIphone7 : CGFloat = 120
        static let constantIphoneSe : CGFloat = 80
    }
    static let identifier = VCProperty.identifier
    static let nibName = VCProperty.nibName
    var delegate : QRPopUpMessageProtocol?
    var delegateRegister: QRPopUpMessageRegisterProtocol?
    var delegatePBB : QRPopUpMessagePBBProtocol?
    var delegateLogout: QRPopUpMessageLogoutProtocol?
    static let popUpHeight : CGFloat = VCProperty.popUpHeight
    let constantMoreThanIphone7 : CGFloat = VCProperty.constantMoreThanIphone7
    let constantIphoneSe : CGFloat = VCProperty.constantIphoneSe

    override class func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetupQR(nibName: QRPopUpMessage.nibName)
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetupQR(nibName: QRPopUpMessage.nibName)
    }

    override func awakeFromNib() {
        xibSetupQR(nibName: QRPopUpMessage.nibName)
    }

}

extension QRPopUpMessage{

    func setupView(isWithNavigationBar : Bool = true){
//        let isMoreThaniPhone7 = UIScreen.main.bounds.height > 700
//
//        var heightOfConstant : CGFloat = 0
//
//        if isMoreThaniPhone7 {
//            heightOfConstant = constantMoreThanIphone7
//        }else {
//            heightOfConstant = constantIphoneSe
//        }
//
//        self.bottomSpaceButton.constant = heightOfConstant
    }

    func setupMessage(title : String , withImage : UIImage, withBtnTitle : String){
        DispatchQueue.main.async {
            self.setupView()
            self.imgPopUP.image = withImage
            self.lblPopUp.text = title
            self.firstBtnPopUp.setAtomic(type: .filled, title: withBtnTitle, messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }

    func setupRegisterMessage(){
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_closeacc")
            self.lblPopUp.text = "Nomor kamu belum terdaftar di AstraPay.\nDaftar sekarang yuk!"
            self.firstBtnPopUp.setAtomic(type: .filled, title: "DAFTAR", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegateRegister?.didPressButtonRegister()
            })
        }
    }

    func setupQRNotFoundMessage(){
        self.setupView()
        self.imgPopUP.image = UIImage(named: "illustration_rejected")
        self.lblPopUp.text = "Maaf kode QR ini tidak terdaftar di sistem kami, coba scan kode lainnya ya."
        self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
        self.containerView.roundedTopMessage(isFullScreen: true)
        self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
            self.delegate?.didPressMainButton()
        })
    }
    
    func setupLimitTransactionQR(isPreferred: Bool, limitTransaction: Int) {
        self.setupView()
        self.imgPopUP.image = UIImage(named: "illustration_rejected")
        self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
        self.containerView.roundedTopMessage(isFullScreen: true)
        self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
            self.delegate?.didPressMainButton()
        })
        
        if isPreferred {
            self.lblPopUp.text = "Limit transaksi QRIS maksimal \(limitTransaction.toIDR() ?? "Rp 0")"
        } else {
            self.lblPopUp.text = "Limit transaksi user Classic maksimal \(limitTransaction.toIDR() ?? "Rp 0"), upgrade dulu yuk ke Preferred"
        }
        
    }

//    func setupPBBNotFound(){
//        self.setupView()
//        self.imgPopUP.image = UIImage(named: "img_think")
//        self.lblPopUp.text = "Data yang Anda masukkan tidak ditemukan.\n Coba periksa kembali data Anda."
//        self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
//        self.containerView.roundedTopMessage(isFullScreen: true)
//        self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
//            self.delegatePBB?.didPressButttonPBBNotFound()
//        })
//    }
    
//    func setupNoPBBNotFound(){
//        self.setupView()
//        self.imgPopUP.image = UIImage(named: "img_think")
//        self.lblPopUp.attributedText =
//            NSMutableAttributedString()
//                .normal("No.Objek Pajak ")
//                .bold("Tidak Ditemukan.\n")
//                .normal("Coba periksa kembali data Anda.")
//        self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
//        self.containerView.roundedTopMessage(isFullScreen: true)
//        self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
//            self.delegatePBB?.didPressButttonPBBNotFound()
//        })
//    }

    func setupProductNotFound(){
        self.setupView()
        self.imgPopUP.image = UIImage(named: "illustration_rejected")
        self.lblPopUp.text = AlertInfo.productNotFound.rawValue
        self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
        self.containerView.roundedTopMessage(isFullScreen: true)
        self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
            self.delegate?.didPressMainButton()
        })
    }

//    func setupNumberNotFound(){
//        self.setupView()
//        self.imgPopUP.image = UIImage(named: "img_think")
//        self.lblPopUp.text = AlertInfo.wrongNumber.rawValue
//        self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
//        self.containerView.roundedTopMessage(isFullScreen: true)
//        self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
//               self.delegate?.didPressMainButton()
//        })
//    }

    func setupConnectionTimeOut(){
        self.setupView()
        self.imgPopUP.image = UIImage(named: "illustration_rejected")
        self.lblPopUp.text = AlertInfo.transactionTryAgain.rawValue
        self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
        self.containerView.roundedTopMessage(isFullScreen: true)
        self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
               self.delegate?.didPressMainButton()
        })
    }

    @objc func didPressButton(){
        delegate?.didPressMainButton()
    }

    func setupForgotPinMessage(){
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_pin")
            self.lblPopUp.text = AlertInfo.changeInfoTemporaryPin.rawValue
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupSuccessChangePin(){
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_pin")
            self.lblPopUp.text = "PIN Berhasil Diganti.\nLangsung gunakan PIN baru untuk mulai bertransaksi!"
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupChangeNameSuccess(){
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_success")
            self.lblPopUp.text = AlertInfo.changeNameSuccesPopUP.rawValue
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
        
    func setupChangeNameProgressUpgrade(){
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_failed")
            self.lblPopUp.text = AlertInfo.changeNameUpgradeProses.rawValue
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupChangeNameFinalVerified(){
            DispatchQueue.main.async {
                self.setupView(isWithNavigationBar: false)
                self.imgPopUP.image = UIImage(named: "illustration_failed")
                self.lblPopUp.text = AlertInfo.preferedPrior.rawValue
                self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
                self.containerView.roundedTopMessage(isFullScreen: true)
                self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                    self.delegate?.didPressMainButton()
                })
            }
        }

    func setupChangeEmail(){
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_success")
            self.lblPopUp.text = AlertInfo.changeEmailSuccesPopUP.rawValue
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }

    func setupDuplicateEmail(){
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_failed")
            self.lblPopUp.text = SettingNewEmailVC.VCProperty.alertDuplicateEmail
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }

    func setupNewPinMessage(){
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "ic_changepin_success")
            self.lblPopUp.text = AlertInfo.changePinSuccess.rawValue
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupSuccessKlaimVoucher(){
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "img_success_klaim_voucher")
            self.lblPopUp.text = AlertInfo.successKlaimVoucher.rawValue
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupFailureKlaimVoucher(){
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "img_question")
            self.lblPopUp.text = AlertInfo.failureKlaimVoucher.rawValue
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupErrorConnection(){
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "img_voucher_loss_connection")
            self.lblPopUp.text = AlertInfo.errorConnection.rawValue
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupDeleteBankAccount(lblFirstBtn:String,lblSecondBtn:String){
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_bank_delete")
            self.lblPopUp.text = AlertInfo.deleteBankAccount.rawValue
            self.firstBtnPopUp.setAtomic(type: .filled, title: lblFirstBtn, messageError: "")
            self.secondBtnPopUp.setAtomic(type: .nudeWhite, title: lblSecondBtn, messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.secondBtnPopUp.isHidden = false
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupDuplicateRekeningBank(){
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_rejected")
            self.lblPopUp.text = AlertInfo.existbank.rawValue
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupSuccessRemoveBankAccount(){
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "ic_forgotpin_success")
            self.lblPopUp.text = AlertInfo.removeBankSuccess.rawValue
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupCloseAccount(lblFirstBtn:String,lblSecondBtn:String){
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_closeacc_alert")
            
            let firstText  = "Yakin Ingin Tutup Akun?"
            let secondText = "\n\nJika ya, kami akan bantu tarik seluruh saldomu di AstraPay."
            let attrsF = [NSAttributedString.Key.font : UIFont.font(size: 22, fontType: .interSemiBold)]
            let attrsS = [NSAttributedString.Key.font : UIFont.font(size: 16, fontType: .interRegular)]
            let firstString = NSMutableAttributedString(string: firstText, attributes:attrsF)
            let secondString = NSMutableAttributedString(string:secondText, attributes:attrsS)
            firstString.append(secondString)
            
            self.lblPopUp.attributedText = firstString
            self.firstBtnPopUp.setAtomic(type: .filled, title: "BATAL", messageError: "")
            self.secondBtnPopUp.setAtomic(type: .nudeWhite, title: "YA, LANJUTKAN", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.secondBtnPopUp.isHidden = false
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupUpgradeKyc() {
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_rejected")
            self.lblPopUp.text = "Untuk menu transfer, akun Anda harus di-upgrade menjadi preferred terlebih dahulu."
            self.firstBtnPopUp.setAtomic(type: .filled, title: "Upgrade", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupPermataCashoutExpired() {
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_rejected")
            self.lblPopUp.text = "Kode reservasi sudah kadaluwarsa, lakukan reservasi tarik tunai kembali"
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupMaksSentVerifyEmail() {
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "img_sent_mail")
            self.lblPopUp.text = "Kamu telah melebihi batas pengiriman email \n verifikasi harian (maksimal 3 email/hari)"
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupBrokenSentVerifyEmail() {
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "img_broken_connection")
            self.lblPopUp.text = "Permintaan kirim email verifikasi gagal. \n Pastikan internet terhubung dan coba kembali"
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupChangePinFailedVerify() {
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_rejected")
            self.lblPopUp.text = "Kamu tidak bisa memulihkan PIN karena \n email belum terverifikasi. \n Mohon hubungi Call Center AstraPay 1500793"
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupLimitPLMCnotAvailable() {
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration")
            self.lblPopUp.text = "Saldo Paylater kamu tidak mencukupi"
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupUserBeforeCompleteKredit() {
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_rejected")
            self.lblPopUp.text = "Mohon lunasi pembayaran kamu terlebih dahulu"
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupPLMCnotUsePay() {
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_rejected")
            self.lblPopUp.text = "Untuk Sementara kamu tidak bisa menggunakan paylater"
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
//    func setupUpAccRegisPLMaucash(lblFirstBtn:String,lblSecondBtn:String) {
//        DispatchQueue.main.async {
//            self.setupView(isWithNavigationBar: false)
//            self.imgPopUP.image = UIImage(named: "illustration_rejected")
//            self.lblPopUp.text = "Upgrade akun menjadi preferred dahulu untuk \n menikmati layanan Paylater"
//            self.firstBtnPopUp.setAtomic(type: .filled, title: "UPGRADE NOW", messageError: "")
//            self.secondBtnPopUp.setAtomic(type: .nudeWhite, title: "BACK", messageError: "")
//            self.containerView.roundedTopMessage(isFullScreen: true)
//            self.secondBtnPopUp.isHidden = false
//            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
//                self.delegate?.didPressMainButton()
//            })
//        }
//    }
    
    func setupNavToWebPLMaucash() {
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_rejected")
            self.lblPopUp.text = "Kamu akan diarahkan ke website maucash \n untuk melanjutkan pendaftaran paylater"
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.secondBtnPopUp.setAtomic(type: .nudeWhite, title: "BACK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.secondBtnPopUp.isHidden = false
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupCanotTransaction(stringAtribute: NSMutableAttributedString,lblFirstBtn:String,lblSecondBtn:String){
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_discount")
            self.lblPopUp.attributedText = stringAtribute
            self.firstBtnPopUp.setAtomic(type: .disabled, title: lblFirstBtn, messageError: "")
            self.secondBtnPopUp.setAtomic(type: .nude, title: lblSecondBtn, messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.secondBtnPopUp.isHidden = false
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupReedemVoucher(stringAtribute: NSMutableAttributedString,lblFirstBtn:String,lblSecondBtn:String){
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_discount")
            self.lblPopUp.attributedText = stringAtribute
            self.firstBtnPopUp.setAtomic(type: .filled, title: lblFirstBtn, messageError: "")
            self.secondBtnPopUp.setAtomic(type: .nudeWhite, title: lblSecondBtn, messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.secondBtnPopUp.isHidden = false
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    //MARK: Alert Biller New
    func setupBillerPopUp(message: String, imageName: String = "illustration_rejected") {
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: imageName)
            self.lblPopUp.text = message
            self.firstBtnPopUp.setAtomic(type: .filled, title: "OK", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegate?.didPressMainButton()
            })
        }
    }
    
    func setupLogoutPopup() {
        DispatchQueue.main.async {
            self.setupView(isWithNavigationBar: false)
            self.imgPopUP.image = UIImage(named: "illustration_logout")
            
            let secondText = "\n\nYakin untuk keluar aplikasi?"
            let firstText  = "Keluar"
            let attrsF = [NSAttributedString.Key.font : UIFont.font(size: 22, fontType: .interSemiBold)]
            let attrsS = [NSAttributedString.Key.font : UIFont.font(size: 16, fontType: .interRegular)]
            let firstString = NSMutableAttributedString(string: firstText, attributes:attrsF)
            var secondString = NSMutableAttributedString(string:secondText, attributes:attrsS)
            firstString.append(secondString)
            
            self.lblPopUp.attributedText = firstString
            self.firstBtnPopUp.setAtomic(type: .filled, title: "YA", messageError: "")
            self.secondBtnPopUp.setAtomic(type: .nudeWhite, title: "NANTI", messageError: "")
            self.containerView.roundedTopMessage(isFullScreen: true)
            self.secondBtnPopUp.isHidden = false
            self.firstBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegateLogout?.didPressFirstButton()
            })
            self.secondBtnPopUp.coreButton.addTapGestureRecognizer(action: {
                self.delegateLogout?.didPressSecondButton()
            })
        }
    }
}
