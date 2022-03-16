//
//  ViewSettingsInputText.swift
//  astrapay
//
//  Created by Antonius on 22/10/20.
//  Copyright © 2020 Tirta Rivaldi. All rights reserved.
//

import UIKit

protocol SettingsInputTextProtocol : class {
    func didMaxLenghtText(text : String, tag: Int)
    func didCurrentText(text: String, tag: Int)
    func didEmptyText(tag: Int)
}

enum LabelTextInputSetting: String{
    case lblInputEmail = "Email"
    case lblInputNama = "Nama"
    case lblBankNama = "Nama Bank"
    case lblNoRekening = "Nomor Rekening"
    case lblSaveBy = "Nama Pemilik Rekening"
    case lblSaveAs = "Simpan Sebagai"
    case lblPhone = "Nomor Handphone"
    case lblKlaimVloucher = "Kode Voucher"
}

enum PlaceHolderTextSetting: String{
    case emailTextPlaceHolder = "Masukan alamat email"
    case namaTextPlaceHolder = "Nama"
    case bankNamePlaceHolder = "Masukkan nama Bank"
    case noRekeingPlaceHolder = "Masukkan nomor Rekening"
    case saveByPlaceHolder = "Masukkan nama pemilik rekening"
    case saveAsPlaceHolder = "Masukkan nama yang diinginkan"
    case phoneTextPlaceHolder = "Masukkan nomor handphone baru"
    case klaimVoucherPlaceHolder = "Masukkan kode voucher"
    case defaultPlaceHolder = ""
}

enum KeyboardType : Int {
    case Default
    case ASCIICapable
    case NumbersAndPunctuation
    case URL
    case NumberPad
    case PhonePad
    case NamePhonePad
    case EmailAddress
    case DecimalPad
    case Twitter
    case WebSearch
}

struct SetupViewIntputText {
    var lblNameText : LabelTextInputSetting
    var lblOptionalText : String = "(Optional)"
    var isOptionalText : Bool = false
    var isTapGestureTfInput : Bool = false
    var maxLenghtText : Int = 20
    var placeHolderText : PlaceHolderTextSetting
    var keyboardType : KeyboardType
    var lblTitleFontType : UIFont.FontTypeLibrary = .interSemiBold
    var lblOptionalFontType : UIFont.FontTypeLibrary = .interRegular
}

@IBDesignable
class ViewInputText: UIView {

    @IBOutlet weak var lblSettingsTextInput : QRUILabelInterBold!
    @IBOutlet weak var lblSettingsTextOptional : QRUILabelInterRegular!
    @IBOutlet weak var tfSettingsTextInput : UITextField!
    @IBOutlet weak var viewTfSettingTextGesture: UIView!
    @IBOutlet weak var lblWarningTextField: QRUILabelInterRegular!
    
    struct ViewProperty{
        static let identifier : String = "viewInputTextIdentifier"
        static let nibName = "ViewInputText"
        static let heightOfView : CGFloat = 90
    }
    static let identifier = ViewProperty.identifier
    static let nibName = ViewProperty.nibName
    var delegate : SettingsInputTextProtocol?
    var fieldTextInput: String {
        if let text1 = self.tfSettingsTextInput.text {
            if !text1.isEmpty  {
                return "\(text1)"
            }
        }
        return "\(self.tfSettingsTextInput.text!)"
    }
    var modelSetupTextView : SetupViewIntputText!
    
    func setupView(modelSetupView: SetupViewIntputText){
        modelSetupTextView = modelSetupView
        self.lblSettingsTextInput.font = UIFont.setupFont(size: 14, fontType: modelSetupView.lblTitleFontType)
        lblSettingsTextInput.text = modelSetupView.lblNameText.rawValue
        lblSettingsTextOptional.text = modelSetupView.lblOptionalText
        lblSettingsTextOptional.font = UIFont.setupFont(size: 14, fontType: modelSetupView.lblOptionalFontType)
        tfSettingsTextInput.placeholder = modelSetupView.placeHolderText.rawValue
        tfSettingsTextInput.keyboardType = UIKeyboardType(rawValue: modelSetupView.keyboardType.rawValue) ?? .default
        tfSettingsTextInput.clearButtonMode = .always
        if modelSetupView.isOptionalText {
            lblSettingsTextOptional.isHidden = false
        } else{
            lblSettingsTextOptional.isHidden = false
        }
        if modelSetupView.isTapGestureTfInput {
            viewTfSettingTextGesture.isHidden = false
        } else {
            viewTfSettingTextGesture.isHidden = true
        }
        self.tfSettingsTextInput.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    @objc func textFieldChanged(_ textField: UITextField){
        let conditionMax = textField.text!.count == modelSetupTextView.maxLenghtText
        let conditionEmpty = textField.text! == ""
        if conditionMax {
            didMaxLenghtText()
        } else if conditionEmpty{
            didTextFieldEmpty()
        } else{
            if (textField.text!.count > modelSetupTextView.maxLenghtText) {
                textField.deleteBackward()
            } else {
                didCurentText()
            }
        }
    }
    
    func didTextFieldEmpty () {
        tfSettingsTextInput.placeholder = modelSetupTextView.placeHolderText.rawValue
        didEmptyText()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetupQR(nibName: ViewInputText.nibName)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetupQR(nibName: ViewInputText.nibName)
    }

    override func awakeFromNib() {
        xibSetupQR(nibName: ViewInputText.nibName)
    }
}

extension ViewInputText {
    func didEmptyText(){
        self.delegate?.didEmptyText(tag: self.tfSettingsTextInput.tag)
    }
    
    func didMaxLenghtText(){
        self.delegate?.didMaxLenghtText(text: fieldTextInput, tag: self.tfSettingsTextInput.tag)
    }
    
    func didCurentText(){
        self.delegate?.didCurrentText(text: fieldTextInput,  tag: self.tfSettingsTextInput.tag)
    }
}
