//
//  PLMCBillDetailPaymentTVCell.swift
//  astrapay
//
//  Created by Sandy Chandra on 09/03/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit


//MARK: namanya harusnya ga boleh ada plmc nya ini
class QRPLMCBillDetailPaymentTVCell: UITableViewCell {
    
    static let nibName = "QRPLMCBillDetailPaymentTVCell"
    static let identifier = "QRPLMCBillDetailPaymentTVCellIdentifier"
    
    let nameSelectedImage: String = ""
    
    let contentPayment = QRSelectPaymentView()
    
    func setupView(content: [QRSelectPaymentViewPayload]) {

        self.contentPayment.setupView(content: content)
        self.contentPayment.frame = CGRect(x: 0, y: 0, width: Int(self.contentView.frame.width), height: Int(self.contentView.frame.height * 2))
        self.contentView.addSubview(self.contentPayment)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
