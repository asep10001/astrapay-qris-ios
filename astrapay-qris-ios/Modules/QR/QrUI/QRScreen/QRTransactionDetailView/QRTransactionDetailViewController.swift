//
//  QRTransactionDetailVC.swift
//  astrapay
//
//  Created by Sandy Chandra on 24/06/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit

class QRTransactionDetailViewController: UIViewController {

    @IBOutlet weak var detailTransactionTV: UITableView!
    @IBOutlet weak var bagikanButton: QRAPButtonAtom!
    @IBOutlet weak var buttonContainer: UIView!
    
    struct VCProperty {
        static let navigationTitle: String = "Lihat Detail Transaksi"
    }


    var viewModel: QRTransactionDetailViewModel?


    var productNameDetail: String?
    
    var detailModels: QRAPTransactionDetailPopupModel?
    var timeRequestValue: String = ""
    var isPaylater : Bool = false


    var qrNewRouter: QRNewRouter?



    struct QRPayloadViewProperty{
        var amount : Int?
        var qrGetDetailTransaksiByIdDtoViewData: QRGetDetailTransaksiByIdDtoViewData?
    }
    var qrPayload = QRPayloadViewProperty()
    func initQRPayload(payload : QRPayloadViewProperty){
        self.qrPayload = payload

        self.viewModel = QRTransactionDetailViewModel(qrGetDetailTransaksiByIdDtoViewData: self.qrPayload.qrGetDetailTransaksiByIdDtoViewData)

    }


    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.setupNavigation(theme: .normal, title: VCProperty.navigationTitle, navigator: .back, navigatorCallback: nil)
        self.removeBorderNavigationQR()
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
        self.buttonContainer.addShadowQR(cornerRadius: 0, position: .Top)
    }

    func setupRouter(){

    }
    
    func setupAction() {
        self.bagikanButton.coreButton.addTapGestureRecognizerQR(action: {
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
        
        let nibA = UINib(nibName: QRTransactionDetailTopTVCell.nibName, bundle: nil)
        self.detailTransactionTV.register(nibA, forCellReuseIdentifier: QRTransactionDetailTopTVCell.identifier)
        
        let nibB = UINib(nibName: QRTransactionDetailMiddleTVCell.nibName, bundle: nil)
        self.detailTransactionTV.register(nibB, forCellReuseIdentifier: QRTransactionDetailMiddleTVCell.identifier)
        
        let nibC = UINib(nibName: QRTransactionDetailBottomTVCell.nibName, bundle: nil)
        self.detailTransactionTV.register(nibC, forCellReuseIdentifier: QRTransactionDetailBottomTVCell.identifier)
    }
    

}

extension QRTransactionDetailViewController: UITableViewDelegate, UITableViewDataSource {
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

extension QRTransactionDetailViewController {
    func setupTopCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QRTransactionDetailTopTVCell.identifier, for: indexPath) as? QRTransactionDetailTopTVCell else {
            return UITableViewCell()
        }
        cell.setupCell(payload: QRTransactionDetailTopTVCellPayload(
                        title: self.productNameDetail ?? "",
                        amount: "- \(self.detailModels?.valueTotal ?? "")",
                        date: self.timeRequestValue,
                        status: self.detailModels?.stateTrasactions ?? ""))
        cell.selectionStyle = .none
        return cell
    }
    
    func setupMiddleCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QRTransactionDetailMiddleTVCell.identifier, for: indexPath) as? QRTransactionDetailMiddleTVCell else {
            return UITableViewCell()
        }
        let qrTransactionDetailTVCellViewPayload: QRTransactionDetailMiddleTVCellViewPayload = QRTransactionDetailMiddleTVCellViewPayload(detailTransaction: self.detailModels?.detailTrasaksi)
        cell.setupCell(payload: qrTransactionDetailTVCellViewPayload)
        cell.selectionStyle = .none
        return cell
    }
    
    func setupBottomCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QRTransactionDetailBottomTVCell.identifier, for: indexPath) as? QRTransactionDetailBottomTVCell else {
            return UITableViewCell()
        }
        cell.setupCell(payload: QRTransactionDetailBottomTVCellPayload(
                        valueTotal: self.detailModels?.resultTotal ?? "",
                        isPaylater: self.isPaylater))
        cell.selectionStyle = .none
        return cell
    }
}

extension QRTransactionDetailViewController {
    
    func setModels() {

            self.productNameDetail = "Pembayaran Merchant"
            let noTransaksi = self.viewModel?.qrGetDetailTransaksiByIdDtoViewData?.transactionNumber ?? "-"
            let customerId = self.viewModel?.qrGetDetailTransaksiByIdDtoViewData?.refCustomerPan ?? "-"

            // noref perlu di isi apa?
            let noReff = self.viewModel?.qrGetDetailTransaksiByIdDtoViewData?.reconcileCode ?? "-"


            let idMerchant = self.viewModel?.qrGetDetailTransaksiByIdDtoViewData?.merchantPanFromTransactionHasAcquirer ?? "-"
            let kodeMerchant = String(self.viewModel?.qrGetDetailTransaksiByIdDtoViewData?.merchantQrID ?? 0) ?? "-"
            let namaMerchant =  self.viewModel?.qrGetDetailTransaksiByIdDtoViewData?.merchantName ?? "-"
            let lokasiMerchant = self.viewModel?.qrGetDetailTransaksiByIdDtoViewData?.merchantCity ?? "-"
            let idTerminal = self.viewModel?.qrGetDetailTransaksiByIdDtoViewData?.terminalLabel ?? "-"
            let nominal = "\(self.viewModel?.qrGetDetailTransaksiByIdDtoViewData?.basicPrice ?? 0)"
            let totalBayar = "\(self.viewModel?.qrGetDetailTransaksiByIdDtoViewData?.totalPrice ?? 0)"
            self.detailModels = QRAPTransactionDetailPopupModel(
            nameImages: "",
            titles: "Pembayaran Merchant",
            contents: self.viewModel?.qrGetDetailTransaksiByIdDtoViewData?.createdAt ?? "-",
            stateTrasactions: self.viewModel?.statusTransaction ?? "Dalam Proses",
            detailTrasaksi:
            [
                QRDetailTransaksi(titles: "Item Barang", values: "Pembayaran Merchant"),
                QRDetailTransaksi(titles: "No.Transaksi", values: noTransaksi),
                //comment temporary veda test
                QRDetailTransaksi(titles: "ID Customer", values: customerId),
                //DetailTrasaksi(titles: "ID Customer", values: "93600822081310821143"),
                QRDetailTransaksi(titles: "No.Referensi", values: noReff),
                QRDetailTransaksi(titles: "ID Merchant", values: idMerchant),
                QRDetailTransaksi(titles: "Kode Merchant", values: kodeMerchant),
                QRDetailTransaksi(titles: "Nama Merchant", values: namaMerchant),
                QRDetailTransaksi(titles: "Lokasi Merchant", values: lokasiMerchant),
                QRDetailTransaksi(titles: "ID Terminal", values: idTerminal),
                QRDetailTransaksi(titles: "Nominal Transaksi", values: self.viewModel?.nominalTransaction ?? "0")],
            valueTotal: self.viewModel?.valueTotal ?? "0",
            valueBalance: self.viewModel?.valueBalance ?? "0",
            resultTotal: self.viewModel?.resultTotal ?? "0")
    }

    //MARK: Convert date
    func convertDate(date: String) -> String {
        return DateFormatter.dateConvertQR(valueDate: date, from: .defaultListHistory, to: .ddMMyyyySlash, locale: .id)
    }


}
