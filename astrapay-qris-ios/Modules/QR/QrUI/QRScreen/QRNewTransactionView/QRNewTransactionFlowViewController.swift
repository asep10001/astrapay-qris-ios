//
//  QRNewTransactionFlowViewController.swift
//  astrapay
//
//  Created by Gilbert on 16/11/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit


//catetan
//1. setup vm protocol belom
protocol QRNewTransactionFlowViewControllerProtocol {
    func didTipsMoreThanZero(value: Int)
}


class QRNewTransactionFlowViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnPayment: QRAPButtonAtom!
    @IBOutlet weak var buttonContainer: UIView!

    var qrPopUpPin = QRPopUpPIN()
    var qrPopUpOtp = QRPopUpOTP()

    let qrPopUp = QRPopUp()



    var viewModel: QRNewTransactionFlowViewModel = QRNewTransactionFlowViewModel()
    var delegate: QRNewTransactionFlowViewControllerProtocol?

    var qrPLMCBillDetailPaymentTVCell: QRPLMCBillDetailPaymentTVCell?

    var qrDetailPaymentTVCellAstrapay: QRDetailPaymentTVCellAstrapay?
    var qrDetailPaymentTVCellPLMC: QRDetailPaymentTVCellPLMC?

    struct VCProperty{
        static let identifier : String = "qRNewTransactionFlowViewControllerIdentifier"
        static let heightOfMerchantInfoCell : CGFloat = QRMerchantInfoTvCell.heightOfCell
        static let heightOfDetailTransaksiCell : CGFloat = QRDetailTransactionTvCell.heightOfCell
        static let heightOfDetailPaymentCell : CGFloat = QRDetailPaymentTvCell.heightOfCell
        static let heightOfNominalTransaction : CGFloat = QRNominalTransactionTvCell.heightOfCell
        var btnTitle : String = "BAYAR"
        static let navigationTitle = "Bayar"
        static let defaultCurrency = "Rp. 0"
        static let constantHeightPopUp = 360
        static let heightPopUpOTP = 380
        static let heightPopUpPin = 380
        static let imagePinName: String = "illustration_pin"
    }

    let vcProperty = VCProperty()
    var heightKeyboard : CGFloat = 250

    static let identifier = VCProperty.identifier
    
    
    //setup bagian tabel dan teman temannya
    var merchantInfoCell = QRMerchantInfoTvCell()
    var qrDetailTransactionCell = QRDetailTransactionTvCell()
    var detailPaymentCell = QRDetailPaymentTvCell()
    var jumlahNominalCell = QRNominalTransactionTvCell()


    //variabel dari kelas lain
    var qrNewRouter: QRNewRouter?
    var paymentModels: QRAPTransactionDetailsModel?


    //variabel
    var qrGetDetailTransaksiById: QRGetDetailTransaksiByIdResponse?
    //MARK: ini buat nge get amo
    var amount: Int?
    var tipAmount: Int?

    var totalAmount: Int?



    //MARK: Cell dan kawan kawan
    var qrDetailTransactionTvCell = QRDetailTransactionTvCell()



    //MARK: buat select payment
    var paymentContent: [QRSelectPaymentViewPayload] = []


    override func viewWillAppear(_ animated: Bool) {
        self.setTextNavigation(theme: .normal, title: VCProperty.navigationTitle, navigator: .back, navigatorCallback: nil)
        self.tableView.reloadData()
        self.setupAction()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupUI()
        self.setupRouter()
        self.setupAction()
        self.setupProtocol()

        //TODO we have do something on this
//        self.stateLoading(state: .show)
    }
}


//MARK: Setup protocol
extension QRNewTransactionFlowViewController {
    func setupProtocol(){
        self.viewModel.delegate = self
        self.qrPopUpOtp.delegate = self
        self.qrDetailTransactionTvCell.delegate = self
    }
}

//setup dan kawan kawan
extension QRNewTransactionFlowViewController {

    func setupRouter(){
        qrNewRouter = QRNewRouter(viewController: self)
    }

    func setupAction(){
        self.checkEnableButton()
    }
}

//setup UI
extension QRNewTransactionFlowViewController {

