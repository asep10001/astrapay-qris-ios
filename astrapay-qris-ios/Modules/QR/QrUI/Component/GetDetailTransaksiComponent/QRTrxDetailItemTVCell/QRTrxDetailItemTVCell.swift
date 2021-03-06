//
//  QRTrxDetailItemTVCell.swift
//  astrapay
//
//  Created by Guntur Budi on 23/02/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit

struct ContentDetailPayload {
    var title: String = ""
    var content: String = ""
}

protocol QRTrxDetailItemTVCellViewProtocol {
    var contentTrxDetail : ContentDetailPayload {get}
}

struct QRTrxDetailItemTVCellPayload {
    var title: String = ""
    var content: String = ""
}

class QRTrxDetailItemTVCell: UITableViewCell {

    @IBOutlet weak var titleLabel: QRUILabelInterRegular!
    @IBOutlet weak var contentLabel: QRUILabelInterSemiBold!
    
    static let identifier = "QRTrxDetailItemTVCellIdentifier"
    static let nibName = "QRTrxDetailItemTVCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView(payload: ContentDetailPayload) {
        self.titleLabel.text = payload.title
        self.contentLabel.text = payload.content
        self.selectionStyle = .none
        self.titleLabel.font = UIFont.setupFont(size: 16, fontType: .interRegular)
        self.titleLabel.textColor = BaseColor.Properties.blackColor
        self.contentLabel.font = UIFont.setupFont(size: 16, fontType: .interSemiBold)
        self.contentLabel.textColor = BaseColor.Properties.blackColor
        self.contentLabel.lineBreakMode = .byWordWrapping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
