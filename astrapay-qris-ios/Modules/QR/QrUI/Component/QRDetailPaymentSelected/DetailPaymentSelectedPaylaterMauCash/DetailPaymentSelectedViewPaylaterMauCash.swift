//
//  DetailPaymentSelectedViewAstrapay.swift
//  astrapay
//
//  Created by Gilbert on 22/12/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import Foundation
import UIKit

//ini adalah cell (ceritanya)
class DetailPaymentSelectedViewPaylaterMauCash: UIView {

    @IBOutlet weak var paymentImage: UIImageView!
    @IBOutlet weak var paymentName: UILabel!
    @IBOutlet weak var balanceText: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var saldoTidakCukup: UILabel!
    @IBOutlet weak var poweredByMauCash: UILabel!
    @IBOutlet weak var limitTidakCukup: UILabel!
    

    static let nibName = "DetailPaymentSelectedViewPaylaterMauCash"
    static let identifier = "DetailPaymentSelectedViewPaylaterMauCashIdentifier"

    let statusAktifkan : String = "AKTIFKAN"
    let statusProses : String = "PROSES"
    let statusReject : String = "DITOLAK"
    let statusBlock : String = "TERBLOKIR"
    let statusErr : String = "Err..."
    let textColorDisable : String = "#949494"
    let boderColorDisable : String = "#e7eaf3"

    let nameSelectedImage: String = "ic_check"

    func setupView(content: PLMCDetailPaymentTVCellPayload) {
        self.paymentName.text = "ASTRAPAY"
        self.balanceText.text = content.paymentBalance
        self.checkImage.image = UIImage(named: self.nameSelectedImage)
        self.containerView.roundCorners(value: 10)
        self.containerView.layer.borderWidth = 1

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetupQR(nibName: DetailPaymentSelectedViewPaylaterMauCash.nibName)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetupQR(nibName: DetailPaymentSelectedViewPaylaterMauCash.nibName)
    }

    override func awakeFromNib() {
        xibSetupQR(nibName: DetailPaymentSelectedViewPaylaterMauCash.nibName)
    }
    
}

//MARK: edit label
extension DetailPaymentSelectedViewPaylaterMauCash {
    func setupLabel(){
        
    }
    
    
}
