//
//  APCustomKeyboardAtom.swift
//  astrapay
//
//  Created by Nur Irfan Pangestu on 24/04/20.
//  Copyright © 2020 Tirta Rivaldi. All rights reserved.
//

import UIKit

class QRAPCustomKeyboardAtom: UIView {
    
    enum CoreTitleType {
        case label
        case image
    }
    
    @IBOutlet weak var coreContainerKeyboard: UIView!
    @IBOutlet weak var coreButtonKeyboard: UIButton!
    @IBOutlet weak var coreLabelKeyboard: QRUILabelInterSemiBold!

    var contentView:UIView?
    @IBInspectable var nibName:String? = "APCustomKeyboardAtom"
    
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
        self.coreContainerKeyboard.layer.cornerRadius = 17
        self.coreContainerKeyboard.layer.masksToBounds = true
        self.coreContainerKeyboard.addShadowQR(cornerRadius: 17)
        self.coreButtonKeyboard.titleLabel?.font = UIFont.setupFont(size: 24, fontType: .interBold)
    }
    
    func setAtomic(value: String = "", typeButton: CoreTitleType = .label) {
        switch typeButton {
        case .label:
            self.coreButtonKeyboard.setTitle(value, for: .normal)
            self.coreLabelKeyboard.text = value
        case .image:
            self.coreButtonKeyboard.setImage(UIImage(named: "ic_arrow_back"), for: .normal)
        }
        
    }
    
    func tappedButton() {
        func holdDown(sender:UIButton) {
            self.coreContainerKeyboard.backgroundColor = QRBaseColor.QRProperties.baseColor// UIColor(string: "#0376BF")
            self.coreLabelKeyboard.textColor = UIColor.white
        }
        
        func holdRelease(sender:UIButton) {
            self.coreContainerKeyboard.backgroundColor = UIColor.white
            self.coreLabelKeyboard.textColor = QRBaseColor.QRProperties.baseColor// UIColor(string: "#0376BF")
        }
        
        func holdDrag(sender:UIButton) {
            self.coreContainerKeyboard.backgroundColor = UIColor.white
            self.coreLabelKeyboard.textColor = QRBaseColor.QRProperties.baseColor// UIColor(string: "#0376BF")
        }
        
        self.coreButtonKeyboard.addTarget(self, action: Selector(("holdRelease:")), for: .touchUpInside);
        self.coreButtonKeyboard.addTarget(self, action: Selector(("holdDown:")), for: .touchDown)
        
        self.coreButtonKeyboard.addTarget(self, action: Selector(("holdDrag:")), for: .touchDragInside)
        self.coreButtonKeyboard.addTarget(self, action: Selector(("holdDrag:")), for: .touchDragOutside)
        self.coreButtonKeyboard.addTarget(self, action: Selector(("holdDrag:")), for: .touchDragEnter)
        self.coreButtonKeyboard.addTarget(self, action: Selector(("holdDrag:")), for: .touchDragExit)
        
    }
    
    func animatePressedButton() {
        self.coreButtonKeyboard.addTarget(self, action: #selector(pressedIn), for: .touchDown)
        
        self.coreButtonKeyboard.addTarget(self, action: #selector(pressedOut), for: .touchCancel)
        self.coreButtonKeyboard.addTarget(self, action: #selector(pressedOut), for: .touchDragExit)
    }
    
    @objc func pressedIn(){
        self.coreContainerKeyboard.backgroundColor = QRBaseColor.QRProperties.baseColor
        self.coreLabelKeyboard.textColor = .white
    }
    
    @objc func pressedOut(){
        self.coreContainerKeyboard.backgroundColor = .white
        self.coreLabelKeyboard.textColor = QRBaseColor.QRProperties.baseColor
    }
}