    func setupUI(){
        if let button = self.buttonContainer {
            self.buttonContainer.addShadowQR(cornerRadius: 0, position: .Top)
        } else {
            //do nothing
        }
        self.setupPopUpOTP()
        self.setupActionKeyboard()
    }
    func setupPopUpOTP(){
        self.qrPopUpOtp.resetOTP()
    }
}

//MARK: setup yang berhubungan dengan init
extension QRNewTransactionFlowViewController {
    func initVM(qrInquiryDtoViewData: QRInquiryDtoViewData, amountTransaction: Int? = nil){
        //MARK: jika tipnya udah ada, maka harus di sesuaikan lagi, ya minimal harus ada tip sebagai parameter di sini
        self.viewModel.initVM(qrInquiryDtoViewData: qrInquiryDtoViewData, baseAmountTransactionFromInputAmountView: amountTransaction ?? 0)
    }
}


//MARK: Setup Table View buat setup protocol dan buat register by nib
extension QRNewTransactionFlowViewController {
    func setupTableView() {
        self.setupTableViewCell()
        self.setupTableViewProtocol()
        self.tableView.bounces = false
        self.tableView.alwaysBounceVertical = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorStyle = .none
    }
    func setupTableViewProtocol(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    func setupTableViewCell(){
        self.tableView.register(UINib(nibName: QRMerchantInfoTvCell.nibName, bundle: nil), forCellReuseIdentifier: QRMerchantInfoTvCell.identifier)
        self.tableView.register(UINib(nibName: QRDetailTransactionTvCell.nibName, bundle: nil), forCellReuseIdentifier: QRDetailTransactionTvCell.identifier)
        self.tableView.register(UINib(nibName: QRDetailPaymentTvCell.nibName, bundle: nil), forCellReuseIdentifier: QRDetailPaymentTvCell.identifier)
        self.tableView.register(UINib(nibName: QRNominalTransactionTvCell.nibName, bundle: nil),
                forCellReuseIdentifier: QRNominalTransactionTvCell.identifier)
        self.tableView.register(UINib(nibName: QRPLMCBillDetailPaymentTVCell.nibName, bundle: nil),
                forCellReuseIdentifier: QRPLMCBillDetailPaymentTVCell.identifier)
    }
}


//MARK: implement tableview datasource, tableview delegate
extension QRNewTransactionFlowViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0:
            return self.setupMerchantInfoCell(tableView: tableView, indexPath: indexPath)
            break
        case 1:
            return self.setupDetailTransactionCell(tableView: tableView, indexPath: indexPath)
            break
        case 2:
            return self.setupPLMCDetailPaymentCell(tableView: tableView, indexPath: indexPath)
            break
        default:
            return UITableViewCell()
        }
    return UITableViewCell()
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return VCProperty.heightOfMerchantInfoCell
            break
        case 1:
            return VCProperty.heightOfDetailTransaksiCell
        case 2:
            return 400
        default:
            return 0
        }
        return 0;
    }
}


//MARK: ini buat setup per cell yang sudah didaftarkan
extension QRNewTransactionFlowViewController {
    func setupMerchantInfoCell(tableView : UITableView, indexPath : IndexPath) -> UITableViewCell{
        self.merchantInfoCell = tableView.dequeueReusableCell(withIdentifier: QRMerchantInfoTvCell.identifier, for: indexPath) as! QRMerchantInfoTvCell
//        var qrMerchantInfoCellPayload: QRMerchantInfoCellPayload = QRMerchantInfoCellPayload(nameMerchant: "Johnny",lokasi: "Jakarta",isUseDate: true,isBuyTo: true, date: "haha" )
        var qrMerchantInfoCellPayload = self.viewModel.getQRMerchantInfoTvCellPayload()
        self.merchantInfoCell.setupView(payloadView: qrMerchantInfoCellPayload)
        self.merchantInfoCell.selectionStyle = .none
        return self.merchantInfoCell
    }
    func setupDetailTransactionCell(tableView : UITableView, indexPath : IndexPath) -> UITableViewCell{
        self.qrDetailTransactionCell = tableView.dequeueReusableCell(withIdentifier: QRDetailTransactionTvCell.identifier, for: indexPath) as! QRDetailTransactionTvCell
        self.qrDetailTransactionCell.selectionStyle = .none
//        var qrDetail: QRDetailTransactionCellPayload = QRDetailTransactionCellPayload(jumlahTransaksi: 30000, totalPayment: 50000, isUseTips: true, tips: 500.0, tipsPercentage: "10", tipType: QRISNewTipType.percentage)
        var qrDetailTransactionCellPayload = self.viewModel.getQRDetailTransactionTvCellPayload()
        self.qrDetailTransactionCell.setupView(payloadView: qrDetailTransactionCellPayload)
        self.qrDetailTransactionCell.setupAction()
        self.qrDetailTransactionCell.delegate = self
        return self.qrDetailTransactionCell
    }
    //MARK ini buat setup payment method
    func setupPLMCDetailPaymentCell(tableView : UITableView, indexPath : IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: QRPLMCBillDetailPaymentTVCell.identifier, for: indexPath) as! QRPLMCBillDetailPaymentTVCell
        self.qrPLMCBillDetailPaymentTVCell = cell

