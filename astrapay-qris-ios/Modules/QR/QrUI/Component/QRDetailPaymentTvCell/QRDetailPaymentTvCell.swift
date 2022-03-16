//
//  DetailPaymentTvCell.swift
//  astrapay
//
//  Created by antonius krisna sahadewa on 11/10/20.
//  Copyright © 2020 Tirta Rivaldi. All rights reserved.
//

import UIKit

struct QRDetailPaymentCellPayload{
    var balance : String
    var totalPayment : String
    
}

class QRDetailPaymentTvCell: UITableViewCell {
    @IBOutlet weak var ivDetailPayment: UIImageView!
    @IBOutlet weak var lblNameDetailPayment: UILabelInterSemiBold!
    @IBOutlet weak var lblSaldoDetailPayment: UILabelInterRegular!
    @IBOutlet weak var lblValueTotalDetailPayment: UILabelInterSemiBold!
    
    static let identifier = "qRDetailPaymentTvCellIdentifier"
    static let nibName = "QRDetailPaymentTvCell"
    static let heightOfCell : CGFloat = 200
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(payloadView : QRDetailPaymentCellPayload){
        lblSaldoDetailPayment.text = payloadView.balance
        lblValueTotalDetailPayment.text = payloadView.totalPayment
    }
    
}
