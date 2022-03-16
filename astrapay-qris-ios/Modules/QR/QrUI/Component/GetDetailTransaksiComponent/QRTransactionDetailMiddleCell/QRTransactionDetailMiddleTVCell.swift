//
//  QRTransactionDetailMiddleTVCell.swift
//  astrapay
//
//  Created by Guntur Budi on 11/02/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit

protocol QRTransactionDetailMiddleTVCellViewProtocol {
    var qrTrxDetailTVCellViewPayload: QRTransactionDetailMiddleTVCellViewPayload {get}
}

struct QRTransactionDetailMiddleTVCellViewPayload {
    var detailTransaction : [QRDetailTransaksi]?
}

class QRTransactionDetailMiddleTVCell: UITableViewCell {
    
    @IBOutlet weak var contentTV: UITableView!
    @IBOutlet weak var constHeightOfTV: NSLayoutConstraint!
    
    static let identifier = "QRTransactionDetailMiddleTVCellIdentifier"
    static let nibName = "QRTransactionDetailMiddleTVCell"
    
    var contentTransaction = QRTrxDetailItemTVCell()
    var payload = QRTransactionDetailMiddleTVCellViewPayload()
    var lastRow: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension QRTransactionDetailMiddleTVCell {
    func setupCell(payload: QRTransactionDetailMiddleTVCellViewPayload) {
        if payload.detailTransaction?.count != 0 {
            self.setupTableViewCell()
            self.payload = payload
            self.contentTV.bounces = false
            self.contentTV.delegate = self
            self.contentTV.dataSource = self
            self.contentTV.isScrollEnabled = false
            self.contentTV.separatorStyle = .singleLine
            self.constHeightOfTV.constant = CGFloat(50 * (self.payload.detailTransaction?.count ?? 0))
        }
    }
}

extension QRTransactionDetailMiddleTVCell {
    func setupTableViewCell(){
        let nibContentTransaction = UINib(nibName: QRTrxDetailItemTVCell.nibName, bundle: nil)
        self.contentTV.register(nibContentTransaction, forCellReuseIdentifier: QRTrxDetailItemTVCell.identifier)
    }

    func detailTransactionCell(cell: QRTrxDetailItemTVCell, index: Int) -> UITableViewCell {
        if (self.payload.detailTransaction!.count) > index {
            cell.setupView(payload: ContentDetailPayload(
                            title: self.payload.detailTransaction?[index].titles ?? "-",
                            content: self.payload.detailTransaction?[index].values ?? "-"))
            return cell
        } else {
            cell.setupView(payload: ContentDetailPayload(title: "-", content: "-"))
            return cell
        }
    }
}

extension QRTransactionDetailMiddleTVCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.payload.detailTransaction?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.contentTransaction = tableView.dequeueReusableCell(withIdentifier: QRTrxDetailItemTVCell.identifier, for: indexPath) as! QRTrxDetailItemTVCell
        return self.detailTransactionCell(cell: contentTransaction, index: indexPath.row)
    }
}
