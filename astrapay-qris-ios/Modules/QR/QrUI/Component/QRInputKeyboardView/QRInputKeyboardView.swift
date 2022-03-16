//
//  QRInputKeyboardView.swift
//  astrapay
//
//  Created by Guntur Budi on 09/03/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit

enum QRInputKeyboardViewEnum {
    case one,two,three,four,five,six,seven,eight,nine,tripleZero,zero,delete
}

protocol QRInputKeyboardViewProtocol {
//    func keyPressed(press : InputKeyboardViewEnum)
    func maximumAmountCounted()
    func currentAmount(amount: Double)
}

@IBDesignable
class QRInputKeyboardView: UIView {
 
    @IBOutlet weak var keyboardOne: QRAPCustomKeyboardAtom!
    @IBOutlet weak var keyboardTwo: QRAPCustomKeyboardAtom!
    @IBOutlet weak var keyboardThree: QRAPCustomKeyboardAtom!
    @IBOutlet weak var keyboardFour: QRAPCustomKeyboardAtom!
    @IBOutlet weak var keyboardFive: QRAPCustomKeyboardAtom!
    @IBOutlet weak var keyboardSix: QRAPCustomKeyboardAtom!
    @IBOutlet weak var keyboardSeven: QRAPCustomKeyboardAtom!
    @IBOutlet weak var keyboardEight: QRAPCustomKeyboardAtom!
    @IBOutlet weak var keyboardNine: QRAPCustomKeyboardAtom!
    @IBOutlet weak var keyboardZeroTriple: QRAPCustomKeyboardAtom!
    @IBOutlet weak var keyboardZero: QRAPCustomKeyboardAtom!
    @IBOutlet weak var keyboardRemove: QRAPImageKeyboardAtom!
    
    var delegate : QRInputKeyboardViewProtocol?
    
    private var currentAmount = [String]()
    private var amountString : String = ""
    private var amountDouble : Double = 0
    
    struct ViewProperty{
        
        static let identifier = "QRInputKeyboardViewIdentifier"
        static let nibName = "QRInputKeyboardView"
        static let filterNumber : String = "0123456789"
    }
    static let identifier = ViewProperty.identifier
    static let nibName = ViewProperty.nibName
    
    var maximumAmount : Int?
    
    func setupView(withMaximumAmount : Int?) {
        self.setUIs()
        self.setupAction()
        self.maximumAmount = withMaximumAmount
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetupQR(nibName: QRInputKeyboardView.nibName)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetupQR(nibName: QRInputKeyboardView.nibName)
    }

    override func awakeFromNib() {
        xibSetupQR(nibName: QRInputKeyboardView.nibName)
    }
    
    private func setUIs() {
        self.keyboardOne.backgroundColor = UIColor.clear
        self.keyboardOne.backgroundColor = UIColor.clear
        self.keyboardTwo.backgroundColor = UIColor.clear
        self.keyboardThree.backgroundColor = UIColor.clear
        self.keyboardFour.backgroundColor = UIColor.clear
        self.keyboardFive.backgroundColor = UIColor.clear
        self.keyboardSix.backgroundColor = UIColor.clear
        self.keyboardSeven.backgroundColor = UIColor.clear
        self.keyboardEight.backgroundColor = UIColor.clear
        self.keyboardNine.backgroundColor = UIColor.clear
        self.keyboardZero.backgroundColor = UIColor.clear
        self.keyboardZeroTriple.backgroundColor = UIColor.clear
        self.keyboardRemove.backgroundColor = UIColor.clear
        
        self.keyboardOne.setAtomic(value: "1")
        self.keyboardTwo.setAtomic(value: "2")
        self.keyboardThree.setAtomic(value: "3")
        self.keyboardFour.setAtomic(value: "4")
        self.keyboardFive.setAtomic(value: "5")
        self.keyboardSix.setAtomic(value: "6")
        self.keyboardSeven.setAtomic(value: "7")
        self.keyboardEight.setAtomic(value: "8")
        self.keyboardNine.setAtomic(value: "9")
        self.keyboardZero.setAtomic(value: "0")
        self.keyboardZeroTriple.setAtomic(value: "000")
        self.keyboardRemove.setAtomic(nameImage: "ic_touchUp")
        
        self.keyboardOne.coreButtonKeyboard.tintColor = .blue
    }
    
