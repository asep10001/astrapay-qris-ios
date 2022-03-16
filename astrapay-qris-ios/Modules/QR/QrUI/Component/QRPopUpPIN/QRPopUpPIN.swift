//
//  QRPopUpPIN.swift
//  astrapay
//
//  Created by Guntur Budi on 22/09/20.
//  Copyright © 2020 Tirta Rivaldi. All rights reserved.
//

import UIKit

protocol QRPopUpPINProtocol : class {
    func didFinishEditingPin(pin: String)
}

@IBDesignable
class QRPopUpPIN: UIView {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var pinView: QRLKPINView!
    @IBOutlet weak var lblWarning: QRUILabelInterMedium!
    @IBOutlet weak var constraintBottomContainerView: NSLayoutConstraint!
    
    private static let pinViewTag : Int = 10
    
    @IBOutlet weak var btnPinView: UIButton!
    
    
    static let heightOfPopUp : CGFloat = 451
    static let identifier = "qrPopUpPINIdentifier"
    static let nibName = "QRPopUpPIN"

    var retryPin: String?

    var viewModel = QRPopUpPINViewModel()
    
    static var heightOfCustomPopUPWithKeyboard : CGFloat  {
        let conditionIphone7More = UIScreen.main.bounds.height > 700
        if conditionIphone7More {
            return 551
        }else {
             return 451
        }
        
    }
    
    var delegate : QRPopUpPINProtocol?

    
   override class func prepareForInterfaceBuilder() {
       super.prepareForInterfaceBuilder()
   }
   
   override init(frame: CGRect) {
       super.init(frame: frame)
       xibSetupQR(nibName: QRPopUpPIN.nibName)
   }


   required init?(coder: NSCoder) {
       super.init(coder: coder)
       xibSetupQR(nibName: QRPopUpPIN.nibName)
   }

   override func awakeFromNib() {
       xibSetupQR(nibName: QRPopUpPIN.nibName)
//        self.setupView()
   }
    
    func showWarning(){
        self.viewModel.retryPin = self.retryPin ?? "0"
        self.lblWarning.text = self.viewModel.warningText ?? "-"
        self.lblWarning.isHidden = self.viewModel.isErrorMessageShow

    }
    
    func hideWarning(){
        self.lblWarning.isHidden = true
    }
    
    
}

extension QRPopUpPIN {

    func setupView(){
        QRLKPINView.setupBlackColor()
        self.pinView.tag = QRPopUpPIN.pinViewTag
        self.pinView.addTarget(self, action: #selector(onPINEditing(_:)), for: .editingDidEnd)
        self.pinView.addTarget(self, action: #selector(onPINChanged(_:)), for: .valueChanged)
        DispatchQueue.main.async(execute: {
            self.viewContainer.roundedTopMessageQR(isFullScreen: true)
           
        })
        
        self.btnPinView.setTapGestureRecognizer(action: {
            print("tapped")
            self.pinView.becomeFirstResponder()
        })
    }
    
    func registerNotificationKeyboard(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func unregisterNotificationKeyboard(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func setEditing(){
        self.pinView.becomeFirstResponder()
    }
    func endEditing(){
        self.pinView.resignFirstResponder()
    }
    
    func getPinValue() -> String{
        return self.pinView.pinString
    }
    
    @IBAction func onPINEditing(_ sender: QRLKPINView) {
        if sender.tag == QRPopUpPIN.pinViewTag {
            self.delegate?.didFinishEditingPin(pin: self.pinView.pinString)
        } else {
            sender.resignFirstResponder()
            pinView.becomeFirstResponder()
        }
    }
    
    @IBAction func onPINChanged(_ sender : QRLKPINView){
        if sender.tag == QRPopUpPIN.pinViewTag {
            hideWarning()
        } else {
            sender.resignFirstResponder()
            pinView.becomeFirstResponder()
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            print(keyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            print(keyboardHeight)
        }
    }
}
