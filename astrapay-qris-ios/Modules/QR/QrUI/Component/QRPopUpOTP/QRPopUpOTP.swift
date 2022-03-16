//
//  QRPopUpOTP.swift
//  astrapay
//
//  Created by Guntur Budi on 14/08/20.
//  Copyright © 2020 Tirta Rivaldi. All rights reserved.
//

import UIKit


protocol QRPopUpOTPProtocol : class {
    func didPressSendOTP(otp : String)
    func didPressResendButton()
}

class QRPopUpOTP: UIView {

    static let identifier = "qrPopUpOTPIdentifier"
    static let nibName = "QRPopUpOTP"
    static let titleButton = "KIRIM"
    
    @IBOutlet weak var constraintResendOTPCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var txFieldOne: QRInputLoginTextField!
    @IBOutlet weak var txFieldTwo: QRInputLoginTextField!
    @IBOutlet weak var txFieldThree: QRInputLoginTextField!
    @IBOutlet weak var txFieldFour: QRInputLoginTextField!
    @IBOutlet weak var txFieldFive: QRInputLoginTextField!
    @IBOutlet weak var txFieldSix: QRInputLoginTextField!
    
    @IBOutlet weak var coreButton: QRAPButtonAtom!
    @IBOutlet weak var btnResendOTP: UIButton!
    
    @IBOutlet weak var lblWarning: QRUILabelInterSemiBold!
    @IBOutlet weak var lblTimer: QRUILabelInterSemiBold!
    
    
    let textFieldFont : UIFont = UIFont.setupFont(size: 14, fontType: .interSemiBold)
    
    var fieldCode: String {
        if let text1 = self.txFieldOne.text,
            let text2 = self.txFieldTwo.text,
            let text3 = self.txFieldThree.text,
            let text4 = self.txFieldFour.text,
            let text5 = self.txFieldFive.text,
            let text6 = self.txFieldSix.text {
            if !text1.isEmpty && !text2.isEmpty && !text3.isEmpty && !text4.isEmpty && !text5.isEmpty && !text6.isEmpty {
                return "\(text1)\(text2)\(text3)\(text4)\(text5)\(text6)"
            }
        }
        return "\(self.txFieldOne.text!)\(self.txFieldTwo.text!)\(self.txFieldThree.text!)\(self.txFieldFour.text!)\(self.txFieldFive.text!)\(self.txFieldSix.text!)"
    }
    
    var arrOfPin : [String] = []
    
    static let popUpHeight : CGFloat = 360
    let cornerRadi : CGFloat = 5
    let borderNormalColor : UIColor = QRBaseColor.baseBorderColor
    let borderWarningColor : UIColor = UIColor.red
    
    var seconds = 30
    var timer = Timer()
    let maxSendOTP : Int = 3
    var currentSendOTP: Int = 1
    var delegate : QRPopUpOTPProtocol?
    var arrayOfOTP : [String] = ["","","","","",""]
    
    var isConditionDelete = false
    let constResendOTPXWithTimer : CGFloat = -18
    let constResendOTPXWithoutTimer : CGFloat = 0
    
