//
//  QRPLMaucashQrisLoanTrxVC.swift
//  astrapay
//
//  Created by user on 22/12/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import Foundation
import UIKit

class QRPLMaucashQrisLoanTrxVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionButton: QRAPButtonAtom!
    @IBOutlet weak var buttonContainer: UIView!
    
    struct VCProperty{
        static let identifierVC : String = "QRPLMaucashQrisLoanTrxVCIdentifier"
        static let navigationTitle : String = "Bayar"
        static let checkBoxTitleFirst: String = "Saya setuju dengan "
        static let checkBoxTitleSecond: String = "Perjanjian Pinjaman"
        static let imageChecked = "login_checked_box"
        static let imageUnChecked = "login_uncheck_box"
        static let constantHeightPopUp = 370
        static let heightPopUpPin = 300
        static let heightPopUpOTP = 380
        static let imagePinName: String = "illustration_pin"


    }

    var router : QRPaylaterRouter?
    var qrNewRouter: QRNewRouter?
    var viewModel = QRPLMaucashQrisLoanTrxVM()
    var qrPopUpPin = QRPopUpPIN()
    var qrPopUpOtp = QRPopUpOTP()
    var qrPopUp = QRPopUp()
    var isCheckBoxChecked = false
    var heightKeyboard : CGFloat = 250
    
    override func viewWillAppear(_ animated: Bool) {
        self.setTextNavigation(theme: .normal, title: VCProperty.navigationTitle, navigator: .back, navigatorCallback: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stateLoading(state: .show)
        self.setupVM()
        self.setupView()
        self.setupAction()
        self.setupRouter()
        self.setupTableView()
        self.viewModel.getQrisTenorTrxPLMC()
    }

    public convenience init (qrPaylaterTransactionPayload: QRPaylaterTransactionPayload){
        self.init()
        self.viewModel = QRPLMaucashQrisLoanTrxVM(qrPaylaterTransactionPayload: qrPaylaterTransactionPayload)
    }
    func setupVM(){
        self.viewModel.delegate = self
        self.viewModel.setupUserData()
    }
    
    func setupView() {
        let attributeColor = [NSAttributedString.Key.foregroundColor: BaseColor.Properties.baseColor]
        let firstTitle = NSMutableAttributedString(string: VCProperty.checkBoxTitleFirst)
        let secondTitle = NSMutableAttributedString(string: VCProperty.checkBoxTitleSecond, attributes: attributeColor)
        firstTitle.append(secondTitle)
        actionButton.setAtomic(type: .disabled, title: "BAYAR")
        self.buttonContainer.addShadow(cornerRadius: 0, position: .Top)
    }
    
    func setupAction() {
        self.actionButton.coreButton.addTapGestureRecognizerQR{
            self.showPopUpPin()
        }
    }
    
    func setupRouter(){
        self.router = QRPaylaterRouter(viewController: self)
        self.qrNewRouter = QRNewRouter(viewController: self)
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        
        let nibC = UINib(nibName: QRPLMCDetailLoanTVCell.nibName, bundle: nil)
        self.tableView.register(nibC, forCellReuseIdentifier: QRPLMCDetailLoanTVCell.identifier)
        
        let nibTenor = UINib(nibName: QRPLMCTenorLoanTrxTVCell.nibName, bundle: nil)
        self.tableView.register(nibTenor, forCellReuseIdentifier: QRPLMCTenorLoanTrxTVCell.identifier)
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 44.0;
    }

    
}

extension QRPLMaucashQrisLoanTrxVC {
    func updateUI(){
        if self.viewModel.tenor != "" {
            self.actionButton.setAtomic(type: .filled, title: "BAYAR")
        }
    }
    
    func showPopUpPin(){
        self.qrPopUpPin.pinView.clear()
        self.qrPopUpPin.delegate = self
        self.qrPopUpPin.setupView()
        self.qrPopUpPin.setEditing()
        self.showPopUpBottomView(withView: self.qrPopUpPin, height: self.heightKeyboard + CGFloat(VCProperty.heightPopUpPin))
    }
}

extension QRPLMaucashQrisLoanTrxVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: QRPLMCTenorLoanTrxTVCell.identifier, for: indexPath) as! QRPLMCTenorLoanTrxTVCell
            cell.delegate = self
            cell.setupCicilanPerBulanQris(payload: viewModel.setQrisTenorLoanTrxPLMCPayload())
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: QRPLMCDetailLoanTVCell.identifier, for: indexPath) as! QRPLMCDetailLoanTVCell
            cell.setupDetailLoan(payload: viewModel.setQrisDetailLoanTrxPLMCPayload())
            return cell
        case 2:
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 300
        case 2:
            return 0
        default:
            return 0
        }
    }
}

//MARK: Hidden - Sandy
extension QRPLMaucashQrisLoanTrxVC {
    func showUpFailure(titleError : String){
         let popUpMessage = QRPopUpMessage()
        popUpMessage.setupMessage(title: titleError, withImage: UIImage(named: "illustration_rejected")!, withBtnTitle: "OK")
         popUpMessage.delegate = self
         self.showPopUpBottomView(withView: popUpMessage, height:CGFloat(VCProperty.constantHeightPopUp),isUseNavigationBar: true)
    }
}

extension QRPLMaucashQrisLoanTrxVC : QRPLMaucashQrisLoanTrxVMProtocol {

    //success yang masih tetap begini
    func didSuccesQrisTransactionsPLMC() {
        DispatchQueue.main.async {
            self.stateLoading(state: .dismiss)
//            self.router?.navigateToWebViewQrisTrx(urlLink: self.viewModel.respUrlTrx)
        }
    }



    func didFailureQrisTransactionsPLMC(err: String) {
        DispatchQueue.main.async {
            self.stateLoading(state: .dismiss)
            Alert.show(title: .errorTitle, msg: .errorMsg)
            self.actionButton.setAtomic(type: .disabled, title: "BAYAR")
        }
    }
    
    func didErrorQrisTransactionsPLMC() {
        DispatchQueue.main.async {
            self.stateLoading(state: .dismiss)
            Alert.show(title: .errorTitle, msg: .errorMsg)
            self.actionButton.setAtomic(type: .disabled, title: "BAYAR")
        }
    }
    