        self.qrDetailPaymentTVCellAstrapay = cell.contentPayment.qrDetailPaymentAstrapay
        self.qrDetailPaymentTVCellPLMC = cell.contentPayment.qrDetailPaymentPLMC
        let payload = QRSelectPaymentViewPayload(qrInquiryDtoViewData: self.viewModel.qrInquiryDtoViewData, basicPrice: Int(self.viewModel.amountTransaction ?? 0), amountTransaction: self.viewModel.totalAmountTransaction)
        let plmc = [payload, payload]
        cell.setupView(content: plmc)
        cell.contentPayment.delegate = self
        return cell
    }
}
extension QRNewTransactionFlowViewController {
    private func checkEnableButton() {
        //TODO bikin logic untuk enable/disable cuma gatau gimana
        self.btnPayment.setAtomic(type: .filled, title: "BAYAR")
//        if !self.viewModel.userBalanceEnoughCompareToTotalAmount {
//            self.btnPayment.setAtomic(type: .disabled, title: "BAYAR")
//        }
        self.btnPayment.coreButton.setTapGestureRecognizer {
            if self.viewModel.isPaylater {
                self.viewModel.ifIsPaylater()
                return
            }
            self.showPopUpPin()
        }
    }
    private func checkEnableButtonIfBalanceIsNotEnough(){
        if !self.viewModel.userBalanceEnoughCompareToTotalAmount{
            self.btnPayment.setAtomic(type: .disabled, title: "BAYAR")
        } else {
            self.btnPayment.setAtomic(type: .filled, title: "Bayar")
        }
    }
}
extension QRNewTransactionFlowViewController: QRDetailTransactionTvCellProtocol {
    func didPressTipsButton() {
        self.setMainBackground()
        let vc = QRAPPopUpNoteTransferVC()
        vc.isQris = true
        vc.modalPresentationStyle = .overCurrentContext
        vc.onDismissTapped = { [weak self] (isDismiss, value) in
            guard let self = self else { return }
            self.removeMainBackground()
            if isDismiss {
                let tempAmnt = value ?? "0"
                self.viewModel.tipPercentage = nil
                self.viewModel.tipAmount = Int(tempAmnt ?? "0")

                guard let baseAmount = self.viewModel.amountTransaction else {
                    return
                }
                var amount = Int(baseAmount)
                amount += Int(tempAmnt) ?? 0
                self.viewModel.totalAmountTransaction = amount
                self.viewModel.qrPaymentAfterInputPinPayloadBuilder()
                self.delegate?.didTipsMoreThanZero(value: Int(value ?? "0") ?? 0)

                self.checkEnableButtonIfBalanceIsNotEnough()

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
//                self.qrPLMCBillDetailPaymentTVCell?.contentPayment.qrDetailPaymentPLMC?.selectedPaymentImage.isHidden = false
            }
            vc.dismiss(animated: true, completion: nil)
        }
        self.present(vc, animated: true, completion: nil)
        vc.setupViewDynamic(title: "Masukkan jumlah tips", keyboardType: .NumberPad, buttonLabel: "Submit")
    }

