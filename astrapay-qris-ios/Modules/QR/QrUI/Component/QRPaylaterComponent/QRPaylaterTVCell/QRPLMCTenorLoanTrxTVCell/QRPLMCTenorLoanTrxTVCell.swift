//
//  QRPLMCTenorLoanTrxTVCell.swift
//  astrapay
//
//  Created by Antonius on 15/04/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit

enum QRTenorEnum: String{
    case OneMonth = "30D"
    case ThreeMonth = "3M"
    case SixMonth = "6M"
    case TwelveMonth = "12M"
}

protocol QRPLMCTenorLoanTrxTVCellProtocol {
    func didSelectTenor(tenor: String)
    func didSelectQrisTenor(tenorTrx:QRTenorTrx)
}

struct QRPLMCTenorLoanTrxTVCellPayload {
    var arraySubTenor : [EligibleCheckResp] = []
}

struct QRPLMCQrisTenorLoanTrxTVCellPayload {
    var tenorLoanTrx : [QRTenorTrx] = []
    var istenorLoanTrx : Bool = false
}

class QRPLMCTenorLoanTrxTVCell: UITableViewCell {
    
    @IBOutlet weak var lblChooseMethodPayment: UILabelInterSemiBold!
    @IBOutlet weak var consHeightTenorPayment: NSLayoutConstraint!
    @IBOutlet weak var tbTenorTrxPLMC: UITableView!
    @IBOutlet weak var constraitHeightTbTenor: NSLayoutConstraint!
    
    static let nibName = "QRPLMCTenorLoanTrxTVCell"
    static let identifier = "QRPLMCTenorLoanTrxTVCellIdentifier"
    
    var plmcSubTenorLoanTVCell = QRPLMCSubTenorLoanTVCell()
    var arraySubTenor : [EligibleCheckResp] = []
    var aarTenorLoanTrx : [QRTenorTrx] = []
    var delegate : QRPLMCTenorLoanTrxTVCellProtocol?
    var tenorCheck : String = ""
    var istenorLoanTrx : Bool = false
    
    func setupCicilanPerBulan(payload:QRPLMCTenorLoanTrxTVCellPayload) {
        self.arraySubTenor = payload.arraySubTenor
        self.constraitHeightTbTenor.constant = CGFloat(payload.arraySubTenor.count * 44)
        setupTableView()
    }
    
    func setupCicilanPerBulanQris(payload:QRPLMCQrisTenorLoanTrxTVCellPayload) {
        self.istenorLoanTrx = true
        self.aarTenorLoanTrx = payload.tenorLoanTrx
        self.constraitHeightTbTenor.constant = CGFloat(payload.tenorLoanTrx.count * 44)
        setupQrisTableView()
    }
    
    func setupTableView(){
        if arraySubTenor.count != 0 {
            self.lblChooseMethodPayment.isHidden = false
            self.consHeightTenorPayment.constant = CGFloat(25)
            self.tbTenorTrxPLMC.delegate = self
            self.tbTenorTrxPLMC.dataSource = self
            self.tbTenorTrxPLMC.separatorStyle = .none
            self.setupTableViewCell()
            self.tbTenorTrxPLMC.reloadData()
        } else {
            self.lblChooseMethodPayment.isHidden = true
            self.consHeightTenorPayment.constant = CGFloat(0)
        }
    }
    
    func setupQrisTableView(){
        if aarTenorLoanTrx.count != 0 {
            self.lblChooseMethodPayment.isHidden = false
            self.consHeightTenorPayment.constant = CGFloat(25)
            self.tbTenorTrxPLMC.delegate = self
            self.tbTenorTrxPLMC.dataSource = self
            self.tbTenorTrxPLMC.separatorStyle = .none
            self.setupTableViewCell()
            self.tbTenorTrxPLMC.reloadData()
        } else {
            self.lblChooseMethodPayment.isHidden = true
            self.consHeightTenorPayment.constant = CGFloat(0)
        }
    }
    
    func setupTableViewCell(){
        let nib = UINib(nibName: QRPLMCSubTenorLoanTVCell.nibName, bundle: nil)
        self.tbTenorTrxPLMC.register(nib, forCellReuseIdentifier: QRPLMCSubTenorLoanTVCell.identifier)
    }
    
