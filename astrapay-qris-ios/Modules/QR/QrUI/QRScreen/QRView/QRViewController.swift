//
//  QRViewController.swift
//  astrapay
//
//  Created by Gilbert on 19/10/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit
import AVKit


class QRViewController: UIViewController{
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var iconImageQris: UIImageView!

    @IBOutlet weak var qrCameraControlView: QRCameraControlView!
    
    @IBOutlet weak var qrCameraView: QRCameraView!

    var qrClient: QRClient = QRClient()

    var qrNewRouter: QRNewRouter?



    var vm: QRViewModel = QRViewModel()

    let popUpQRFailed = QRPopUp()
    
    
    
    
    //MARK: gallery picker
    var galeryPicker = QRGaleryPicker()
    var qrReader = QRNewReader()


    struct QRVCProperty{
        static let qrStoryBoardName = "QRStoryBoard"

        static let topLabelText: String = "AstraPay mendukung"
        static let bottomLabelText: String = "Scan di dalam area kotak"
        
        static let iconImageQrisNamed: String = "qris_white"
        
        static let navigationTitle : String = "Scan"
        static let serverErrorMessage : String = "Terjadi masalah\n Silahkan coba beberapa saat lagi"
        static let permissionTitle: String = "Perhatian"
        static let cameraPermissionMessage: String = "Berikan akses Kamera di Pengaturan untuk melanjutkan"
        static let galleryPermissionMessage: String = "Berikan akses Photos di Pengaturan untuk melanjutkan"
        static let cancelPermissionText: String = "Batalkan"
        static let settingsPermissionText: String = "Pengaturan"
        static let cameraControlHeight: Int = 129
    }



    override func viewWillAppear(_ animated: Bool) {
        self.qrCameraView.checkPermission()
        self.setupNavigation(theme: .Transparent, title: QRVCProperty.navigationTitle, navigator: .back, navigatorCallback: nil)
        self.qrCameraView.startAnimation()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.qrCameraView.stopSession()
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupUI()
        setupProtocol()
        setupRouter()
        self.setupCameraControl()
        self.qrCameraView.startAnimation()
        self.setupNotificationCenter()

        // Do any additional setup after loading the view.
    }
    

}

//setup dan kawan kawan
extension QRViewController {
    func setupProtocol(){
        self.vm.delegate = self
    }
    
    func setupRouter(){
        self.qrNewRouter = QRNewRouter(viewController: self)
    }
}


extension QRViewController {
    
    func setupUI(){
        qrCameraControlView.setupView()
        topLabel.text = QRVCProperty.topLabelText

        self.topLabel.font = UIFont.setupFont(size: 14, fontType: UIFont.FontTypeLibrary.interSemiBold)

        self.topLabel.textColor = QRColor.baseWhiteColor

        
        self.iconImageQris.image = UIImage(named: QRVCProperty.iconImageQrisNamed)
    }
    
    
    func setupView() {
        self.setupQRView()
    }
    
    func setupQRView(){
        qrCameraView.delegate = self
        self.galeryPicker.delegate = self
        self.qrReader.delegate = self
    
    }

    func setupNotificationCenter(){
//        NotificationCenter.default.addObserver(self, selector: #selector(onPause), name:
//        UIApplication.willResignActiveNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(onResume), name:
        UIApplication.willEnterForegroundNotification, object: nil)
    }
    
}

//MARK: Actions
extension QRViewController {
    @objc func onResume() {
        self.qrCameraView.startAnimation()
    }
}


extension QRViewController : QRCameraViewProtocol {
    func didCameraAlreadyAuthorized() {
        DispatchQueue.main.async {
            self.qrCameraView.startSession()
        }
    }
    
    func didCameraPermissionGranted() {
        DispatchQueue.main.async {
            self.qrCameraView.startSession()
        }
    }
    
