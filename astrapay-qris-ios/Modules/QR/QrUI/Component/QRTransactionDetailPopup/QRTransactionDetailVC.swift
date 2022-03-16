//
//  QRTransactionDetailVC.swift
//  astrapay
//
//  Created by Sandy Chandra on 24/06/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit

class QRTransactionDetailVC: UIViewController {

    @IBOutlet weak var detailTransactionTV: UITableView!
    @IBOutlet weak var bagikanButton: APButtonAtom!
    @IBOutlet weak var buttonContainer: UIView!

    struct VCProperty {
        static let storyBoardName : String = "Transaction"
        static let identifierVC : String = "TransactionDetailVCIdentifier"
        static let navigationTitle: String = "Lihat Detail Transaksi"
    }

    static let storyboardName = VCProperty.storyBoardName
    static let identifierVC = VCProperty.identifierVC

    var model: CheckBillerResponse?
    var modelPayment: PaymentBillerResponse?
    var productName: String?
    var productNameDetail: String?

    var detailModels: APTransactionDetailPopupModel?
    var lastRow: Int?
    var timeRequestValue: String = ""
    var titleTotalBayar: String = "Total Bayar"
    var titleDetailBayar: String = "Detail Pembayaran"
    var isPaylater : Bool = false

    let vm = Global.locator.transaction
    let api = Global.locator


    struct QRPayloadViewProperty{
        var qrNotes : String?
        var merchantResponse : QRPaymentMerchantResponse?
        var inquiryResponse : QRPaymentInquiryModelResponse?
        var qRPaymentOTPModelResponse : QRPaymentOTPModelResponse?
        var paymentResponse : QRPaymentPayModelResponse?
        var amount : Int?
        var qrisPaymentResponse : QRISPaymentResp?
    }
    var qrPayload = QRPayloadViewProperty()
    func initQRPayload(payload : QRPayloadViewProperty){
        self.qrPayload = payload
    }


    func initQRISPayload(payload : QRPayloadViewProperty){
        self.qrPayload = payload
    }


    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.setTextNavigation(theme: .normal, title: VCProperty.navigationTitle, navigator: .back, navigatorCallback: nil)
        self.removeBorderNavigation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupTableView()
        self.setupAction()
        self.setModels()
    }

    func setupUI() {
        self.bagikanButton.setAtomic(type: .filled, title: "BAGIKAN")
        self.buttonContainer.addShadow(cornerRadius: 0, position: .Top)
    }

    func setupAction() {
        self.bagikanButton.coreButton.addTapGestureRecognizer(action: {
            UIGraphicsBeginImageContext(self.view.frame.size)
            self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            var imagesToShare = [AnyObject]()
            imagesToShare.append(image as AnyObject)

            let activityViewController = UIActivityViewController(activityItems: imagesToShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        })
    }

    func setupTableView() {
        self.detailTransactionTV.dataSource = self
        self.detailTransactionTV.delegate = self
        self.detailTransactionTV.separatorStyle = .none

        let nibA = UINib(nibName: TransactionDetailTopTVCell.nibName, bundle: nil)
        self.detailTransactionTV.register(nibA, forCellReuseIdentifier: TransactionDetailTopTVCell.identifier)

        let nibB = UINib(nibName: QRTransactionDetailMiddleTVCell.nibName, bundle: nil)
        self.detailTransactionTV.register(nibB, forCellReuseIdentifier: QRTransactionDetailMiddleTVCell.identifier)

        let nibC = UINib(nibName: TransactionDetailBottomTVCell.nibName, bundle: nil)
        self.detailTransactionTV.register(nibC, forCellReuseIdentifier: TransactionDetailBottomTVCell.identifier)
    }


}

extension QRTransactionDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return self.setupTopCell(tableView, cellForRowAt: indexPath)
        case 1:
            return self.setupMiddleCell(tableView, cellForRowAt: indexPath)
        case 2:
            return self.setupBottomCell(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return UITableView.automaticDimension
        case 2:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
}

