//
//  QRAPTransactionDetailVC.swift
//  astrapay
//
//  Created by Nur Irfan Pangestu on 11/04/20.
//  Copyright © 2020 Tirta Rivaldi. All rights reserved.
//

import UIKit

class QRAPTransactionDetailVC: UIViewController {

    var onDismissTapped: ((Bool, String) -> Void)?
    var onRemoveView: ((Bool) -> Void)?
    @IBOutlet weak var vwSuperContainer: UIView!

    @IBOutlet weak var vwSwipe: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var vwBtnShare: APButtonAtom!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwContainerDetailPayment: UIView!

    var productName: String?
    var productNameDetail: String?

    var phoneNo: String = "-"
    var orderNo: String = "-"
    var admin: String = "-"
    var biayaLayanan: String = "-"
    var jumlahTagihan: String = "-"
    var totalRepayment: String = "-"

    var detailModels: QRAPTransactionDetailPopupModel?
    var lastRow: Int?
    var timeRequestValue: String = ""
    var titleTotalBayar: String = "Total Bayar"
    var titleDetailBayar: String = "Detail Pembayaran"
    var isPaylater: Bool = false

    let vm = Global.locator.transaction
    let api = Global.locator


    struct QRPayloadViewProperty {
        var qrNotes : String?
        var merchantResponse : QRPaymentMerchantResponse?
        var inquiryResponse : QRPaymentInquiryModelResponse?
        var qRPaymentOTPModelResponse : QRPaymentOTPModelResponse?
        var paymentResponse : QRPaymentPayModelResponse?
        var amount : Int?
        var qrisPaymentResponse : QRISPaymentResp?
    }

    var qrPayload = QRPayloadViewProperty()

    func initQRPayload(payload: QRPayloadViewProperty) {
        self.qrPayload = payload
    }


    func initQRISPayload(payload: QRPayloadViewProperty) {
        self.qrPayload = payload
    }