    func didCameraPermissionRejected() {
        DispatchQueue.main.async {
            let alertController = UIAlertController (title: QRViewController.QRVCProperty.permissionTitle, message: QRViewController.QRVCProperty.cameraPermissionMessage, preferredStyle: .alert)
                
            let cancelAction = UIAlertAction(title: QRViewController.QRVCProperty.cancelPermissionText, style: .default)  { (_) -> Void in
            }
            alertController.addAction(cancelAction)
            
            let settingsAction = UIAlertAction(title: QRViewController.QRVCProperty.settingsPermissionText, style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)

            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func didReceiveDataQR(didReceive: Bool, string: String) {
        if didReceive {
//            a
        self.stateLoadingQR(state: .show)
                self.qrCameraView.stopSession()
                print("QR text : \(string)")
                self.vm.getInquiry(qrData: string)
        }
    }
}


//MARK: extension untuk meng-implementasikan QRViewModelProtocol
extension QRViewController: QRViewModelProtocol {
    func didRetrieveDataFromInquiryApi(resp: QRResponse<QRInquiryResponse>) {
        self.stateLoadingQR(state: .dismiss)

        switch resp.status {
            case true:
                DispatchQueue.main.async {
                    var qrInquiryDtoViewData = QRInquiryDtoViewData(qrInquiryResponse: resp.data)

                self.qrNewRouter?.navigateToInputAmountAfterScan(model: qrInquiryDtoViewData)
                }
                break
            case false:
                print("do nothing")
                break
        }
    }

    func didRetrieveDataFromInquirApiAdjustAmountAllowedFalse(qrInquiryResponse: QRInquiryResponse){
        self.stateLoadingQR(state: .dismiss)

        var qrInquiryDtoViewData = QRInquiryDtoViewData(qrInquiryResponse: qrInquiryResponse)
        self.qrNewRouter?.navigateToTransactionDetailAdjustAmountAllowedFalse(qrInquiryDtoViewData: qrInquiryDtoViewData, userBalanceAstrapay: self.vm.userBalanceAstrapay)
    }

    func didRetrieveQRFailed(){
        DispatchQueue.main.async{
            self.stateLoadingQR(state: .dismiss)
            self.setupPopUp()
        }
    }

    func goToLoginPage(){
            AppState.switchToLoginPin(completion: nil)

    }


}


//MARK: IMPLEMENT QR POP UP yang bentuk kotak di tengah and setup
extension QRViewController: QRPopUpProtocol {
    func setupPopUp(){
        popUpQRFailed.setupQrPopUp(qrPopUpType: QRPopUpType.qrFailed)
        popUpQRFailed.delegate = self
        self.showPopUpViewQR(withView: popUpQRFailed)
    }

    func didActionButtonPressed(){
        DispatchQueue.main.async {
            self.qrCameraView.startSession()
            self.dismissPopUpViewQR()
        }
    }
}
//MARK: All related to QRCameraControlView


//MARK: Setup QRCameraControlView
extension QRViewController {
    func setupCameraControl(){
        self.qrCameraControlView.delegate = self
    }
}

//MARK: Implement QRCameraControlViewProtocol
extension QRViewController: QRCameraControlViewProtocol {
    func didQRImagePressed() {
        self.openGalery()
    }
    func didFlashPressed(){
        self.toggleFlash()
    }
}



//MARK: Galery Picker
extension QRViewController {
    func openGalery(){
        self.galeryPicker.checkPermissionGalery()
    }
}

//MARK: Galery Picker Handler
extension QRViewController: QRGaleryPickerProtocol {
    func didFinishSelectImage(image: UIImage) {
        self.qrReader.getQRStringFromImage(image: image)

    }
    
    func didFailedSelectImage() {
        self.showErrorQR()

    }
    
    func didAuthorizedOpenGalery() {
        self.galeryPicker.openGalery(view: self)

    }
    
    func didDeniedOpenGalery() {
        DispatchQueue.main.async {
            let alertController = UIAlertController (title: QRViewController.QRVCProperty.permissionTitle, message: QRViewController.QRVCProperty.galleryPermissionMessage, preferredStyle: .alert)
                
            let cancelAction = UIAlertAction(title: QRViewController.QRVCProperty.cancelPermissionText, style: .default)  { (_) -> Void in
//                AppState.switchToHome(completion: nil)
            }
            alertController.addAction(cancelAction)
            
            let settingsAction = UIAlertAction(title: QRViewController.QRVCProperty.settingsPermissionText, style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)

            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}


//MARK: QRReader Handler (perlu dipindahin QRReaderProcotolnya)
extension QRViewController: QRNewReaderProtocol {
    func didSuccessGetQRString(string: String) {
        self.stateLoadingQR(state : .show)
        self.vm.getInquiry(qrData: string)
        self.stateLoadingQR(state: .dismiss)

    }
    
    func didFailedGetQRString() {
        DispatchQueue.main.async {
            self.stateLoadingQR(state: .dismiss)
            self.setupPopUp()
        }
//        self.stateLoading(state: .show)
//        self.vm.getProduct(qrData: "")
    }
}


//MARK: Flash
extension QRViewController {
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        do {
            try device.lockForConfiguration()

            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
}