extension QRTransactionDetailVC {
    func setupTopCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionDetailTopTVCell.identifier, for: indexPath) as? TransactionDetailTopTVCell else {
            return UITableViewCell()
        }
        cell.setupCell(payload: TransactionDetailTopTVCellPayload(
                        title: self.productNameDetail ?? "",
                        amount: "- \(self.detailModels?.valueTotal ?? "")",
                        date: self.timeRequestValue,
                        status: self.detailModels?.stateTrasactions ?? ""))
        cell.selectionStyle = .none
        return cell
    }

    func setupMiddleCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QRTransactionDetailMiddleTVCell.identifier, for: indexPath) as? TrxDetailTVCell else {
            return UITableViewCell()
        }
        cell.setupCell(payload: TrxDetailTVCellViewPayload(detailTransaction: self.detailModels?.detailTrasaksi))
        cell.selectionStyle = .none
        return cell
    }

    func setupBottomCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionDetailBottomTVCell.identifier, for: indexPath) as? TransactionDetailBottomTVCell else {
            return UITableViewCell()
        }
        cell.setupCell(payload: TransactionDetailBottomTVCellPayload(
                        valueTotal: self.detailModels?.resultTotal ?? "",
                        isPaylater: self.isPaylater))
        cell.selectionStyle = .none
        return cell
    }
}

extension QRTransactionDetailVC {

    func setModels() {

        if productName == MainQRVC.VCProperty.route {
            self.productNameDetail = "Pembayaran Merchant"
            let nominal = "\(self.qrPayload.paymentResponse?.nominalTransaksi ?? 0)"
            let totalBayar = "\(self.qrPayload.paymentResponse?.totalBayar ?? 0)"
            let namaMerchant =  self.qrPayload.paymentResponse?.namaMerchant ?? "-"

            var notesValue = "-"
            let conditionHaveNotes = self.qrPayload.qrNotes != nil && self.qrPayload.qrNotes != ""
            if conditionHaveNotes {
                notesValue = self.qrPayload.qrNotes ?? "-"
            }

            self.detailModels = APTransactionDetailPopupModel(
            nameImages: "",
            titles: "Pembayaran Merchant",
            contents: self.qrPayload.inquiryResponse?.dateTrx ?? "-",
            stateTrasactions: self.setStatusTransaction(code:""),
            detailTrasaksi:
            [DetailTrasaksi(titles: "Item Barang", values: "Pembayaran Merchant"),
             DetailTrasaksi(titles: "Kode Merchant", values: "\(self.qrPayload.paymentResponse?.kodeMerchant ?? "")"),
             DetailTrasaksi(titles: "Nama Merchant", values: namaMerchant),
             DetailTrasaksi(titles: "Nominal Transaksi", values: self.valueIDR(value: nominal)),
          //   DetailTrasaksi(titles: "Catatan", values: notesValue),
            ],
            valueTotal: self.valueIDR(value: totalBayar),
            valueBalance: self.valueIDR(value: totalBayar),
            resultTotal: self.valueIDR(value: totalBayar))
        }

        if productName == MainQRVC.VCProperty.routeQRIS {
            self.productNameDetail = "Pembayaran Merchant"
            let noTransaksi = self.qrPayload.qrisPaymentResponse?.transaction_number ?? "-"
            let customerId = self.qrPayload.qrisPaymentResponse?.customer_pan ?? "-"
            let noReff = self.qrPayload.qrisPaymentResponse?.reff_id ?? "-"
            let idMerchant = self.qrPayload.qrisPaymentResponse?.merchant_pan ?? "-"
            let kodeMerchant = self.qrPayload.qrisPaymentResponse?.merchant_id ?? "-"
            let namaMerchant =  self.qrPayload.qrisPaymentResponse?.merchant_name ?? "-"
            let lokasiMerchant = self.qrPayload.qrisPaymentResponse?.merchant_city ?? "-"
            let idTerminal = self.qrPayload.qrisPaymentResponse?.terminal_id ?? "-"
            let nominal = "\(self.qrPayload.qrisPaymentResponse?.total_amount ?? 0)"
            let totalBayar = "\(self.qrPayload.qrisPaymentResponse?.total_amount ?? 0)"
            self.detailModels = APTransactionDetailPopupModel(
            nameImages: "",
            titles: "Pembayaran Merchant",
            contents: self.qrPayload.inquiryResponse?.dateTrx ?? "-",
            stateTrasactions: self.setStatusTransaction(code:""),
            detailTrasaksi:
            [
                DetailTrasaksi(titles: "Item Barang", values: "Pembayaran Merchant"),
                DetailTrasaksi(titles: "No.Transaksi", values: noTransaksi),
                //comment temporary veda test
                DetailTrasaksi(titles: "ID Customer", values: customerId),
                //DetailTrasaksi(titles: "ID Customer", values: "93600822081310821143"),
                DetailTrasaksi(titles: "No.Referensi", values: noReff),
                DetailTrasaksi(titles: "ID Merchant", values: idMerchant),
                DetailTrasaksi(titles: "Kode Merchant", values: kodeMerchant),
                DetailTrasaksi(titles: "Nama Merchant", values: namaMerchant),
                DetailTrasaksi(titles: "Lokasi Merchant", values: lokasiMerchant),
                DetailTrasaksi(titles: "ID Terminal", values: idTerminal),
                DetailTrasaksi(titles: "Nominal Transaksi", values: self.valueIDR(value: nominal))],
            valueTotal: self.valueIDR(value: totalBayar),
            valueBalance: self.valueIDR(value: totalBayar),
            resultTotal: self.valueIDR(value: totalBayar))
        }


        if productName == "RepaymentPLMC" {
            self.productNameDetail = "Maucash"
        }

    }

