//
//  QRButton.swift
//  astrapay
//
//  Created by Sandy Chandra on 21/10/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//  

import UIKit

protocol QRButtonProtocol {
    func didPressedButton(tag: String)
}

@IBDesignable
class QRButton: UIView {
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var coreButton: UIButton!
    
    var contentView: UIView?
    @IBInspectable var nibName:String? = "QRButton"
    
    var tagString : String = ""
    var delegate: QRButtonProtocol?
    
    let cornerRadius: CGFloat = 8
    
    enum Style {
        case filledBlue
        case nudeBlue
        case clearBlue
        case disabled
        
        var titleColor: UIColor {
            switch self {
            case .filledBlue:
                return QRColor.baseWhiteColor
            case .nudeBlue:
                return QRColor.baseColor
            case .clearBlue:
                return QRColor.baseColor
            case .disabled:
                return QRColor.baseDisabledTitleColor
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .filledBlue:
                return QRColor.baseColor
            case .nudeBlue:
                return QRColor.clear
            case .clearBlue:
                return QRColor.clear
            case .disabled:
                return QRColor.baseDisabledColor
            }
        }
        
        var borderColor: UIColor {
            switch self {
            case .filledBlue:
                return QRColor.baseColor
            case .nudeBlue:
                return QRColor.clear
            case .clearBlue:
                return QRColor.baseColor
            case .disabled:
                return QRColor.baseDisabledColor
            }
        }
        
        var isEnable: Bool {
            switch self {
            case .disabled:
                return false
            default:
                return true
            }
        }
    }
    
    override func layoutSubviews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupInit()
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        guard let nibName = nibName else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
    private func setupInit() {
        self.coreButton.layer.cornerRadius = self.cornerRadius
        self.contentView?.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    
    func setButton(type: Style = .filledBlue, title: String = "", tag: String) {
        self.coreButton.setTitle(title, for: .normal)
        self.coreButton.titleLabel?.font = UIFont.setupFont(size: 14, fontType: .interSemiBold)
        self.coreButton.clipsToBounds = true
        self.coreButton.setTitleColor(type.titleColor, for: .normal)
        self.coreButton.backgroundColor = type.backgroundColor
        self.coreButton.layer.borderColor = type.borderColor.cgColor
        self.coreButton.isEnabled = type.isEnable
        self.coreButton.layer.borderWidth = 1.0
        self.warningLabel.isHidden = true
        self.tagString = tag
    }
    
    func showErrorMessage(string: String) {
        self.warningLabel.text = string
        self.warningLabel.setupLabel(text: string, size: 12, type: .interMedium, color: QRColor.buttonWarningColor)
        self.warningLabel.isHidden = false
    }
    
    func hideErrorMessage() {
        self.warningLabel.text = ""
        self.warningLabel.isHidden = true
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        self.delegate?.didPressedButton(tag: self.tagString)
    }
}
