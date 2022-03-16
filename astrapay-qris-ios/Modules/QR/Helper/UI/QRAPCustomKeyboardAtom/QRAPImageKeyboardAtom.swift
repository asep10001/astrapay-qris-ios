//
//  APImageKeyboardAtom.swift
//  astrapay
//
//  Created by Nur Irfan Pangestu on 04/06/20.
//  Copyright © 2020 Tirta Rivaldi. All rights reserved.
//

import UIKit

class QRAPImageKeyboardAtom: UIView {
    
    
    @IBOutlet weak var coreContainerKeyboard: UIView!
    @IBOutlet weak var coreButtonKeyboard: UIButton!
    @IBOutlet weak var coreImageKeyboard: UIImageView!
    
    
    var contentView:UIView?
    @IBInspectable var nibName:String? = "APImageKeyboardAtom"
    
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
    
    func setAtomic(nameImage: String = "") {
        self.coreImageKeyboard.image = UIImage(named: nameImage)
    }
    
    func tappedButton() {
        func holdDown(sender:UIButton) {
            self.coreContainerKeyboard.backgroundColor = QRBaseColor.QRProperties.baseColor// UIColor(string: "#0376BF")
            self.coreButtonKeyboard.setTitleColor(UIColor.white, for: .normal)
        }
        
        func holdRelease(sender:UIButton) {
            self.coreContainerKeyboard.backgroundColor = UIColor.white
            self.coreButtonKeyboard.setTitleColor(QRBaseColor.QRProperties.baseColor, for: .normal)
        }
        
        func holdDrag(sender:UIButton) {
            self.coreContainerKeyboard.backgroundColor = UIColor.white
            self.coreButtonKeyboard.setTitleColor(QRBaseColor.QRProperties.baseColor, for: .normal)
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
        self.coreImageKeyboard.tintColor = .white
    }
    
    @objc func pressedOut(){
        self.coreContainerKeyboard.backgroundColor = .white
        self.coreImageKeyboard.tintColor = QRBaseColor.QRProperties.baseColor
    }
    
}

