//
//  QRPLMCDetailLoanTVCell.swift
//  astrapay
//
//  Created by Antonius on 05/03/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit


class QRPLMCDetailLoanTVCell: UITableViewCell {
    
    static let nibName = "QRPLMCDetailLoanTVCell"
    static let identifier = "QRPLMCDetailLoanTVCellIdentifier"
    
    func setupDetailLoan(payload: QRPLMCDetailLoanTrxViewPayload) {
        let detailLoan = QRPLMCDetailLoanTrxView()
        detailLoan.setupView(payload: payload)
        detailLoan.frame = CGRect(x: 0, y: 0, width: Int(self.contentView.frame.width), height: Int(self.contentView.frame.height))
        self.contentView.addSubview(detailLoan)
    }
    
    func setupMetodeBayar() {
        
    }
    
    func setupCicilanPerBulan() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
