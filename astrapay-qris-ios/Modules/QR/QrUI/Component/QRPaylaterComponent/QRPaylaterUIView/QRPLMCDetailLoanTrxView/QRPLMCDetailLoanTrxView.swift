//
//  QRPLMCDetailLoanTrxView.swift
//  astrapay
//
//  Created by Sandy Chandra on 16/03/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit

struct QRPLMCDetailLoanTrxViewPayload {
    var typeQR : Bool = false
    var tenor: String = "-"
    var jatuhTempo: String = "-"
    var jumlahPinjaman: Int = 0
    var biayaLayanan: Int = 0
    var cicilan: Int = 0
}

class QRPLMCDetailLoanTrxView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tenorLabel: UILabel!
    @IBOutlet weak var tenorValueLabel: UILabel!
    @IBOutlet weak var jatuhTempoLabel: UILabel!
    @IBOutlet weak var jatuhTempoValueLabel: UILabel!
    @IBOutlet weak var jumlahPinjamLabel: UILabel!
    @IBOutlet weak var jumlahPinjamValueLabel: UILabel!
    @IBOutlet weak var biayaLayananLabel: UILabel!
    @IBOutlet weak var biayaLayananValueLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var cicilanLabel: UILabel!
    @IBOutlet weak var cicilanValueLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    struct ViewProperty{
        static let identifier : String = "QRPLMCDetailLoanTrxViewIdentifier"
        static let nibName = "QRPLMCDetailLoanTrxView"
        
        static let titleText: String = "Rincian Pinjaman"
        static let tenorText: String = "Tenor"
        static let jatuhTempoText: String = "Jatuh Tempo"
        static let jumlahPinjamanText: String = "Jumlah Pinjaman"
        static let biayaLayananText: String = "Biaya Layanan"
        static let totalText: String = "Total Bayar"
        static let cicilanPerBulan: String = "Cicilan PerBulan"
    }
    
    func setupView(payload: QRPLMCDetailLoanTrxViewPayload) {
        self.titleLabel.text = ViewProperty.titleText
        self.tenorLabel.text = ViewProperty.tenorText
        self.jatuhTempoLabel.text = ViewProperty.jatuhTempoText
        self.jumlahPinjamLabel.text = ViewProperty.jumlahPinjamanText
        self.biayaLayananLabel.text = ViewProperty.biayaLayananText
        self.totalLabel.text = ViewProperty.totalText
        self.cicilanLabel.text = ViewProperty.cicilanPerBulan
        self.cicilanLabel.isHidden = payload.typeQR
        
        self.tenorValueLabel.text = payload.tenor
        self.jatuhTempoValueLabel.text = payload.jatuhTempo
        self.jumlahPinjamValueLabel.text = payload.jumlahPinjaman.toIDR()
        self.biayaLayananValueLabel.text = payload.biayaLayanan.toIDR()
        self.totalValueLabel.text = (payload.jumlahPinjaman + payload.biayaLayanan).toIDR()
        self.cicilanValueLabel.text = payload.cicilan.toIDR()
        self.cicilanValueLabel.isHidden = payload.typeQR
        
        self.titleLabel.font = UIFont.font(size: 16, fontType: .interSemiBold)
        self.tenorLabel.font = UIFont.font(size: 14, fontType: .interSemiBold)
        self.jatuhTempoLabel.font = UIFont.font(size: 14, fontType: .interSemiBold)
        self.jumlahPinjamLabel.font = UIFont.font(size: 14, fontType: .interSemiBold)
        self.biayaLayananLabel.font = UIFont.font(size: 14, fontType: .interSemiBold)
        self.totalLabel.font = UIFont.font(size: 14, fontType: .interSemiBold)
        self.cicilanLabel.font = UIFont.font(size: 14, fontType: .interSemiBold)
        
        self.tenorValueLabel.font = UIFont.font(size: 14, fontType: .interRegular)
        self.jatuhTempoValueLabel.font = UIFont.font(size: 14, fontType: .interRegular)
        self.jumlahPinjamValueLabel.font = UIFont.font(size: 14, fontType: .interRegular)
        self.biayaLayananValueLabel.font = UIFont.font(size: 14, fontType: .interRegular)
        self.totalValueLabel.font = UIFont.font(size: 14, fontType: .interSemiBold)
        self.cicilanValueLabel.font = UIFont.font(size: 14, fontType: .interSemiBold)
        
        self.separatorView.backgroundColor = BaseColor.baseBorderColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetupQR(nibName: QRPLMCDetailLoanTrxView.ViewProperty.nibName)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetupQR(nibName: QRPLMCDetailLoanTrxView.ViewProperty.nibName)
    }

    override func awakeFromNib() {
        xibSetupQR(nibName: QRPLMCDetailLoanTrxView.ViewProperty.nibName)
    }

}