    //ini kenapa di disabled karena dari logicnya harusnya ini di show atau mungkin karena harus pilih
    // tenor dulu?
    func didSuccesTenorTrxQris() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.stateLoading(state: .dismiss)
            self.actionButton.setAtomic(type: .disabled, title: "BAYAR")
        }
    }
    
    func didFailureTenorTrxQris() {
        DispatchQueue.main.async {
            self.stateLoading(state: .dismiss)
            self.showUpFailure(titleError: "No products available for application")
            self.actionButton.setAtomic(type: .disabled, title: "BAYAR")

        }
    }

    func didFailureTenorTrxQrisErr422() {
        DispatchQueue.main.async {
            self.stateLoading(state: .dismiss)
                self.showUpFailure(titleError: "No products available for application")
            }
        }

    func didErrorTenorTrxQris() {
        DispatchQueue.main.async {
            self.stateLoading(state: .dismiss)
            Alert.show(title: .errorTitle, msg: .errorMsg)
            self.actionButton.setAtomic(type: .disabled, title: "BAYAR")
        }
    }

    func didGoToLoginPageFromTransactionProcess(){
        // delegasi sdk
        AppState.switchToLoginPin(completion: nil)
    }


    func didSuccessGetDetailTransaksiByToken(qrGetDetailTransaksiByIdResponse: QRGetDetailTransaksiByIdResponse) {
        var qrTransactionIsProcessPayload = QRTransactionIsProcessPayload(
                titleLabelText: "Transaksi dalam Proses",
                subtitleLabelText: "Transaksi kamu sedang dalam proses. Silakan periksa Riwayat transaksi secara berkala",
                imageName: "illustration_process",
                titleTopButton: "Kembali Ke Beranda",
                titleBottomButtom: "Lihat Riwayat"
        )

        //nanti harusnya kita bawa payload ke page transaksi is process dan bawa lagi payloadnya ke riwayat history
        self.qrNewRouter?.navigateToTransactionIsProcess(qrTransactionIsProcessPayload: qrTransactionIsProcessPayload)
    }

    func didFailedGetDetailTransaksiByToken(){
        var payloadData = QRGetDetailTransaksiByIdDtoViewData(status: "VOID")
        self.qrNewRouter?.navigateToResulPaymentAfterClickBayarAndInputPin(qrGetDetailTransaksiByIdDtoViewData: payloadData)
    }

    func didSuccessPostToTransactionPin(qrTransactionPinResponse: QRTransactionPinResponse) {
        DispatchQueue.main.async {
            self.stateLoading(state: .dismiss)

            // ini perlu bikin tambah link url di dto transaction pin dan transaction otp response
            self.router?.navigateToWebViewQrisTrx(urlLink: self.viewModel.respUrlTrx, idTransaksi: qrTransactionPinResponse.id ?? 0)
        }
    }
    func didFailedPostToTransactionPinBecausePinIsWrong(retryPin:String){
        DispatchQueue.main.async {
            self.stateLoadingQR(state: .dismiss)
            self.qrPopUpPin.retryPin = retryPin
            self.qrPopUpPin.showWarning()
        }
    }

    func didFailedPostToTransactionPinBecauseBadRequest(){
        DispatchQueue.main.async {
            self.stateLoadingQR(state: .dismiss)
        }
        var payloadData = QRGetDetailTransaksiByIdDtoViewData(status: "VOID")
        self.qrNewRouter?.navigateToResulPaymentAfterClickBayarAndInputPin(qrGetDetailTransaksiByIdDtoViewData: payloadData)
    }

    func didFailedPostToTransactionOtpBecauseBadRequest(){
        DispatchQueue.main.async {
            self.stateLoadingQR(state: .dismiss)
        }
        var payloadData = QRGetDetailTransaksiByIdDtoViewData(status: "VOID")
        self.qrNewRouter?.navigateToResulPaymentAfterClickBayarAndInputPin(qrGetDetailTransaksiByIdDtoViewData: payloadData)
    }
    func didFailedPostToTransactionPinBecauseTemporaryLock(){
        DispatchQueue.main.async {
            self.stateLoadingQR(state: .dismiss)
            self.qrPopUp.setupQrPopUp(qrPopUpType: QRPopUpType.pinTemporaryLock)
            self.qrPopUp.delegate = self
            self.showPopUpViewQR(withView: self.qrPopUp)
        }
    }
    func didFailedPostToTransactionPinBecausePermanentLock(){
        DispatchQueue.main.async {
            self.stateLoadingQR(state: .dismiss)
            self.qrPopUp.setupQrPopUp(qrPopUpType: QRPopUpType.pinPermanentLock)
            self.qrPopUp.delegate = self
            self.showPopUpViewQR(withView: self.qrPopUp)
        }
    }
    func didFailedResendOtpBecauseOtpRequestLimitExceeded(){
        DispatchQueue.main.async {
            self.stateLoadingQR(state: .dismiss)
            var qrPopUpPayload = QRPopUpPayload(
                    imageName: VCProperty.imagePinName,
                    titleText: "Mohon Maaf",
                    subtitleLableText: "Kamu sudah 3 kali kirim OTP. Coba kembali setelah 5 menit.",
                    titleButton: "OK")
            self.qrPopUp.initQRPopUP(qrPopUpPayload: qrPopUpPayload)
            self.qrPopUp.delegate = self
            self.showPopUpViewQR(withView: self.qrPopUp)

        }
    }

    func didFailedPostToTransactionPinBecauseOtpRequestLimitExceeded(){
        DispatchQueue.main.async {
            self.stateLoadingQR(state: .dismiss)
            var qrPopUpPayload = QRPopUpPayload(
                    imageName: VCProperty.imagePinName,
                    titleText: "Mohon Maaf",
                    subtitleLableText: "Kamu sudah 3 kali kirim OTP. Coba kembali setelah 5 menit.",
                    titleButton: "OK")
            self.qrPopUp.initQRPopUP(qrPopUpPayload: qrPopUpPayload)
            self.qrPopUp.delegate = self
            self.showPopUpViewQR(withView: self.qrPopUp)

        }
    }


    //MARK: Transaction pin get time out
    func didTransactionPinGetTimeOut(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 20, execute: {
            self.stateLoadingQR(state: .dismiss)
            self.viewModel.getDetailTransaksiByToken(requestTokenTransaksi: self.viewModel.qrInquiryDtoViewData.transactionToken ?? "-", transactionType: TransactionType.pin)
        })
    }


    func didNeedOtp(){
        DispatchQueue.main.async {
            self.stateLoadingQR(state: .dismiss)
            self.qrPopUpOtp.delegate = self
            self.qrPopUpOtp.setupView()
            self.showQRPopUpBottomView(withView: self.qrPopUpOtp, height: self.heightKeyboard + CGFloat(VCProperty.heightPopUpOTP))
        }
    }

    func didFailedPostToTransactionOtpBecauseSubmitLock(){
        DispatchQueue.main.async {
            self.stateLoadingQR(state: .dismiss)
            var qrPopUpPayload = QRPopUpPayload(
                    imageName: VCProperty.imagePinName,
                    titleText: "Mohon Maaf",
                    subtitleLableText: "Kamu sudah 3 kali kirim OTP. Coba kembali setelah 5 menit.",
                    titleButton: "OK")
            self.qrPopUp.initQRPopUP(qrPopUpPayload: qrPopUpPayload)
            self.qrPopUp.delegate = self
            self.showPopUpViewQR(withView: self.qrPopUp
            )

        }
    }

    func didFailedTransactionByOtpBecauseOtpNotMatch(){
        DispatchQueue.main.async {
            self.stateLoadingQR(state: .dismiss)
            self.qrPopUpOtp.showWarning(isHidden: false)
        }
    }

    func didFailedPostToTransactionOtpBecauseOtpExpired(){
        DispatchQueue.main.async {
            self.stateLoadingQR(state: .dismiss)
            self.qrPopUpOtp.showWarning(isHidden: false, text: "OTP Kadaluarsa, silahkan kirim kembali OTP")
        }
    }

    func didSuccessPostToTransctionOtp(idTransaksi: String) {
        DispatchQueue.main.async {
            self.stateLoading(state: .dismiss)
            // ini perlu bikin tambah link url di dto transaction pin dan transaction otp response
            var transaksiId = Int(idTransaksi)
            self.router?.navigateToWebViewQrisTrx(urlLink: self.viewModel.respUrlTrx, idTransaksi: transaksiId ?? 0)
        }

    }

    func didTransactionOtpGetTimeOut(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 20, execute: {
            self.stateLoadingQR(state: .dismiss)

            self.viewModel.getDetailTransaksiByToken(requestTokenTransaksi: self.viewModel.qrInquiryDtoViewData.transactionToken ?? "-", transactionType: TransactionType.otp)



        })
    }

    func didGetDetailTransaksiByTokenGetTimeOut(){
        var qrTransactionIsProcessPayload = QRTransactionIsProcessPayload(titleLabelText: "Transaksi dalam Proses",
                subtitleLabelText: "Transaksi kamu sedang dalam proses. Silakan periksa Riwayat transaksi secara berkala",
                imageName: "illustration_process",
                titleTopButton: "Kembali Ke Beranda",
                titleBottomButtom: "Lihat Riwayat")

        //nanti harusnya kita bawa payload ke page transaksi is process dan bawa lagi payloadnya ke riwayat history
        self.qrNewRouter?.navigateToTransactionIsProcess(qrTransactionIsProcessPayload: qrTransactionIsProcessPayload)
    }

    func didSuccessGetDetailTransaksiById(qrGetDetailTransaksiByIdResponse: QRGetDetailTransaksiByIdResponse){
        var qrGetDetailTransaksiDtoViewData = QRGetDetailTransaksiByIdDtoViewData(qrGetDetailTransaksiResponse: qrGetDetailTransaksiByIdResponse)
        self.qrNewRouter?.navigateToResulPaymentAfterClickBayarAndInputPin(qrGetDetailTransaksiByIdDtoViewData: qrGetDetailTransaksiDtoViewData)
    }
}