    func setupAction(){
        self.coreButton.coreButton.setTapGestureRecognizer(action: {
            self.delegate?.didPressSendOTP(otp: self.fieldCode)
        })
        self.btnResendOTP.setTapGestureRecognizer(action: {
            self.delegate?.didPressResendButton()
//            self.currentSendOTP += 1
            self.seconds = 30
            self.disableButtonResend()
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(QRPopUpOTP.updateTimer)), userInfo: nil, repeats: true)
        })
    }
    
    override class func awakeFromNib() {
    }
    
    func setupView(){
        DispatchQueue.main.async(execute: {
            self.containerView.roundedTopMessageQR(isFullScreen: true)
        })
            
        self.setupTextfield()
        self.setupAction()
    
        self.txFieldOne.font = self.textFieldFont
        self.txFieldOne.layer.cornerRadius = self.cornerRadi
        self.txFieldOne.delegate = self
        self.txFieldOne.tag = 1
        self.txFieldOne.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        self.txFieldOne.backspaceCalled = {
        }
        
        self.txFieldTwo.font = self.textFieldFont
        self.txFieldTwo.layer.cornerRadius = self.cornerRadi
        self.txFieldTwo.delegate = self
        self.txFieldTwo.tag = 2
        self.txFieldTwo.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        self.txFieldTwo.backspaceCalled = {
            if self.txFieldTwo.text! == "" {
                self.hideWarning()
                self.isConditionDelete = true
                self.txFieldOne.becomeFirstResponder()
            }
        }
        
        self.txFieldThree.font = self.textFieldFont
        self.txFieldThree.layer.cornerRadius = self.cornerRadi
        self.txFieldThree.delegate = self
        self.txFieldThree.tag = 3
        self.txFieldThree.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        self.txFieldThree.backspaceCalled = {
            if self.txFieldThree.text! == "" {
                self.hideWarning()
                self.isConditionDelete = true
                self.txFieldTwo.becomeFirstResponder()
            }
        }
        
        self.txFieldFour.font = self.textFieldFont
        self.txFieldFour.layer.cornerRadius = self.cornerRadi
        self.txFieldFour.delegate = self
        self.txFieldFour.tag = 4
        self.txFieldFour.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        self.txFieldFour.backspaceCalled = {
                if self.txFieldFour.text! == "" {
                    self.hideWarning()
                    self.isConditionDelete = true
                    self.txFieldThree.becomeFirstResponder()
                }
        }
        
        self.txFieldFive.font = self.textFieldFont
        self.txFieldFive.layer.cornerRadius = self.cornerRadi
        self.txFieldFive.delegate = self
        self.txFieldFive.tag = 5
        self.txFieldFive.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        self.txFieldFive.backspaceCalled = {
            if self.txFieldFive.text! == "" {
                self.hideWarning()
                self.isConditionDelete = true
                self.txFieldFour.becomeFirstResponder()
            }
        }
        
        self.txFieldSix.font = self.textFieldFont
        self.txFieldSix.layer.cornerRadius = self.cornerRadi
        self.txFieldSix.delegate = self
        self.txFieldSix.tag = 6
        self.txFieldSix.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        self.txFieldSix.backspaceCalled = {
            if self.txFieldSix.text! == "" {
                self.hideWarning()
                self.isConditionDelete = true
                self.txFieldFive.becomeFirstResponder()
            }
        }
        
        self.txFieldOne.becomeFirstResponder()
        self.coreButton.layer.cornerRadius = 15
        self.coreButton.isUserInteractionEnabled = false
        self.coreButton.setAtomic(type: .disabled, title: QRPopUpOTP.titleButton, messageError: "")

        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    
    
    @objc func updateTimer() {
           if self.seconds == 0 {
                self.timer.invalidate()
                self.btnResendOTP.setTitle("Kirim Kembali OTP", for: .normal)
                self.lblTimer.isHidden = true
            if self.currentSendOTP < self.maxSendOTP {
                    self.enableButtonResend()
                }else {
                     self.disableButtonResend()
                }
           } else {
                self.seconds -= 1
                self.lblTimer.isHidden = false
                self.btnResendOTP.setTitle("Kirim Kembali OTP", for: .normal)
                self.lblTimer.text = "(\(timeString(time: TimeInterval(seconds))))"
                self.disableButtonResend()
           }
    }
    
    func disableButtonResend (){
        self.constraintResendOTPCenterX.constant = self.constResendOTPXWithTimer
        self.btnResendOTP.isUserInteractionEnabled = false
        self.btnResendOTP.titleLabel?.font = UIFont.setupFont(size: 12, fontType: .interBold)
        self.btnResendOTP.setTitleColor(UIColor(string: "#b2b2b2"), for: .normal)
    }
    
    func enableButtonResend(){
        self.constraintResendOTPCenterX.constant = self.constResendOTPXWithoutTimer
        self.btnResendOTP.isUserInteractionEnabled = true
        self.btnResendOTP.titleLabel?.font = UIFont.setupFont(size: 12, fontType: .interBold)
        self.btnResendOTP.setTitleColor(QRBaseColor.QRProperties.baseColor, for: .normal)
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    func setupTextfield(){
        self.txFieldOne.borderStyle = .none
        self.txFieldTwo.borderStyle = .none
        self.txFieldThree.borderStyle = .none
        self.txFieldFour.borderStyle = .none
        self.txFieldFive.borderStyle = .none
        self.txFieldSix.borderStyle = .none
        self.hideWarning()
        self.txFieldOne.layer.borderWidth = 1
        self.txFieldTwo.layer.borderWidth = 1
        self.txFieldThree.layer.borderWidth = 1
        self.txFieldFour.layer.borderWidth = 1
        self.txFieldFive.layer.borderWidth = 1
        self.txFieldSix.layer.borderWidth = 1
    }
    
    func showWarning(isHidden: Bool, text: String = "OTP yang kamu masukkan salah"){
        self.lblWarning.isHidden = isHidden
        self.lblWarning.text = text
        self.txFieldOne.layer.borderColor = self.borderWarningColor.cgColor
        self.txFieldTwo.layer.borderColor = self.borderWarningColor.cgColor
        self.txFieldThree.layer.borderColor = self.borderWarningColor.cgColor
        self.txFieldFour.layer.borderColor = self.borderWarningColor.cgColor
        self.txFieldFive.layer.borderColor = self.borderWarningColor.cgColor
        self.txFieldSix.layer.borderColor = self.borderWarningColor.cgColor
    }
    
    func hideWarning(){
        self.lblWarning.isHidden = true
        self.txFieldOne.layer.borderColor = self.borderNormalColor.cgColor
        self.txFieldTwo.layer.borderColor = self.borderNormalColor.cgColor
        self.txFieldThree.layer.borderColor = self.borderNormalColor.cgColor
        self.txFieldFour.layer.borderColor = self.borderNormalColor.cgColor
        self.txFieldFive.layer.borderColor = self.borderNormalColor.cgColor
        self.txFieldSix.layer.borderColor = self.borderNormalColor.cgColor
    }
    
    func resetOTP(){
        self.txFieldOne.text = ""
        self.txFieldTwo.text = ""
        self.txFieldThree.text = ""
        self.txFieldFour.text = ""
        self.txFieldFive.text = ""
        self.txFieldSix.text = ""
        self.hideWarning()
        self.disableButtonSend()
    }
    
    func enableButtonSend(){
        self.coreButton.isUserInteractionEnabled = true
         self.coreButton.setAtomic(type: .filled, title: QRPopUpOTP.titleButton, messageError: "")
    }
    
    func disableButtonSend(){
        self.coreButton.isUserInteractionEnabled = false
        self.coreButton.setAtomic(type: .disabled, title: QRPopUpOTP.titleButton, messageError: "")
    }
    
    override class func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetupQR(nibName: QRPopUpOTP.nibName)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetupQR(nibName: QRPopUpOTP.nibName)
    }

    override func awakeFromNib() {
        xibSetupQR(nibName: QRPopUpOTP.nibName)
    }
}