    private func valueIDR(value: String?) -> String {
        var currentValue: String = value ?? "0"
        if value == nil {
            currentValue = "0"
        }
        if currentValue.contains(".,") {
            if !(currentValue.isEmpty) {
                return APFormatter.currency(number: Int(currentValue) ?? 0)
            } else {
                return "Rp -"
            }
        } else {
            if !(currentValue.isEmpty) {
                let feeTotal = Double(currentValue) ?? 0.0
                let feeResult = Int(feeTotal)
                return APFormatter.currency(number: feeResult)
            } else {
                return "Rp -"
            }
        }
        return "-"
    }

    private func setStatusTransaction (code : String) -> String{
        switch self.productName {
        case MainQRVC.VCProperty.route :
            return "Berhasil"
        case MainQRVC.VCProperty.routeQRIS :
            return "Berhasil"
        case MainAltoCashoutVC.VCProperty.routeAlto :
            return "Berhasil"
        default :
            if code == "000" {
                return "Berhasil"
            }else if code == "001" {
                return "Gagal"
            }else {
                return "Dalam Proses"
            }
        }
    }

    //MARK: Convert date
    func convertDate(date: String) -> String {
        return DateFormatter.dateConvert(valueDate: date, from: .defaultListHistory, to: .ddMMyyyySlash, locale: .id)
    }

    //MARK: TOTAL ANGSURAN
    func totalAngsuran() -> String {
        let tagihan : Double = Double(self.model?.taf?.taf?.tagihan ?? "0") ?? 0.0
        let penalty : Double = Double(self.model?.taf?.taf?.opTaf?.penalty ?? "0") ?? 0.0
        let total = tagihan + penalty
        return String(total)
//        return String((Float(from: modelPayment?.taf?.tagihan ?? 0)) + (Float(modelPayment?.taf?.opTaf?.penalty ?? "0") ?? 0))
    }

    //MARK: BIAYA ADMIN
    func biayaAdmin(value: String) -> String {
        let conditionsBiayaAdmin = Validation.shared.validateEqual(condition1: value ?? "0", condition2: "0")
        if !conditionsBiayaAdmin {
            return valueIDR(value: value ?? "0")
        }
        return "GRATIS"
    }

    //MARK: Hapus 0 di depan 'Angsuran ke'
    func angsuranKe() -> String {
        return String(Int(modelPayment?.taf?.period ?? "0") ?? 0)
    }
}
