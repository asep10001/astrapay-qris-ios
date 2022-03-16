//
//  NominalTransactionTvCell.swift
//  astrapay
//
//  Created by antonius krisna sahadewa on 11/10/20.
//  Copyright © 2020 Tirta Rivaldi. All rights reserved.
//

import UIKit

struct QRNominalTransactionCellPayload{
    var jumlahNominal : Int
}

class QRNominalTransactionTvCell: UITableViewCell {
    @IBOutlet weak var lbJumlahNominalTransaction: QRUILabelInterMedium!
    
    static let identifier = "qRNominalTvCellIdentifier"
    static let nibName = "QRNominalTransactionTvCell"
    static let heightOfCell : CGFloat = 100

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(payloadView : QRNominalTransactionCellPayload){
        lbJumlahNominalTransaction.text = payloadView.jumlahNominal.toIDRQR(withSymbol: true)
    }
    
}
