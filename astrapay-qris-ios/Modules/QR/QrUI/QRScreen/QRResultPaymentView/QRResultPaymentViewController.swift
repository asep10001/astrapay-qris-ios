//
//  ReskinAPResultPaymentVC.swift
//  astrapay
//
//  Created by Sandy Chandra on 20/06/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit
import Lottie

protocol QRResultPaymentViewControllerProtocol{
    func didGoBackToHome()
}

struct QRResultPaymentViewControllerPayload {
    var merchantName: String?
    var dateTrx: String?
    var nominalTransaksi: Double?
    
}

class QRResultPaymentViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var topButton: QRAPButtonAtom!
    @IBOutlet weak var bottomButton: QRAPButtonAtom!
    @IBOutlet weak var additionalInfoView: UIView!
    @IBOutlet weak var additionalTitle: UILabel!
    @IBOutlet weak var additionalMerchant: UILabel!
    @IBOutlet weak var additionalDate: UILabel!
    
    @IBOutlet weak var lottieAnimationView: LottieAnimationView!

    var delegateSdk: QRResultPaymentViewControllerProtocol?


    var productName: String?
    var productNameDetail: String?
//    var titleScreen: String = ""
    var timeRequestValue: String = ""
    var isErrorPayment: Bool = false
    var otp: String = ""
    var errorMessage: String = ""
    var totalPayment: String = "0.00"
    var isPaylater : Bool = false
    var isAlto: Bool = false
    var lblDate = ""

    var qrNewRouter: QRNewRouter?

    let viewModel = QRResultPaymentViewModel()


    struct QRPayloadViewProperty{
        var qrGetDetailTransaksiByIdDtoViewData: QRGetDetailTransaksiByIdDtoViewData?
    }
    
    var qrPayload = QRPayloadViewProperty()

    func initQRPayload(payload : QRPayloadViewProperty, isPaylater: Bool = false){
        self.qrPayload = payload
        let qrResultPaymentViewModelPayload = QRResultPaymentViewModelPayload(qrGetDetailTransaksiByIdDtoViewData: payload.qrGetDetailTransaksiByIdDtoViewData)
        self.viewModel.initVM(qrResultPaymentViewModelPayload: qrResultPaymentViewModelPayload)
        self.isPaylater = isPaylater
    }

    