    func setMainBackground() {
        let backgrooundView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        backgrooundView.backgroundColor = UIColor.black
        backgrooundView.tag = 100
        backgrooundView.alpha = 0.4
        self.view.addSubview(backgrooundView)
    }

    func removeMainBackground() {
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
    }
}
extension QRNewTransactionFlowViewController: QRPopUpPINProtocol {
    func showPopUpPin(){
        self.qrPopUpPin.pinView.clear()
        self.qrPopUpPin.delegate = self
        self.qrPopUpPin.setupView()
        self.qrPopUpPin.setEditing()
        self.showQRPopUpBottomView(withView: self.qrPopUpPin, height: self.heightKeyboard + CGFloat(VCProperty.heightPopUpPin))
    }

    func didFinishEditingPin(pin: String) {
        DispatchQueue.main.async(execute: {
            self.stateLoadingQR(state: .show)
            print("ini adalah pin gilbert \(pin)")
            guard let baseAmount = self.viewModel.amountTransaction else {
                return
            }
            self.qrPopUpPin.pinView.clear()

            //MARK: Ini harus dibikin logic di vm
            guard var qrPaymentAfterInputPinPayload = self.viewModel.qrPaymentAfterInputPinPayload else { return }
            qrPaymentAfterInputPinPayload.pin = pin


            //MARK: Transaksi Pin
            self.viewModel.postToTransactionPin(qrPaymentAfterInputPinPayload: qrPaymentAfterInputPinPayload)
        })
    }
}
//MARK: Implement QRNewTransactionFlowViewModelProtocol (view model protocol)
extension QRNewTransactionFlowViewController: QRNewTransactionFlowViewModelProtocol {

    func didGoToLoginPageFromTransactionProcess(){
        // delegasi sdk
        AppState.switchToLoginPin(completion: nil)
    }

    //MARK: Paylater transaksi
    func didPostToTransactionPaylaterThroughPin() {
        //router ke paylater
        guard let qrInquryDtoViewData = self.viewModel.qrInquiryDtoViewData else {
            return
        }
        var qrPaylaterTransactionPayload = QRPaylaterTransactionPayload(amounTransaction: self.viewModel.amountTransaction ?? 0, tipTransaction: self.viewModel.tipAmount ?? 0, totalAmountTransaction: self.viewModel.totalAmountTransaction ?? 0, qrInquiryDtoViewData: qrInquryDtoViewData)
        self.qrNewRouter?.navigateToTenorLoanPage(model: qrPaylaterTransactionPayload)
    }

    func didPostToTransactionPaylaterThroughOtp() {
        //route ke paylater
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
            self.viewModel.getDetailTransaksi(idTransaksi: String(qrTransactionPinResponse.id ?? 0))
            self.stateLoadingQR(state: .dismiss)
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
            self.setupPopUpErrorPinTemporaryLock()
        }
    }
    func didFailedPostToTransactionPinBecausePermanentLock(){
        DispatchQueue.main.async {
            self.stateLoadingQR(state: .dismiss)
            self.setupPopUpErrorPinPermanentLock()
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
            self.viewModel.getDetailTransaksiByToken(requestTokenTransaksi: self.viewModel.qrInquiryDtoViewData?.transactionToken ?? "-", transactionType: TransactionType.pin)
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
            //buat nget test doang
//            var qrResultPaymentViewControllerPayload: QRResultPaymentViewControllerPayload = QRResultPaymentViewControllerPayload(merchantName: "Jakarta Merchant", dateTrx: "2021", nominalTransaksi: Double(2000))
            self.viewModel.getDetailTransaksi(idTransaksi: idTransaksi)
            //MARK: ini dapetin getnya dari get transaction buat dapeting tanggalnya transaction at
            self.stateLoadingQR(state: .dismiss)
        }

    }

    func didTransactionOtpGetTimeOut(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 20, execute: {
            self.stateLoadingQR(state: .dismiss)

            self.viewModel.getDetailTransaksiByToken(requestTokenTransaksi: self.viewModel.qrInquiryDtoViewData?.transactionToken ?? "-", transactionType: TransactionType.otp)


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





//MARK: setup keyboard for otp
extension QRNewTransactionFlowViewController {
    func setupActionKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboard = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.heightKeyboard = keyboard.height
            self.qrPopUpOtp.frame.origin.y = UIScreen.main.bounds.height - keyboard.height - CGFloat(VCProperty.heightPopUpOTP)
            self.qrPopUpPin.frame.origin.y = UIScreen.main.bounds.height - keyboard.height - CGFloat(PopUpPIN.heightOfPopUp)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.qrPopUpOtp.frame.origin.y = (UIScreen.main.bounds.height - CGFloat(VCProperty.heightPopUpOTP) - 44)
            self.qrPopUpPin.frame.origin.y = (UIScreen.main.bounds.height - CGFloat(VCProperty.heightPopUpOTP) - 44)
        }
    }
}

