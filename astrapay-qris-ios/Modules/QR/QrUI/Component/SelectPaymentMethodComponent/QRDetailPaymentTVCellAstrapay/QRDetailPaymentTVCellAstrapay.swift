//
//  QRPLMCDetailPaymentTVCell.swift
//  astrapay
//
//  Created by Antonius on 05/03/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit

protocol QRDetailPaymentTVCellAstrapayProtocolSDK{
    func getUserBalance() -> String

}

protocol QRDetailPaymentTVCellAstrapayProtocol {
    func didAstrapayCellReloaded(userBalance: Int)
}


class QRDetailPaymentTVCellAstrapay: UITableViewCell {

    let paymentImageName = "main_icon_small"
    let paymentName = "AstraPay"


    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var paymentImage: UIImageView!
    @IBOutlet weak var paymentNameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var selectedPaymentImage: UIImageView!
    
    static let nibName = "QRDetailPaymentTVCellAstrapay"
    static let identifier = "QRDetailPaymentTVCellAstrapayIdentifier"
    
    let nameSelectedImage: String = "ic_check"
    var delegate: QRDetailPaymentTVCellAstrapayProtocol?
    var delegateSDK: QRDetailPaymentTVCellAstrapayProtocolSDK?
    var viewModel: QRDetailPaymentTVCellAstrapayViewModel = QRDetailPaymentTVCellAstrapayViewModel()


    func setupView(content: QRSelectPaymentViewPayload) {

        self.paymentImage.image = UIImage(named: self.paymentImageName)
        self.paymentNameLabel.text = self.paymentName
//        shimmerView.contentView = self.paymentImage.image

//        self.balanceLabel.text = self.delegate?.getUserBalance() ?? "Rp 0"
        self.balanceLabel.text = Prefs.getUser()?.balance?.toIDRQR() ?? "Rp 0"
        self.informationLabel.text = content.information
        self.selectedPaymentImage.image = UIImage(named: self.nameSelectedImage)

        self.paymentNameLabel.font = UIFont.setupFont(size: 14, fontType: .interSemiBold)
        self.balanceLabel.font = UIFont.setupFont(size: 14, fontType: .interRegular)
        self.informationLabel.font = UIFont.setupFont(size: 12, fontType: .interRegular)
        self.informationLabel.textColor = QRBaseColor.QRProperties.baseColor

//        self.selectedPaymentImage.isHidden = false
        self.containerView.roundCorners(value: 10)
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = QRBaseColor.QRProperties.baseDisabledColor.cgColor
        self.selectionStyle = .none

//        var userBalance: Int = Int(self.delegate?.getUserBalance() ?? "0")

        //MARK: Perlu delegate ke luar
        var userBalance: Int = Int(Prefs.getUser()?.balance ?? 0)
        self.delegate?.didAstrapayCellReloaded(userBalance: userBalance)
        self.viewModel.initVM(content: content, userBalance:  userBalance)

    }
    func setupProtocol(){
        self.viewModel.delegate = self
    }
    //MARK: 2 fungsi ini dipake di QRPLMCDetailPaymentView, bukan disini
    func showSeletedPaymentImage() {
        self.selectedPaymentImage.isHidden = false
    }

    func hiddenSelectedPaymentImage() {
        self.selectedPaymentImage.isHidden = true
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupProtocol()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension QRDetailPaymentTVCellAstrapay{


}
extension QRDetailPaymentTVCellAstrapay: QRDetailPaymentTVCellAstrapayViewModelProtocol {
    func didUserBalanceIsNotEnoughCompareToAmount(){
        DispatchQueue.main.async(execute: {
            self.informationLabel.text = "Saldo tidak cukup"
            self.informationLabel.textColor = QRBaseColor.red
            self.selectedPaymentImage.isHidden = true
            self.isUserInteractionEnabled = false
        })

    }
    func didUserBalanceIsEnoughCompareToAmount(){
        DispatchQueue.main.async {
            self.informationLabel.isHidden = true
            self.selectedPaymentImage.isHidden = false
            self.isUserInteractionEnabled = true
        }
    }
}