extension QRPopUpOTP : UITextFieldDelegate{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.length >= 1 && string != ""{
            return false
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.tintColor = .clear
        if self.fieldCode.length == 6 {
            DispatchQueue.main.async {
                self.txFieldSix.becomeFirstResponder()
            }

        }else {
            if !self.isConditionDelete{
                if self.txFieldOne.text == "" {
                    self.txFieldOne.becomeFirstResponder()
                }else if self.txFieldTwo.text == "" {
                    self.txFieldTwo.becomeFirstResponder()
                }else if self.txFieldThree.text == "" {
                    self.txFieldThree.becomeFirstResponder()
                }else if self.txFieldFour.text == "" {
                    self.txFieldFour.becomeFirstResponder()
                }else if self.txFieldFive.text == "" {
                    self.txFieldFive.becomeFirstResponder()
                }else if self.txFieldSix.text == "" {
                    self.txFieldSix.becomeFirstResponder()
                }
            }else if self.txFieldOne.text == "" {
                self.txFieldOne.becomeFirstResponder()
            }
            
        }
    }
    
    @objc func textFieldChanged(_ textField: UITextField){
        let conditionMax = textField.text!.length == 1
        let conditionNotPressBack = textField.text! != ""
        
       if conditionMax && conditionNotPressBack {
            self.isConditionDelete = false
            self.hideWarning()
            self.textFieldSwitcher(tag: textField.tag)
        }
        
        let conditionOTPFilled = self.fieldCode.count == 6
        if conditionOTPFilled {
            self.enableButtonSend()
        }else {
            self.disableButtonSend()
        }
        
    }
    
    func textFieldSwitcher(tag : Int){
        switch tag {
        case 1:
            self.txFieldTwo.becomeFirstResponder()
            break
        case 2:
            self.txFieldThree.becomeFirstResponder()
           break
        case 3:
            self.txFieldFour.becomeFirstResponder()
           break
        case 4:
            self.txFieldFive.becomeFirstResponder()
           break
        case 5:
            self.txFieldSix.becomeFirstResponder()
           break
        case 6:
            self.endEditing(true)
            self.enableButtonSend()
           break
        default:
            break
        }
    }
    
    
}
