//
//  UIViewExtension.swift
//  astrapay
//
//  Created by Sandy Chandra on 21/10/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import Foundation
import UIKit

enum ShadowPosition {
    case Top
    case Bottom
}
//MARK: SET TAP GESTURE
extension UIView {
    
    fileprivate typealias ActionQR = (() -> Void)?
    
// src : https://medium.com/@sdrzn/adding-gesture-recognizers-with-closures-instead-of-selectors-9fb3e09a8f0b
    fileprivate struct AssociatedObjectKeysQR {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerActionQR: ActionQR? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeysQR.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeysQR.tapGestureRecognizer) as? ActionQR
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func setTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerActionQR = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureQR))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGestureQR(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerActionQR {
            action?()
        } else {
            print("no action")
        }
    }
}

//MARK: LOAD XIB VIEW
extension UIView {
    func xibSetupQR(nibName : String) {
        var containerView = UIView()
        containerView = loadViewFromNibQR(nibName: nibName)
        containerView.frame = bounds
        containerView.autoresizingMask = [ .flexibleWidth, .flexibleHeight]
        addSubview(containerView)
    }

    func loadViewFromNibQR(nibName : String) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}

//MARK: Add tap gesture
extension UIView {

    public func addTapGestureRecognizerQR(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerActionQR = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureQR))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
}

//MARK: Design
extension UIView {
    func QRroundedTop(){
        let path = UIBezierPath(roundedRect: self.bounds,
                byRoundingCorners: [.topLeft,.topRight],
                cornerRadii: CGSize(width: 10, height:  10))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }

func roundedTopMessageQR(isFullScreen : Bool = false){
        DispatchQueue.main.async {
            var bound = CGRect()
            if isFullScreen{
                bound = UIScreen.main.bounds
            }else {
                bound = self.bounds
            }
            let path = UIBezierPath(roundedRect:  bound,
                    byRoundingCorners: [.topRight,.topLeft,.topRight],
                    cornerRadii: CGSize(width: 20, height:  20))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }

    func addShadowQR(cornerRadius: CGFloat = 8.0, position: ShadowPosition = .Bottom) {

        layer.shadowOffset = CGSize(width:0, height:0)
        layer.cornerRadius = cornerRadius
        layer.borderColor = UIColor(red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 0.25).cgColor
        layer.borderWidth = 0.2
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.black.cgColor
        switch position {
        case .Top:
            layer.shadowOffset = CGSize(width: 0, height: -4)
        case .Bottom:
            layer.shadowOffset = CGSize(width: 0, height: 4)
        }
        layer.masksToBounds = false
    }
}
