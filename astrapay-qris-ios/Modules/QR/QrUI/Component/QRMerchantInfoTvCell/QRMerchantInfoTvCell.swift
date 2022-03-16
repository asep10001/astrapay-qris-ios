//
//  UserInfoTvCell.swift
//  astrapay
//
//  Created by antonius krisna sahadewa on 11/10/20.
//  Copyright © 2020 Tirta Rivaldi. All rights reserved.
//

import UIKit

struct QRMerchantInfoCellPayload{
    var nameMerchant : String
    var lokasi  : String
    var isUseDate : Bool = false
    var isBuyTo : Bool = false
    var date : String
}

class QRMerchantInfoTvCell: UITableViewCell {
    @IBOutlet weak var ivLabelOutlet: UIImageView!
    @IBOutlet weak var lblImageNameMerchant: UILabel!
    @IBOutlet weak var lbMerchantNameOutlet: UILabelInterSemiBold!
    @IBOutlet weak var lbLokasiMerchantOutlet: UILabelInterRegular!
    @IBOutlet weak var lblDateTransactionOutlet: UILabelInterRegular!
    @IBOutlet weak var lblBuyToOutlet: UILabelInterSemiBold!
    @IBOutlet weak var viewBuyToOutlet: UIView!
    
    static let identifier = "qRMerchantInfoTvCellIdentifier"
    static let nibName = "QRMerchantInfoTvCell"
    static let heightOfCell : CGFloat = 150
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(payloadView : QRMerchantInfoCellPayload){
        self.setLabelImage(nameMerchant: payloadView.nameMerchant)
        self.lbMerchantNameOutlet.text = payloadView.nameMerchant
        self.lbLokasiMerchantOutlet.text = payloadView.lokasi
        setDate(isTag: payloadView.isUseDate, date: payloadView.date)
        setIsBuyTo(isBuyTO: payloadView.isBuyTo)
    }
    
    func setLabelImage(nameMerchant:String){
        lblImageNameMerchant.text = setName(nameMerchant: nameMerchant)
        lblImageNameMerchant.textColor = .white
        lblImageNameMerchant.font = UIFont.setupFont(size: 38, fontType: .interBold)
        lblImageNameMerchant.textAlignment = .center
        lblImageNameMerchant.clipsToBounds = true
        setRoundIV()
    }
    
    func setDate(isTag:Bool, date:String){
        if isTag {
            lblDateTransactionOutlet.isHidden = false
            lblDateTransactionOutlet.text = date
        } else {
            lblDateTransactionOutlet.isHidden = true
        }
    }
    
    func setIsBuyTo(isBuyTO:Bool){
        if isBuyTO {
            viewBuyToOutlet.isHidden = false
        } else {
            viewBuyToOutlet.isHidden = true
        }
    }
}

extension QRMerchantInfoTvCell {
    func setName(nameMerchant:String) -> String {
        if nameMerchant != "" {
            return "\(nameMerchant.first ?? "-")"
        } else {
            return "-"
        }
    }
    
    func setRoundIV(){
        self.ivLabelOutlet.roundCorners(value: self.ivLabelOutlet.frame.height / 2)
        self.ivLabelOutlet.backgroundColor = BaseColor.Properties.baseColor
    }
}
