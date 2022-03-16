//
//  QRTransactionDetailBottomTVCell.swift
//  astrapay
//
//  Created by Nivedita Gupta on 20/01/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit

protocol QRTransactionDetailBottomTVCellDelegate: class {
    func didTapShareButton()
}

protocol QRTransactionDetailBottomTVCellProtocol {
    var trxDetailBottomTVCellPayload : QRTransactionDetailBottomTVCellPayload { get }
}

struct QRTransactionDetailBottomTVCellPayload {
//    var amountAstraku : Double
//    var amountAstrapay : Double
//    var direction : String
    var valueTotal : String = ""
    var titleDetail : String = "Detail Pembayaran"
    var isPaylater: Bool = false
    var isAddSaldo: Bool = false
}

class QRTransactionDetailBottomTVCell: UITableViewCell {

    @IBOutlet weak var paymentIcon: UIImageView!
    @IBOutlet weak var paymentName: UILabel!
    @IBOutlet weak var amount: UILabel!
    //    @IBOutlet weak var astrapayBalanceView: AstrapayPaymentInfo!
//    @IBOutlet weak var astrakuPointPreview: AstrakuPointPreview!
    @IBOutlet weak var lineView: UIView!
    
    static let identifier = "QRTransactionDetailBottomTVCellIdentifier"
    static let nibName = "QRTransactionDetailBottomTVCell"
    
    weak var cellDelegate: QRTransactionDetailBottomTVCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.astrapayBalanceView.xibSetup(nibName: AstrapayPaymentInfo.nibName)
//        self.astrakuPointPreview.xibSetup(nibName: AstrakuPointPreview.nibName)
    }
    
    func setupCell(payload: QRTransactionDetailBottomTVCellPayload) {
        self.amount.text = "\(payload.valueTotal)"
        if payload.isPaylater {
            self.paymentIcon.image = UIImage(named: "ic_PLMC")
            self.paymentName.text = "PayLater"
        } else {
            self.paymentIcon.image = UIImage(named: "main_icon_small")
            self.paymentName.text = "AstraPay"
        }
    }

//    func setupCell(payload : TransactionDetailBottomTVCellPayload){
//
//        if astrakuPointPreview != nil && astrapayBalanceView != nil {
//
//            self.astrapayBalanceView.setupView(direction: payload.direction, amountIDR: payload.amountAstrapay.toIDR() ?? "0")
//            self.astrakuPointPreview.setupView(amount: payload.amountAstraku.toIDR(withSymbol: false, isCommaSeparator: true) ?? "0")
//
//            if payload.amountAstraku == 0 {
//                self.lineView.removeFromSuperview()
//                self.astrakuPointPreview.removeFromSuperview()
//            }else if payload.amountAstrapay == 0 {
//                self.lineView.removeFromSuperview()
//                self.astrapayBalanceView.removeFromSuperview()
//            }
//        }
//    }
    
 
}
    