extension QRPLMaucashQrisLoanTrxVC : QRPopUpMessageProtocol {
    func didPressMainButton(){
        self.dismissPopUpBottomView()
    }
}

extension QRPLMaucashQrisLoanTrxVC : QRPLMCTenorLoanTrxTVCellProtocol{
    func didSelectTenor(tenor: String) {
        print("")
    }
    
func didSelectQrisTenor(tenorTrx: QRTenorTrx) {
        self.viewModel.tenor = tenorTrx.valueTenor ?? "30D"
        self.viewModel.tenorLbl = tenorTrx.tenor ?? "Sekali bayar"
        self.viewModel.biayaLayanan = tenorTrx.adminFee ?? 0
        self.viewModel.jumlahPinjaman = tenorTrx.totalAmount ?? 0
        self.viewModel.total = tenorTrx.totalLoan ?? 0
        self.viewModel.cicilan = tenorTrx.loanPerMonth ?? 0
        self.viewModel.jatuhTempo = tenorTrx.dueDate ?? ""
        self.updateUI()
        self.tableView.reloadData()
    }
}

extension QRPLMaucashQrisLoanTrxVC : QRPopUpPINProtocol{
    func didFinishEditingPin(pin: String) {
        self.stateLoading(state: .show)

        //transaksi pin
        self.viewModel.postQrisTransactionsPIN(req: self.viewModel.setTrxQrisPLMCReq(pin: pin), qrInquiryDtoViewData: self.viewModel.qrInquiryDtoViewData)
    }
}

