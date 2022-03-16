//
//  APButtonAtom.swift
//  astrapay
//
//  Created by Nur Irfan Pangestu on 01/04/20.
//  Copyright © 2020 Tirta Rivaldi. All rights reserved.
//  

import UIKit

@IBDesignable
class QRAPButtonAtom: UIView {
    
    @IBOutlet weak var coreButton: UIButton!
    @IBOutlet weak var coreMessageError: QRUILabelInterMedium!
    
    var contentView:UIView?
    @IBInspectable var nibName:String? = "QRAPButtonAtom"
    
    enum Style {
        case filled
        case nude
        case nudeWhite
        case nudeNoBorder
        case disabled
        case clear
        case hightlight
        case filledYellow
        case hightlightRed
        case hightlightBlue
        case nudeOrange
        case filledGreen
        case filledBlue
        case filledOrange
        case greyNude
        
        var backgroundColor: UIColor {
            switch self {
            case .filled:
                return QRBaseColor.QRProperties.baseColor//UIColor(string: "#0376bf")
            case .nude:
                return UIColor.clear
            case .nudeWhite:
                return UIColor(hexString: "#ffffff")
            case .nudeNoBorder :
                return UIColor(hexString: "#ffffff")
            case .disabled:
                return QRBaseColor.QRProperties.baseDisabledColor//UIColor(string: "#e5e5e5")
            case .clear:
                return UIColor.clear
            case .hightlight:
                return UIColor.clear
            case .filledYellow:
                return QRBaseColor.QRProperties.dandelion
            case .nudeOrange:
                return UIColor.clear
            case .filledGreen:
                return QRBaseColor.borderGreenBtn
            case .filledBlue:
                return UIColor.clear
            case .filledOrange:
                return QRBaseColor.borderOrangeBtn
            case .hightlightRed:
                return UIColor.clear
            case .hightlightBlue:
                return UIColor.clear
            case .greyNude:
                return QRBaseColor.QRProperties.baseDisabledColor
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .filled:
                return UIColor(hexString: "#ffffff")
            case .nude:
                return  QRBaseColor.QRProperties.baseColor//UIColor(string: "#0376bf")
            case .nudeWhite:
                return  QRBaseColor.QRProperties.baseColor//UIColor(string: "#0376bf")
            case .nudeNoBorder:
                return  QRBaseColor.QRProperties.baseColor//UIColor(string: "#0376bf")
            case .disabled:
                return QRBaseColor.disabledTitleColor//UIColor(string: "#ffffff")
            case .clear:
                return QRBaseColor.QRProperties.baseColor//UIColor(string: "#0376bf")
            case .hightlight:
                return UIColor(hexString: "#ffffff")
            case .filledYellow:
                return QRBaseColor.black
            case .nudeOrange:
                return QRBaseColor.borderOrangeBtn
            case .filledGreen:
                return UIColor.white
            case .filledBlue:
                return QRBaseColor.borderBlueBtn
            case .filledOrange:
                return UIColor.white
            case .hightlightRed:
                return QRBaseColor.baseRedColor
            case .hightlightBlue:
                return QRBaseColor.QRProperties.baseColor
            case .greyNude:
                return QRBaseColor.QRProperties.baseColor
            }
        }
        
        var borderColor: UIColor {
            switch self {
            case .filled:
                return  QRBaseColor.QRProperties.baseColor//UIColor(string: "#0376bf")
            case .nude:
                return  QRBaseColor.QRProperties.baseColor//UIColor(string: "#0376bf")
            case .nudeWhite:
                return  QRBaseColor.QRProperties.baseColor//UIColor(string: "#0376bf")
            case .nudeNoBorder:
                return UIColor.clear
            case .disabled:
                return  QRBaseColor.QRProperties.baseDisabledColor//UIColor(string: "#e5e5e5")
            case .clear:
                return UIColor.clear
            case .hightlight:
                return UIColor(hexString: "#ffffff")
            case .filledYellow:
                return QRBaseColor.QRProperties.dandelion
            case .nudeOrange:
                return QRBaseColor.borderOrangeBtn
            case .filledGreen:
                return QRBaseColor.borderGreenBtn
            case .filledBlue:
                return QRBaseColor.borderBlueBtn
            case .filledOrange:
                return QRBaseColor.borderOrangeBtn
            case .hightlightRed:
                return QRBaseColor.baseRedColor
            case .hightlightBlue:
                return QRBaseColor.QRProperties.baseColor
            case .greyNude:
                return UIColor.clear
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
        self.coreButton.layer.cornerRadius = 8
    }
    
    func setAtomic(type: Style = .filled, title: String = "", messageError: String = "") {
        self.coreButton.setTitle(title, for: .normal)
        self.coreButton.setTitleColor(type.titleColor, for: .normal)
        self.coreButton.backgroundColor = type.backgroundColor
        self.coreButton.layer.borderColor = type.borderColor.cgColor
        self.coreButton.isEnabled = type.isEnable
        self.coreButton.layer.borderWidth = 1.0
        
        if !messageError.isEmpty {
            if type.isEnable {
                self.coreMessageError.isHidden = true
            } else {
                self.coreMessageError.isHidden = false
            }
            self.coreMessageError.text = messageError
        } else {
            self.coreMessageError.isHidden = true
        }
        
    }
    
    func setCornerRadius(cornerRadius: CGFloat) {
        self.coreButton.layer.cornerRadius = cornerRadius
    }
    
}