    override func viewDidLayoutSubviews() {
        self.vwSwipe.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //        bug fix pangesture
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureAct))
        self.vwSuperContainer.addGestureRecognizer(gesture)

        self.setHideKeyboardWhenTappedAround()
        self.setUIs()
        self.setModels()
        self.setTableViews()
        self.setValidations()
        self.setActions()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.moveView(state: .full)
    }

    private func setUIs() {
        self.vwBtnShare.setAtomic(type: .nude, title: "Share")
    }

    private func setModels() {
        var nameOfImages = ""


        // MARK:- QR Payment
//        if productName == MainQRVC.VCProperty.route {
//            nameOfImages = "hist_ic_qr_square"
//            self.productNameDetail = self.qrPayload.paymentResponse?.itemBarang ?? "-"
//        }

        if productName == MainQRVC.VCProperty.routeQRIS {
            nameOfImages = "hist_ic_qr_square"
            self.productNameDetail = "Pembayaran Merchant"
        }

        // MARK:- QRIS Payment
        if productName == MainQRVC.VCProperty.routeQRIS {
            nameOfImages = "hist_ic_qris_square"
        }

        if productName == "RepaymentPLMC" {
            self.productNameDetail = "Paylater"
        }


//        if productName == MainQRVC.VCProperty.routeQRIS {
//            let noTransaksi = self.qrPayload.qrisPaymentResponse?.transaction_number ?? "-"
//            let customerId = self.qrPayload.qrisPaymentResponse?.customer_pan ?? "-"
//            let noReff = self.qrPayload.qrisPaymentResponse?.reff_id ?? "-"
//            let idMerchant = self.qrPayload.qrisPaymentResponse?.merchant_pan ?? "-"
//            let kodeMerchant = self.qrPayload.qrisPaymentResponse?.merchant_id ?? "-"
//            let namaMerchant = self.qrPayload.qrisPaymentResponse?.merchant_name ?? "-"
//            let lokasiMerchant = self.qrPayload.qrisPaymentResponse?.merchant_city ?? "-"
//            let idTerminal = self.qrPayload.qrisPaymentResponse?.terminal_id ?? "-"
//            let nominal = "\(self.qrPayload.qrisPaymentResponse?.total_amount ?? 0)"
//            let totalBayar = "\(self.qrPayload.qrisPaymentResponse?.total_amount ?? 0)"
//            self.detailModels = APTransactionDetailPopupModel(
//                    nameImages: nameOfImages,
//                    titles: "Pembayaran Merchant",
//                    contents: self.qrPayload.inquiryResponse?.dateTrx ?? "-",
//                    stateTrasactions: self.setStatusTransaction(code: ""),
//                    detailTrasaksi:
//                    [
//                        //comment temporary veda test
//                        DetailTrasaksi(titles: "ID Customer", values: customerId),
//                        //DetailTrasaksi(titles: "ID Customer", values: "93600822081310821143"),
//                        DetailTrasaksi(titles: "No.Referensi", values: noReff),
//                        DetailTrasaksi(titles: "Item Barang", values: "Pembayaran Merchant"),
//                        DetailTrasaksi(titles: "No.Transaksi", values: noTransaksi),
//                        DetailTrasaksi(titles: "ID Merchant", values: idMerchant),
//                        DetailTrasaksi(titles: "Kode Merchant", values: kodeMerchant),
//                        DetailTrasaksi(titles: "Nama Merchant", values: namaMerchant),
//                        DetailTrasaksi(titles: "Lokasi Merchant", values: lokasiMerchant),
//                        DetailTrasaksi(titles: "ID Terminal", values: idTerminal),
//                        DetailTrasaksi(titles: "Nominal Transaksi", values: self.valueIDR(value: nominal))],
//                    valueTotal: self.valueIDR(value: totalBayar),
//                    valueBalance: self.valueIDR(value: totalBayar),
//                    resultTotal: self.valueIDR(value: totalBayar))
//        }
    }


        private func setTableViews() {
            let nibA = UINib(nibName: "APHeaderTransactionDetailCell", bundle: nil)
            self.tableView.register(nibA, forCellReuseIdentifier: "APHeaderTransactionDetailCell")
            let nibB = UINib(nibName: "APDetailTransactionCell", bundle: nil)
            self.tableView.register(nibB, forCellReuseIdentifier: "APDetailTransactionCell")
            let nibC = UINib(nibName: "APDetailPaymentCell", bundle: nil)
            self.tableView.register(nibC, forCellReuseIdentifier: "APDetailPaymentCell")
            let nibD = UINib(nibName: "APTitleCell", bundle: nil)
            self.tableView.register(nibD, forCellReuseIdentifier: "APTitleCell")
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }

        private func setValidations() {

        }

        private func setActions() {
            let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(APTransactionDetailVC.closeGesture))
            view.addGestureRecognizer(gesture)

            self.vwBtnShare.coreButton.addTapGestureRecognizer {
                self.checkShareAppsFlyer()
                UIGraphicsBeginImageContext(self.vwContainerDetailPayment.frame.size)
                self.vwContainerDetailPayment.layer.render(in: UIGraphicsGetCurrentContext()!)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                var imagesToShare = [AnyObject]()
                imagesToShare.append(image as AnyObject)

                let activityViewController = UIActivityViewController(activityItems: imagesToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
            self.btnClose.addTapGestureRecognizer {
                self.onDismissTapped?(true, "")
            }
        }

        @objc func closeGesture(_ recognizer: UIPanGestureRecognizer) {

            let velocity = recognizer.velocity(in: self.view)

            if recognizer.state == .ended {
                if velocity.y >= 0 {
                    self.onDismissTapped?(true, "")
                }
            }
        }

        private func valueIDR(value: String?) -> String {
            var currentValue: String = value ?? "0"
            if value == nil {
                currentValue = "0"
            }
            if currentValue.contains(".,") {
                if !(currentValue.isEmpty) {
                    return QRAPFormatter.currency(number: Int(currentValue) ?? 0)
                } else {
                    return "Rp -"
                }
            } else {
                if !(currentValue.isEmpty) {
                    let feeTotal = Double(currentValue) ?? 0.0
                    let feeResult = Int(feeTotal)
                    return QRAPFormatter.currency(number: feeResult)
                } else {
                    return "Rp -"
                }
            }
            return "-"
        }

        func detailTransactionCell(cell: APDetailTransactionCell, index: Int) -> UITableViewCell {
            let resultIndex = index - 2
            if (self.detailModels?.detailTrasaksi.count)! > resultIndex {
                cell.setCells(titles: (self.detailModels?.detailTrasaksi[resultIndex].titles)!, values: (self.detailModels?.detailTrasaksi[resultIndex].values)!)
            }
            return cell
        }

        private func setStatusTransaction(code: String) -> String {
            switch self.productName {
            case MainQRVC.VCProperty.route:
                return "Berhasil"
            case MainQRVC.VCProperty.routeQRIS:
                return "Berhasil"
            case MainAltoCashoutVC.VCProperty.routeAlto:
                return "Berhasil"
            default:
                if code == "000" {
                    return "Berhasil"
                } else if code == "001" {
                    return "Gagal"
                } else {
                    return "Dalam Proses"
                }
            }
        }


        //MARK: BIAYA ADMIN
        func biayaAdmin(value: String) -> String {
            let conditionsBiayaAdmin = Validation.shared.validateEqual(condition1: value ?? "0", condition2: "0")
            if !conditionsBiayaAdmin {
                return valueIDR(value: value ?? "0")
            }
            return "GRATIS"
        }

    }



