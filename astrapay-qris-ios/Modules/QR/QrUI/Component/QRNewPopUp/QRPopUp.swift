//
//  PopUpLimitAmount.swift
//  astrapay
//
//  Created by Sandy Chandra on 28/06/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit

protocol QRPopUpProtocol {
    func didActionButtonPressed()
}

enum QRPopUpLimitAmountType{
    case prefered
    case classic
}

enum QRPopUpType {
    case limitAmount;
    case qrFailed;
case pinTemporaryLock;
case pinPermanentLock;
}


struct QRPopUpPayload{
    var imageName: String
    var titleText: String
    var subtitleLableText: String
    var titleButton: String
}
class QRPopUp: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var actionButton: QRAPButtonAtom!
    @IBOutlet weak var containView: UIView!
    
    private let amountPreferred = 5000000
    private let amountClassic = 2000000
    
    var delegate: QRPopUpProtocol?
    
    static let nibName = "QRPopUp"
    static let identifier = "QRPopUpIdentifier"
    
    var qrPopUpType: QRPopUpType?
    var qrPopUpLimitAmountType: QRPopUpLimitAmountType?

    var qrPopUpPayload: QRPopUpPayload?


    func setupQrPopUp(qrPopUpType: QRPopUpType, qrPopUpLimitAmountType: QRPopUpLimitAmountType? = nil){
        self.qrPopUpType = qrPopUpType
        self.qrPopUpLimitAmountType = qrPopUpLimitAmountType

        self.setupView()
    }
    
    func setupView() {
        guard let qrPopUpType = self.qrPopUpType else {
            print("qr pop up type is null")
            return
        }
        switch qrPopUpType {
        case QRPopUpType.qrFailed:
            self.setupViewQRFailed()
            break
        case QRPopUpType.limitAmount:
            self.setupViewForAmountLimit()
            break
        case QRPopUpType.pinTemporaryLock:
            self.setupViewPinTemporaryLock()
            break
        case QRPopUpType.pinPermanentLock:
            self.setupViewPinPermanentLock()
            break
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetupQR(nibName: QRPopUp.nibName)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetupQR(nibName: QRPopUp.nibName)
    }

    override func awakeFromNib() {
        xibSetupQR(nibName: QRPopUp.nibName)
    }

}



//MARK: setup view
extension QRPopUp{

    func initQRPopUP(qrPopUpPayload: QRPopUpPayload){
        self.qrPopUpPayload = qrPopUpPayload

        self.setupQRPopUp()

    }

    func setupQRPopUp(){
        self.containView.roundCorners(value: 15)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.imageView.image = UIImage(named: self.qrPopUpPayload?.imageName ?? "-")
        self.titleLabel.text = self.qrPopUpPayload?.titleText ?? "-"
        self.subtitleLabel.text = self.qrPopUpPayload?.subtitleLableText ?? "-"
        self.actionButton.setAtomic(type: .filled, title: self.qrPopUpPayload?.titleButton ?? "-")

        self.titleLabel.font = UIFont.setupFont(size: 22, fontType: .interSemiBold)
        self.subtitleLabel.font = UIFont.setupFont(size: 14, fontType: .interRegular)

        self.actionButton.coreButton.addTapGestureRecognizerQR(action: {
            self.delegate?.didActionButtonPressed()
        })
    }
}

//MARK: untuk amount limit
extension QRPopUp{
    private func setupViewForAmountLimit(){
        self.containView.roundCorners(value: 15)
        self.imageView.image = UIImage(named: "illustration_limitAmount")
        self.titleLabel.text = "Melebihi Limit"
        if self.qrPopUpLimitAmountType == QRPopUpLimitAmountType.prefered {
            self.subtitleLabel.text = "Limit transaksi QRIS, maksimal \(self.amountPreferred.toIDRQR(withSymbol: true)!)"
        } else {
            self.subtitleLabel.text = "Limit transaksi user Classic maximal \(self.amountClassic.toIDRQR(withSymbol: true)!), upgrade dulu ke User Preferred yuk"

        }
        self.actionButton.setAtomic(type: .filled, title: "OK")

        self.titleLabel.font = UIFont.setupFont(size: 22, fontType: .interSemiBold)
        self.subtitleLabel.font = UIFont.setupFont(size: 14, fontType: .interRegular)

        self.actionButton.coreButton.addTapGestureRecognizerQR(action: {
            self.delegate?.didActionButtonPressed()
        })
    }
}

//MARK: untuk qr failed
extension QRPopUp {
    private func setupViewQRFailed(){
        self.containView.roundCorners(value: 15)
        self.imageView.image = UIImage(named: "illustration_failed")
        self.titleLabel.text = "QR Tidak Terdaftar"
        self.subtitleLabel.text = "Maaf kode QR ini tidak terdaftar di sistem kami, coba scan kode lainnya ya."
        self.actionButton.setAtomic(type: .filled, title: "OK")

        self.titleLabel.font = UIFont.setupFont(size: 22, fontType: .interSemiBold)
        self.subtitleLabel.font = UIFont.setupFont(size: 14, fontType: .interRegular)

        self.actionButton.coreButton.addTapGestureRecognizerQR(action: {
            self.delegate?.didActionButtonPressed()
        })
    }
}


extension QRPopUp{
    //MARK: Untuk Pin ke lock sementara (belom nyanpe sembilan kali)
    private func setupViewPinTemporaryLock(){
        self.containView.roundCorners(value: 15)
        self.imageView.image = UIImage(named: "illustration_pin")
        self.titleLabel.text = "Mohon Maaf"
        self.subtitleLabel.text = "Kamu sudah 3 kali salah PIN Coba kembali setelah 1 jam"
        self.actionButton.setAtomic(type: .filled, title: "Kembali ke Beranda")

        self.titleLabel.font = UIFont.setupFont(size: 22, fontType: .interSemiBold)
        self.subtitleLabel.font = UIFont.setupFont(size: 14, fontType: .interRegular)

        self.actionButton.coreButton.addTapGestureRecognizerQR(action: {
            self.delegate?.didActionButtonPressed()
        })

    }

    private func setupViewPinPermanentLock(){
        self.containView.roundCorners(value: 15)
        self.imageView.image = UIImage(named: "illustration_pin")
        self.titleLabel.text = "Akun Kamu Terkunci"
        self.subtitleLabel.text = "Kamu sudah melebihi batas memasukkan PIN. Hubungi CS untuk pemulihan akun"
        self.actionButton.setAtomic(type: .filled, title: "Kembali ke Beranda")

        self.titleLabel.font = UIFont.setupFont(size: 22, fontType: .interSemiBold)
        self.subtitleLabel.font = UIFont.setupFont(size: 14, fontType: .interRegular)

        self.actionButton.coreButton.addTapGestureRecognizerQR(action: {
            self.delegate?.didActionButtonPressed()
        })
}
}
