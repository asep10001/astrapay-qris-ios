//
//  PLMCDetailPaymentView.swift
//  astrapay
//
//  Created by Sandy Chandra on 08/03/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit

protocol QRSelectPaymentViewProtocol {
    func didSelectPayment(index: Int, selectedImageFromAstrapay: Bool, selectedImageFromPLMC: Bool)
    func didSelectAktifkan()


    func isPaylaterSelected(isPaylater: Bool)
    func isTipsMoreThanZero() -> Bool

    func didAstrapayCellReloaded(userBalance: Int)
}

struct QRSelectPaymentViewPayload {
    var paymentImageName: String = ""
    var paymentName: String = ""
    var paymentBalance: String = ""
    var isUseInformation: Bool = false
    var isStatusRegister: Bool = true
    var statusRegisterPLMC: String = ""
    var information: String = ""
    var qrInquiryDtoViewData: QRInquiryDtoViewData?
    var basicPrice: Int?
    var amountTransaction: Int?
}

struct QRPLMCDetailPaymentViewPayload {
    var content: [QRSelectPaymentViewPayload]
}

@IBDesignable
class QRSelectPaymentView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var paymentListTV: UITableView!
    @IBOutlet weak var separatorView: UIView!

    var viewModel: QRPLMCDetailPaymentViewModel = QRPLMCDetailPaymentViewModel()

    var qrDetailPaymentAstrapay: QRDetailPaymentTVCellAstrapay?
    var qrDetailPaymentPLMC: QRDetailPaymentTVCellPLMC?


    var delegate: QRSelectPaymentViewProtocol?


    var contentView: [QRSelectPaymentViewPayload] = []
    
    var currentSelectedRow: Int = 0

    static var count = 0
    
    struct ViewProperty{
        static let identifier : String = "QRPLMCDetailPaymentViewIdentifier"
        static let nibName = "QRPLMCDetailPaymentView"
    }
    
    func setupView(content: [QRSelectPaymentViewPayload], title: String = "Detail Pembayaran") {
        QRSelectPaymentView.count = QRSelectPaymentView.count + 1

        self.contentView = content
        
        self.titleLabel.text = title
        self.titleLabel.font = UIFont.font(size: 16, fontType: .interSemiBold)
        self.separatorView.backgroundColor = BaseColor.separatorView

        self.setupTableView()

    }
    
    func setupTableView() {
        let nibPaylater = UINib(nibName: QRDetailPaymentTVCellPLMC.nibName, bundle: nil)
        let nibAstrapay = UINib(nibName: QRDetailPaymentTVCellAstrapay.nibName, bundle: nil)

        //paylater
        self.paymentListTV.register(nibPaylater, forCellReuseIdentifier: QRDetailPaymentTVCellPLMC.identifier)

        //astrapay
        self.paymentListTV.register(nibAstrapay, forCellReuseIdentifier: QRDetailPaymentTVCellAstrapay.identifier)
        
        self.paymentListTV.separatorStyle = .none
        self.paymentListTV.bounces = false
        self.paymentListTV.isScrollEnabled = false
        self.paymentListTV.delegate = self
        self.paymentListTV.dataSource = self
        self.paymentListTV.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetupQR(nibName: QRSelectPaymentView.ViewProperty.nibName)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetupQR(nibName: QRSelectPaymentView.ViewProperty.nibName)
    }

    override func awakeFromNib() {
        xibSetupQR(nibName: QRSelectPaymentView.ViewProperty.nibName)
    }


    
}
extension QRSelectPaymentView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return self.setupAstrapayCell(tableView, cellForRowAt: indexPath)
        case 1:
            return self.setupPaylaterCell(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.row {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedImageFromAstrapay: Bool = false
        var selectedImageFromPLMC: Bool = false


        var row = indexPath.row
        switch indexPath.row {
        case 0:
           var cell = tableView.cellForRow(at: indexPath) as! QRDetailPaymentTVCellAstrapay
            cell.showSeletedPaymentImage()
            self.delegate?.isPaylaterSelected(isPaylater: false)

            break
        case 1:
            var cell = tableView.cellForRow(at: indexPath) as! QRDetailPaymentTVCellPLMC
            cell.showSeletedPaymentImage()
            self.viewModel.cellAstrapay?.hiddenSelectedPaymentImage()
            self.delegate?.isPaylaterSelected(isPaylater: true)
            break
        default:
            return
        }
            self.delegate?.didSelectPayment(index: indexPath.row, selectedImageFromAstrapay: selectedImageFromAstrapay, selectedImageFromPLMC: selectedImageFromPLMC)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            var cell = tableView.cellForRow(at: indexPath) as! QRDetailPaymentTVCellAstrapay
            self.delegate?.isPaylaterSelected(isPaylater: true)
            cell.hiddenSelectedPaymentImage()
            break
        case 1:
            var cell = tableView.cellForRow(at: indexPath) as! QRDetailPaymentTVCellPLMC
            self.delegate?.isPaylaterSelected(isPaylater: false)
            cell.hiddenSelectedPaymentImage()

            break
        default:
            return
        }
    }

//        cell.showSeletedPaymentImage()
//
//        let cell = paymentListTV.cellForRow(at: indexPath) as! QRPLMCDetailPaymentTVCell
//        if self.contentView[indexPath.row].isStatusRegister {
//            cell.showSeletedPaymentImage()
//            self.delegate?.didSelectPayment(index: indexPath.row)
//        }
}



// Setup cell
extension QRSelectPaymentView {
    func setupAstrapayCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: QRDetailPaymentTVCellAstrapay.identifier, for: indexPath) as! QRDetailPaymentTVCellAstrapay
        self.qrDetailPaymentAstrapay = cell
        self.viewModel.cellAstrapay = cell
        cell.delegate = self
        cell.setupView(content: self.contentView[indexPath.row])
        cell.showSeletedPaymentImage()

        if self.contentView[indexPath.row].statusRegisterPLMC == "Aktifkan" {

            //MARK: ini harus bagaimana untuk didSelectAktifkan ?
            self.delegate?.didSelectAktifkan()

        }

//        if contentView.count == 1 {
//            cell.showSeletedPaymentImage()
//        }

        return cell
    }


    //MARK: ini harusnya dibikin logic karena untuk awal awal dikirim payload (self.contenView) nya cuma satu doang
    func setupPaylaterCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: QRDetailPaymentTVCellPLMC.identifier, for: indexPath) as! QRDetailPaymentTVCellPLMC
        self.qrDetailPaymentPLMC = cell
        self.viewModel.cellPLMC = cell
        cell.setupView(content: self.contentView[indexPath.row])
        cell.layer.masksToBounds = true

        if self.contentView[indexPath.row].statusRegisterPLMC == "Aktifkan" {

            //MARK: ini harus bagaimana untuk didSelectAktifkan ?
            self.delegate?.didSelectAktifkan()

        }

//        if contentView.count == 1 {
//            cell.showSeletedPaymentImage()
//        }

        return cell
    }

}

extension QRSelectPaymentView: QRDetailPaymentTVCellAstrapayProtocol {
    func didAstrapayCellReloaded(userBalance: Int){
       self.delegate?.didAstrapayCellReloaded(userBalance: userBalance)
    }
}