//MARK: Implement PopUpOtp Protocol
extension QRNewTransactionFlowViewController: QRPopUpOTPProtocol {
    func didPressSendOTP(otp : String){
        DispatchQueue.main.async {
            print("\(otp) otp gilbert")
            self.stateLoading(state:.show)
            var qrTransactionOtpRequest: QRTransactionOtpRequest = QRTransactionOtpRequest(
                    tipAmount: self.viewModel.qrPaymentAfterInputPinPayload?.tip,
            amount: self.viewModel.qrPaymentAfterInputPinPayload?.totalAmount,
            payments: self.viewModel.qrPaymentAfterInputPinPayload?.paymentMethod,
            otpValue: otp
            )

            var qrTransactionOtpRequestForPathAndHeader: QRTransactionOtpRequestForPathAndHeader = QRTransactionOtpRequestForPathAndHeader(
                    otpId: self.viewModel.otpId,
            transactionToken: self.viewModel.qrInquiryDtoViewData?.transactionToken ?? "-"
            )
            self.viewModel.postToTransactionOtp(qrTransactionOtpRequest: qrTransactionOtpRequest, qrTransactionOtpRequestForPathAndHeader: qrTransactionOtpRequestForPathAndHeader)
        }

    }
    func didPressResendButton(){
        DispatchQueue.main.async {
            self.viewModel.getResendOtp(inquiryId: String(self.viewModel.qrInquiryDtoViewData?.id ?? 0))
        }
    }

}

//MARK: ALL RELATED TO PAYLATER

//MARK: Implement QRPLMCDetailPaymentViewProtocol (cara set pembayaran)
extension QRNewTransactionFlowViewController: QRSelectPaymentViewProtocol {
    func didSelectPayment(index: Int, selectedImageFromAstrapay: Bool, selectedImageFromPLMC: Bool){
        self.viewModel.qrPaymentAfterInputPinPayloadBuilder(indexPathRow: index, selectedImageFromAstrapay: selectedImageFromAstrapay, selectedImageFromPLMC: selectedImageFromPLMC)
    }
    func didSelectAktifkan(){

    }
    func isTipsMoreThanZero() -> Bool{
        guard let tipAmount = self.viewModel.tipAmount else { return false }
        if tipAmount > 0 {
            return true
        }
        return false
    }

    func isPaylaterSelected(isPaylater: Bool){
        self.viewModel.isPaylater = isPaylater
        print("Ini adalah paylater: \(self.viewModel.isPaylater)")
    }

    func didAstrapayCellReloaded(userBalance: Int){
        self.viewModel.userBalanceAstrapay = userBalance
        self.checkEnableButtonIfBalanceIsNotEnough()
    }
}

//MARK: untuk register pop up
extension QRNewTransactionFlowViewController: QRPopUpProtocol {
    func setupPopUpErrorPinTemporaryLock(){
        qrPopUp.setupQrPopUp(qrPopUpType: QRPopUpType.pinTemporaryLock)
        qrPopUp.delegate = self
        self.showPopUpViewQR(withView: qrPopUp)
    }

    func setupPopUpErrorPinPermanentLock(){
        qrPopUp.setupQrPopUp(qrPopUpType: QRPopUpType.pinPermanentLock)
        qrPopUp.delegate = self
        self.showPopUpViewQR(withView: qrPopUp)
    }

    func didActionButtonPressed(){
        self.dismissPopUpViewQR()
        AppState.switchToHome(completion: nil)
    }
}
