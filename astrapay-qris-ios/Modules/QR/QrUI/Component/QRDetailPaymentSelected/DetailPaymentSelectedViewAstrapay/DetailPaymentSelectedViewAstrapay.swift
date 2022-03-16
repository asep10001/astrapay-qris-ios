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
class DetailPaymentSelectedViewAstrapay: UIView {

    @IBOutlet weak var paymentImage: UIImageView!
    @IBOutlet weak var paymentName: UILabel!
    @IBOutlet weak var balanceText: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var saldoTidakCukup: UILabel!
    

    static let nibName = "DetailPaymentSelectedViewAstrapay"
    static let identifier = "DetailPaymentSelectedViewAstrapayIdentifier"

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
        xibSetupQR(nibName: DetailPaymentSelectedViewAstrapay.nibName)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetupQR(nibName: DetailPaymentSelectedViewAstrapay.nibName)
    }

    override func awakeFromNib() {
        xibSetupQR(nibName: DetailPaymentSelectedViewAstrapay.nibName)
    }
    
}
