//
//  QRPLMCSubTenorLoanTVCell.swift
//  astrapay
//
//  Created by Antonius on 09/05/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit
import Foundation

protocol QRPLMCSubTenorLoanTVCellProtocol : class{
    func didPressSubTenor(idTenor:String)
}

struct QRPLMCSubTenorLoanPayload {
    var isCheckButton : Bool = false
    var idTenor : String = ""
    var lblTenor : String = ""
}

class QRPLMCSubTenorLoanTVCell: UITableViewCell {
    
    @IBOutlet weak var ivCheckButton: UIImageView!
    @IBOutlet weak var lblTenorPLMC: UILabelInterRegular!
    @IBOutlet weak var butonTenorPLMC: QRAPButtonAtom!

    static let nibName = "QRPLMCSubTenorLoanTVCell"
    static let identifier = "QRPLMCSubTenorLoanTVCellIdentifier"
    
    let imageOnCheck : UIImage = UIImage(named:"ic_tenor_checklist") ?? UIImage()
    let imageOffCheck : UIImage = UIImage(named:"ic_tenor_no_checklist") ?? UIImage()
    var delegate : QRPLMCSubTenorLoanTVCellProtocol?
    
    func setupSubLoanTVCell(payload:QRPLMCSubTenorLoanPayload) {
        
        self.lblTenorPLMC.text = payload.lblTenor
        
        if payload.isCheckButton {
            self.ivCheckButton.image = self.imageOnCheck
        } else {
            self.ivCheckButton.image = self.imageOffCheck
        }
        
        self.butonTenorPLMC.coreButton.addTapGestureRecognizer{
            if self.ivCheckButton.image == self.imageOnCheck {
                self.ivCheckButton.image = self.imageOffCheck
                self.delegate?.didPressSubTenor(idTenor: "")
            } else {
                self.ivCheckButton.image = self.imageOnCheck
                self.delegate?.didPressSubTenor(idTenor: payload.idTenor)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