    func setupSubTenor(tableView : UITableView, indexPath : IndexPath) -> UITableViewCell{
        
        self.plmcSubTenorLoanTVCell = tableView.dequeueReusableCell(withIdentifier: QRPLMCSubTenorLoanTVCell.identifier, for: indexPath) as! QRPLMCSubTenorLoanTVCell
        
        if istenorLoanTrx {
            let tenorLoanTrx = self.aarTenorLoanTrx[indexPath.row]
            if tenorCheck != "" {
                var content : QRPLMCSubTenorLoanPayload = QRPLMCSubTenorLoanPayload(isCheckButton: true, idTenor: tenorLoanTrx.valueTenor ?? "30D", lblTenor:self.setStringTenor(tenorString: tenorLoanTrx.valueTenor ?? "", maxLimit: tenorLoanTrx.maxLimit ?? 0))
                plmcSubTenorLoanTVCell.setupSubLoanTVCell(payload: content)
            } else {
                var content : QRPLMCSubTenorLoanPayload = QRPLMCSubTenorLoanPayload(isCheckButton: false, idTenor: tenorLoanTrx.valueTenor ?? "30D", lblTenor:self.setStringTenor(tenorString: tenorLoanTrx.valueTenor ?? "", maxLimit: tenorLoanTrx.maxLimit ?? 0))
                plmcSubTenorLoanTVCell.setupSubLoanTVCell(payload: content)
            }
            
        } else {
            let arraySubTenor = self.arraySubTenor[indexPath.row]
            if tenorCheck != "" {
                if arraySubTenor.tenor == tenorCheck {
                    var content : QRPLMCSubTenorLoanPayload = QRPLMCSubTenorLoanPayload(
                        isCheckButton:true,
                        idTenor: arraySubTenor.tenor ?? "",
                        lblTenor: self.setStringTenor(tenorString: arraySubTenor.tenor ?? "", maxLimit: arraySubTenor.maxLimit ?? 0))
                    plmcSubTenorLoanTVCell.setupSubLoanTVCell(payload: content)
                } else {
                    var content : QRPLMCSubTenorLoanPayload = QRPLMCSubTenorLoanPayload(
                        isCheckButton:false,
                        idTenor: arraySubTenor.tenor ?? "",
                        lblTenor: self.setStringTenor(tenorString: arraySubTenor.tenor ?? "", maxLimit: arraySubTenor.maxLimit ?? 0))
                    plmcSubTenorLoanTVCell.setupSubLoanTVCell(payload: content)
                }
            } else {
                var content : QRPLMCSubTenorLoanPayload = QRPLMCSubTenorLoanPayload(
                    isCheckButton:false,
                    idTenor: arraySubTenor.tenor ?? "",
                    lblTenor: self.setStringTenor(tenorString: arraySubTenor.tenor ?? "", maxLimit: arraySubTenor.maxLimit ?? 0))
                plmcSubTenorLoanTVCell.setupSubLoanTVCell(payload: content)
            }
        }
        plmcSubTenorLoanTVCell.delegate = self
        plmcSubTenorLoanTVCell.selectionStyle = .none
        return plmcSubTenorLoanTVCell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension QRPLMCTenorLoanTrxTVCell {
    func settenorTrx(tenor:String) -> QRTenorTrx {
        let mockTenorTrx :QRTenorTrx = QRTenorTrx(
            tenor: "Sekali Bayar",
            valueTenor: "30D",
            maxLimit: 0,
            dueDate: "",
            totalAmount: 0,
            adminFee: 0,
            totalLoan: 0,
            loanPerMonth: 0)
        let tenorTrx = aarTenorLoanTrx.first(where: {$0.valueTenor == tenor}) ?? mockTenorTrx
        return tenorTrx
    }
    
    func makeLblTenor(tenor:String) -> String {
        if tenor == QRTenorEnum.OneMonth.rawValue {
            return "Sekali Bayar"
        } else if tenor == QRTenorEnum.ThreeMonth.rawValue {
            return "3 Bulan"
        } else if tenor == QRTenorEnum.SixMonth.rawValue {
            return "6 Bulan"
        } else if tenor == QRTenorEnum.TwelveMonth.rawValue {
            return "12 Bulan"
        } else {
            return tenor
        }
    }
    
    func setStringTenor(tenorString: String, maxLimit: Int) -> String {
        var tenor : String = ""
        var limit : String = ""
        
        if maxLimit > 0 {
            limit = " - Limit " + maxLimit.toIDR()!
        }
        
        if tenorString == "30D" {
            tenor = "Sekali Bayar "
        } else {
            if tenorString.contains("D") {
                tenor = "Cicilan " + tenorString.replacingOccurrences(of: "D", with: " Hari")
            } else if tenorString.contains("M") {
                tenor = "Cicilan " + tenorString.replacingOccurrences(of: "M", with: " Bulan")
            } else if tenorString.contains("Y") {
                tenor = "Cicilan " + tenorString.replacingOccurrences(of: "Y", with: " Tahun")
            }
        }
        return tenor + limit
    }
}

extension QRPLMCTenorLoanTrxTVCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        istenorLoanTrx ? self.aarTenorLoanTrx.count : self.arraySubTenor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.setupSubTenor(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension QRPLMCTenorLoanTrxTVCell : QRPLMCSubTenorLoanTVCellProtocol {
    func didPressSubTenor(idTenor: String) {
        self.tenorCheck = idTenor
        tbTenorTrxPLMC.reloadData()
        if istenorLoanTrx {
            self.delegate?.didSelectQrisTenor(tenorTrx:settenorTrx(tenor: idTenor))
        } else {
            self.delegate?.didSelectTenor(tenor: idTenor)
        }
    }
}