    private func setupAction(){
        self.keyboardOne.coreButtonKeyboard.addTapGestureRecognizerQR(action: {
//            self.delegate?.keyPressed(press: .one)
            self.onKeyPressed(value: "1")
            self.keyboardOne.animatePressedButton()
        })
        
        self.keyboardTwo.coreButtonKeyboard.addTapGestureRecognizerQR(action: {
//            self.delegate?.keyPressed(press: .two)
            self.onKeyPressed(value: "2")
            self.keyboardTwo.animatePressedButton()
        })
        
        self.keyboardThree.coreButtonKeyboard.addTapGestureRecognizerQR(action: {
//            self.delegate?.keyPressed(press: .three)
            self.onKeyPressed(value: "3")
            self.keyboardThree.animatePressedButton()
        })
        
        self.keyboardFour.coreButtonKeyboard.addTapGestureRecognizerQR(action: {
//            self.delegate?.keyPressed(press: .four)
            self.onKeyPressed(value: "4")
            self.keyboardFour.animatePressedButton()
        })
        
        self.keyboardFive.coreButtonKeyboard.addTapGestureRecognizerQR(action: {
//            self.delegate?.keyPressed(press: .five)
            self.onKeyPressed(value: "5")
            self.keyboardFive.animatePressedButton()
        })
        
        self.keyboardSix.coreButtonKeyboard.addTapGestureRecognizerQR(action: {
//            self.delegate?.keyPressed(press: .six)
            self.onKeyPressed(value: "6")
            self.keyboardSix.animatePressedButton()
        })
        
        self.keyboardSeven.coreButtonKeyboard.addTapGestureRecognizerQR(action: {
//            self.delegate?.keyPressed(press: .seven)
            self.onKeyPressed(value: "7")
            self.keyboardSeven.animatePressedButton()
        })
        
        self.keyboardEight.coreButtonKeyboard.addTapGestureRecognizerQR(action: {
//            self.delegate?.keyPressed(press: .eight)
            self.onKeyPressed(value: "8")
            self.keyboardEight.animatePressedButton()
        })
        
        self.keyboardNine.coreButtonKeyboard.addTapGestureRecognizerQR(action: {
//            self.delegate?.keyPressed(press: .nine)
            self.onKeyPressed(value: "9")
            self.keyboardNine.animatePressedButton()
        })
        
        self.keyboardZeroTriple.coreButtonKeyboard.addTapGestureRecognizerQR(action: {
//            self.delegate?.keyPressed(press: .tripleZero)
            self.onKeyPressed(value: "000")
            self.keyboardZeroTriple.animatePressedButton()
        })
        
        self.keyboardZero.coreButtonKeyboard.addTapGestureRecognizerQR(action: {
//            self.delegate?.keyPressed(press: .zero)
            self.onKeyPressed(value: "0")
            self.keyboardZero.animatePressedButton()
        })
        
        self.keyboardRemove.coreButtonKeyboard.addTapGestureRecognizerQR(action: {
//            self.delegate?.keyPressed(press: .delete)
            self.onRemoveDeleteTapped()
            self.keyboardRemove.animatePressedButton()
        })
    }
    
    private func onKeyPressed(value : String){
        let value = value
        let currentPrice = self.amountString
        let currentPriceNumber = currentPrice.filter(QRInputKeyboardView.ViewProperty.filterNumber.contains)
        if currentPrice == "0" || currentPrice == "000"{
            
        } else {
            let arrayPrice: String = [currentPriceNumber, value].joined(separator: "")
            let intPrice = Int(self.amountDouble)//Int(arrayPrice) ?? 0
            if let maxAmount = maximumAmount, intPrice > maxAmount {
                self.delegate?.maximumAmountCounted()
                return
            }
        }
        self.currentAmount.append(value)
        self.amountDouble = Double(self.currentAmount.joined().filter(QRInputKeyboardView.ViewProperty.filterNumber.contains)) ?? 0
        self.delegate?.currentAmount(amount: amountDouble)
    }
    
    private func onRemoveDeleteTapped() {
        if self.currentAmount.isEmpty {
            self.amountString = "Rp 0"
            self.amountDouble = 0
            self.delegate?.currentAmount(amount: amountDouble)
        } else {
            self.currentAmount.removeAll()
            var fieldPriceNumber: Int = 0
            let currentPrice = self.amountString
            let fieldPriceString = currentPrice.filter(ViewProperty.filterNumber.contains)
            let resultRemovePrice = fieldPriceString.dropLast()
            fieldPriceNumber = Int(resultRemovePrice) ?? 0
            self.amountString = "\(fieldPriceNumber.toIDRQR() ?? "Rp 0")"
            self.currentAmount.append("\(resultRemovePrice)")
            self.amountDouble = Double(self.currentAmount.joined().filter(QRInputKeyboardView.ViewProperty.filterNumber.contains)) ?? 0
            self.delegate?.currentAmount(amount: amountDouble)
        }
    }
    
}
