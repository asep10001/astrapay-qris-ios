//
//  QRAPPopUpNoteTransferVC.swift
//  astrapay
//
//  Created by Nur Irfan Pangestu on 29/04/20.
//  Copyright © 2020 Tirta Rivaldi. All rights reserved.
//

import UIKit

class QRAPPopUpNoteTransferVC: UIViewController {
    
    var onDismissTapped: ((Bool, String) -> Void)?
    
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var vwSuperContainer: UIView!
    @IBOutlet weak var vwSwipe: UIView!
    @IBOutlet weak var tfInputNote: UITextField!
    @IBOutlet weak var vwButton: QRAPButtonAtom!
    @IBOutlet weak var constantHeightButton: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: QRUILabelInterRegular!
    
    var noteTransfer: String = ""
    
    var isQRNotes : Bool = false
    var maximumText : Int = 50
    
    var isQris: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwSuperContainer.layer.cornerRadius = 20.0
        //self.setHideKeyboardWhenTappedAround()
        self.swipeCloseGesture()
        self.setUIs()
        self.setActions()
        self.checkIsQRInput()
    }
    
    func setupViewDynamic(title: String, keyboardType: KeyboardType, buttonLabel: String) {
        self.titleLabel.text = title
        self.tfInputNote.keyboardType = UIKeyboardType(rawValue: keyboardType.rawValue) ?? UIKeyboardType(rawValue: 0)!
        self.vwButton.coreButton.titleLabel?.text = buttonLabel
    }
    
    private func checkIsQRInput(){
        if isQRNotes {
            maximumText = 200
        }
    }
    
    private func swipeCloseGesture() {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(APInputPinPopUPVC.closeGesture))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func closeGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let velocity = recognizer.velocity(in: self.view)
        
        if recognizer.state == .ended {
            if  velocity.y >= 0 {
                self.onDismissTapped?(false, "")
            }
        }
    }
    
    private func setUIs() {
        self.vwButton.setAtomic(type: .filled, title: "SIMPAN")
        if self.noteTransfer != "Catatan (Opsional)" {
            self.tfInputNote.text = self.noteTransfer
        } else {
            self.tfInputNote.text = ""
        }
    }
    
    private func setActions() {
        self.tfInputNote.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.vwButton.coreButton.addTapGestureRecognizer {
            self.onDismissTapped?(true, self.tfInputNote.text ?? "")
        }
        self.vwContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissThisKeyboard)))
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        let currentText = textField.text ?? ""
        
        if isQris {
            
        } else {
            if currentText.count > maximumText {
                self.tfInputNote.text?.remove(at: currentText.index(before: currentText.endIndex))
            } else {
                if currentText.isEmpty {
                    self.vwButton.setAtomic(type: .filled, title: "SIMPAN", messageError: "")
                    textField.clearButtonMode = .never
                    self.constantHeightButton.constant = 50
                } else {
                    if currentText.count >= 1 && currentText.count <= 3 {
                        self.vwButton.setAtomic(type: .disabled, title: "SIMPAN", messageError: "Minimal 4 Karakter")
                        textField.clearButtonMode = .always
                        self.constantHeightButton.constant = 68
                    } else {
                        self.vwButton.setAtomic(type: .filled, title: "SIMPAN", messageError: "")
                        textField.clearButtonMode = .always
                        self.constantHeightButton.constant = 50
                    }
                }
            }
        }
    }

}