extension QRAPTransactionDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.lastRow = 1 + (self.detailModels?.detailTrasaksi.count)! + 1 + 1
        return self.lastRow ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "APHeaderTransactionDetailCell", for: indexPath) as! APHeaderTransactionDetailCell
            
            if self.productName == "ACC" {
                cell.setCells(titles: self.productNameDetail ?? "", values: self.timeRequestValue, stateTransactions: self.detailModels?.stateTrasactions ?? "Dalam Proses", nameOfImage: self.detailModels?.nameImages ?? "")
            }else if (self.productName == MainQRVC.VCProperty.route){
                cell.setCells(titles: self.productNameDetail ?? "", values: self.qrPayload.paymentResponse?.dateTrx ?? "-", stateTransactions: "Berhasil", nameOfImage: self.detailModels?.nameImages ?? "")
            }else if (self.productName == MainQRVC.VCProperty.routeQRIS){
                cell.setCells(titles: self.productNameDetail ?? "", values: self.qrPayload.qrisPaymentResponse?.transaction_date ?? "-", stateTransactions: "Berhasil", nameOfImage: self.detailModels?.nameImages ?? "")
            }else if self.productName == "PBB"{
                cell.setCells(titles: self.productNameDetail ?? "", values: self.timeRequestValue, stateTransactions: self.detailModels?.stateTrasactions ?? "Dalam Proses", nameOfImage: self.detailModels?.nameImages ?? "")
            }else {
                cell.setCells(titles: self.productNameDetail ?? "", values: self.timeRequestValue, stateTransactions: self.detailModels?.stateTrasactions ?? "Dalam Proses", nameOfImage: self.detailModels?.nameImages ?? "")
            }
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "APTitleCell", for: indexPath) as! APTitleCell
            cell.setTitleCell(title: "Detail Transaksi")
            return cell
        } else if indexPath.row + 1 == self.lastRow ?? 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "APDetailPaymentCell", for: indexPath) as! APDetailPaymentCell
            cell.setCells(valueTotal: self.detailModels?.valueTotal,
                          valueResultTotal: self.detailModels?.resultTotal,
                          titleTotal: self.titleTotalBayar,
                          titleDetail: self.titleDetailBayar,
                          isPaylater: self.isPaylater)
            cell.setVerticalAstrapayLabel()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "APDetailTransactionCell", for: indexPath) as! APDetailTransactionCell
            return self.detailTransactionCell(cell: cell, index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80 + 24
        } else if indexPath.row == 1 {
            return 24 + 8
        } else if indexPath.row + 1 == self.lastRow ?? 0 {
            return 150
        } else {
            return UITableView.automaticDimension
        }
        
    }
    
}




extension QRAPTransactionDetailVC {
    private enum State {
        case full
        case close
    }
    
    private enum Constant {
        static var fullViewYPosition: CGFloat { UIScreen.main.bounds.height - UIScreen.main.bounds.height*0.9 }
        static var closeViewYPosition: CGFloat { UIScreen.main.bounds.height - 0 }
    }
}


//Pan Gesture Controller
extension QRAPTransactionDetailVC {
    private func checkShareAppsFlyer(){
        switch productName {
        case "PHPRE":
            AppsFlyerConfig.postEventValueEventNil(event: .billPulsaPraBayarShareClicked)
        case "PHPOST":
            AppsFlyerConfig.postEventValueEventNil(event: .billPulsaPascaBayarShareClicked)
        case "PAKETDATA":
            AppsFlyerConfig.postEventValueEventNil(event: .billDataPackageShareClicked)
        case "PDAM":
            AppsFlyerConfig.postEventValueEventNil(event: .billPdamShareButtonClicked)
        case "TV":
            AppsFlyerConfig.postEventValueEventNil(event: .billTvShareClicked)
        case "TELKOM":
            AppsFlyerConfig.postEventValueEventNil(event: .billTelkomShareButtonClicked)
        case "PLN Token":
            AppsFlyerConfig.postEventValueEventNil(event: .billPlnTokenShareClicked)
        case "PLNPOST":
            AppsFlyerConfig.postEventValueEventNil(event: .billPlnTagihanShareClicked)
        case "FIFGROUP":
            AppsFlyerConfig.postEventValueEventNil(event: .billFifShareClicked)
        case "BPJS":
            AppsFlyerConfig.postEventValueEventNil(event: .billBpjsShareClicked)
        case "ACC":
            AppsFlyerConfig.postEventValueEventNil(event: .billAccShareClicked)
        default:
            print("back to home bill payment")
        }
    }
    
    private func moveView(state: State) {
        let yPosition = state == .full ? Constant.fullViewYPosition : Constant.closeViewYPosition
        view.frame = CGRect(x: 0, y: yPosition, width: view.frame.width, height: view.frame.height)
        
        if state == .full {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let minY = view.frame.minY
        
        if (minY + translation.y > Constant.fullViewYPosition) {
            view.frame = CGRect(x: 0, y: minY + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    @objc private func panGestureAct(_ recognizer: UIPanGestureRecognizer) {
        moveView(panGestureRecognizer: recognizer)
        
        let minY = view.frame.minY
        
        if recognizer.state == .ended {
            if minY >= 555 {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction], animations: {
                    self.view.endEditing(true)
                    self.moveView(state: .close)
                    self.onRemoveView?(true)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction], animations: {
                    self.moveView(state: .full)
                    
                }, completion: nil)
            }
        }
    }
    
}