//    let vm = Global.locator.transaction
//    let api = Global.locator
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.additionalInfoView.isHidden = true

        self.setupProtocol()
        self.setupUI()


        self.setActions()
        self.setupQRRouter()
    }

    func setupQRRouter(){
        self.qrNewRouter = QRNewRouter(viewController: self)
    }

    func setupProtocol(){
        self.viewModel.delegate = self
    }

    func setupUI(){
        self.viewModel.setupUILogic()
    }
    
    private func printLog() {
        print("\(self.errorMessage)")
    }
    
    private func setUIsError() {
//        self.vwContainerBalance.isHidden = true
        self.lottieAnimationView.setupAnimation(animation: .failedTrx)
        
        self.titleLabel.text = "Mohon Maaf"
        self.titleLabel.font = UIFont.setupFont(size: 24, fontType: .interSemiBold)
        self.titleLabel.textColor = QRBaseColor.QRProperties.baseColor
        self.subTitleLabel.text = "Pembayaran gagal.\nCoba lagi ya nanti."
        
//        self.lblDate.text = self.setTimeTrxId()
//        self.lblPayment.text = "Rp -"
        self.imageView.image = UIImage(named: "illustration_failed")
        self.topButton.setAtomic(type: .filled, title: "COBA LAGI")
//        self.vwBtnTransactionDetail.setAtomic(type: .nude, title: "Retry")
//        self.vwBtnBackToHome.setAtomic(title: "Back to Home")
        self.bottomButton.setAtomic(type: .nude, title: "KEMBALI KE BERANDA")
    }
    
    private func setUIsSuccess() {
        
        self.lottieAnimationView.setupAnimation(animation: .successTrx)
        
        self.imageView.image = UIImage(named: "illustration_success")
        self.titleLabel.text = "Terima Kasih"
        self.titleLabel.font = UIFont.setupFont(size: 24, fontType: .interSemiBold)
        self.titleLabel.textColor = QRBaseColor.QRProperties.baseColor
        
        
        //MARK: pindahin ke qr module buat extensio extension
        self.additionalTitle.text = "Pembayaran ke"
        self.additionalTitle.font = UIFont.setupFont(size: 16, fontType: .interRegular)
        self.additionalMerchant.font = UIFont.setupFont(size: 20, fontType: .interSemiBold)
        self.additionalDate.font = UIFont.setupFont(size: 12, fontType: .interRegular)
        self.additionalInfoView.backgroundColor = QRBaseColor.greyInfo
        
        let phoneNumber = viewModel.qrResultPaymentViewModelPayload?.qrGetDetailTransaksiByIdDtoViewData?.phoneNumberFromTransactionIssuer ?? ""
        let trxId = viewModel.qrResultPaymentViewModelPayload?.qrGetDetailTransaksiByIdDtoViewData?.transactionNumber ?? ""

        var totals = ""
         self.lblDate = self.timeRequestValue


            self.additionalInfoView.isHidden = false
            self.additionalDate.text = self.qrPayload.qrGetDetailTransaksiByIdDtoViewData?.createdAt ?? "-"
            self.additionalMerchant.text = self.qrPayload.qrGetDetailTransaksiByIdDtoViewData?.merchantName ?? "-"
            self.lblDate = self.qrPayload.qrGetDetailTransaksiByIdDtoViewData?.createdAt ?? "-"
            totals = self.valueIDR(value: "\(Int(self.qrPayload.qrGetDetailTransaksiByIdDtoViewData?.totalPrice ?? 0))")




//        self.purchaseCompleteMoEngage(trxId: trxId, orderDate: timeRequestValue)
//        self.lblPayment.text = totals
        self.bottomButton.setAtomic(type: .nude, title: "LIHAT DETAIL TRANSAKSI")
        self.topButton.setAtomic(title: "KEMBALI KE BERANDA")

        let normalText = "Transaksi sebesar "
        let boldText  = "\(totals)"
        var attributedString = NSMutableAttributedString(string:normalText)
        let attrs = [NSAttributedString.Key.font : UIFont.setupFont(size: 16, fontType: .interSemiBold)]
        let boldString = NSMutableAttributedString(string: boldText, attributes:attrs)
        attributedString.append(boldString)
            
        if isPaylater {
            attributedString.append(NSMutableAttributedString(string: "\nmenggunakan Paylater telah berhasil."))
            self.subTitleLabel.attributedText = attributedString
        } else {
            attributedString.append(NSMutableAttributedString(string: "\nmenggunakan saldo AstraPay telah berhasil."))
            self.subTitleLabel.attributedText = attributedString
        }
        
    }
    private func setActions() {

        self.viewModel.setupButtonLogic()
    }

    
    private func valueIDR(value: String) -> String {
        if value.contains(".,") {
            if !(value.isEmpty) {
                return QRAPFormatter.currency(number: Int(value) ?? 0)
            } else {
                return "Rp -"
            }
        } else {
            if !(value.isEmpty) {
                let feeTotal = Double(value ) ?? 0.0
                let feeResult = Int(feeTotal)
                return QRAPFormatter.currency(number: feeResult)
            } else {
                return "Rp -"
            }
        }
        return "-"
    }
    
    private func setTimeTrxId() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.timeRequestValue = dateFormatter.string(from: Date())
        
        return self.timeRequestValue
    }
    
}


//MARK: implement QRResultPaymentViewModelProtocol
extension QRResultPaymentViewController: QRResultPaymentViewModelProtocol {
    func didTransactionStatusSuccess(){
        setUIsSuccess()
    }
    func didTransactionStatusVoid(){
        setUIsError()
    }


    func buttonSetupForTransactionSuccess(){

        self.topButton.coreButton.addTapGestureRecognizer {
            //MARK: perlu dibikin delegate
            self.delegateSdk?.didGoBackToHome()
            AppState.switchToHome(completion: nil)
        }


        //MARK: ini kalo kita click Lihat Detail Transaksi
        self.bottomButton.coreButton.addTapGestureRecognizer {
            guard let qrGetDetailTransaksiByIdDtoViewData = self.qrPayload.qrGetDetailTransaksiByIdDtoViewData else {
                return
            }

            self.qrNewRouter?.navigateToGetDetailTransaksi(qrGetDetailTransaksiByIdDtoViewData: qrGetDetailTransaksiByIdDtoViewData, isPaylater: self.isPaylater)
        }

    }
    func buttonSetupForTransactionFailed(){
        self.topButton.coreButton.addTapGestureRecognizer {
            DispatchQueue.main.async {
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: QRViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }
        self.bottomButton.coreButton.addTapGestureRecognizer {

            //MARK: Perlu dibikin delegate
            self.delegateSdk?.didGoBackToHome()
            AppState.switchToHome(completion: nil)
        }
    }
}