extension QRPLMaucashQrisLoanTrxVC: QRPopUpOTPProtocol {
    func didPressSendOTP(otp : String){
        DispatchQueue.main.async {
            print("\(otp) otp gilbert")
            self.stateLoading(state:.show)
            var qrTransactionOtpRequest: QRTransactionOtpRequest = QRTransactionOtpRequest(
                    tipAmount: String(self.viewModel.tipAmount),
                    amount: String(self.viewModel.totalAmountTransaction),
                    payments: self.viewModel.setPaymentTrxQrisPLMC(),
                    otpValue: otp
            )

            var qrTransactionOtpRequestForPathAndHeader: QRTransactionOtpRequestForPathAndHeader = QRTransactionOtpRequestForPathAndHeader(
                    otpId: self.viewModel.otpId,
                    transactionToken: self.viewModel.qrInquiryDtoViewData.transactionToken ?? "-"
            )
            self.viewModel.postToTransactionOtp(qrTransactionOtpRequest: qrTransactionOtpRequest, qrTransactionOtpRequestForPathAndHeader: qrTransactionOtpRequestForPathAndHeader)
        }

    }
    func didPressResendButton(){
        self.viewModel.getResendOtp(inquiryId: String(self.viewModel.qrInquiryDtoViewData.id ?? 0))
    }

}

extension QRPLMaucashQrisLoanTrxVC: QRPopUpProtocol {

    func didActionButtonPressed(){
        self.dismissPopUpViewQR()
        AppState.switchToHome(completion: nil)
    }
}
