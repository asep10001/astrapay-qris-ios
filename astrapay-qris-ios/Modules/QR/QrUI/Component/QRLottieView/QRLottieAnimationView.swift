//
//  LottieAnimationView.swift
//  astrapay
//
//  Created by Sandy Chandra on 23/07/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit
import Lottie

@IBDesignable
class QRLottieAnimationView: UIView {

    enum AnimationList: String {
        case successTrx = "successLottie"
        case failedTrx = "failedLottie"
        case loadingState = "loadingLottie"
        case accountInProgress = "inProgressLottie"
    }
    
    var nibName: String? = "LottieAnimationView"
    var identifierName: String = "LottieAnimationViewIdentifier"
    
    //MARK: DEBT show lottie animation, currently using hide and show view from stack view
    
    @IBOutlet weak var successAnimationView: AnimationView!
    @IBOutlet weak var failedAnimationView: AnimationView!
    @IBOutlet weak var loadingAnimationView: AnimationView!
    @IBOutlet weak var inProgressAnimationView: AnimationView!
    @IBOutlet var contentView: UIView!
    
    static var defaultAnimationSpeed: CGFloat = 0.5
    static var defaultLoopMode: LottieLoopMode = .loop
    
    func setupAnimation(animation: AnimationList,
                        animationSpeed: CGFloat = QRLottieAnimationView.defaultAnimationSpeed,
                        loopMode: LottieLoopMode = QRLottieAnimationView.defaultLoopMode) {
        switch animation {
        case .successTrx:
            self.successAnimationView.isHidden = false
            self.failedAnimationView.isHidden = true
            self.loadingAnimationView.isHidden = true
            self.inProgressAnimationView.isHidden = true
            self.doAnimation(view: successAnimationView, animationSpeed: animationSpeed, loopMode: loopMode)
        case .failedTrx:
            self.successAnimationView.isHidden = true
            self.failedAnimationView.isHidden = false
            self.loadingAnimationView.isHidden = true
            self.inProgressAnimationView.isHidden = true
            self.doAnimation(view: failedAnimationView, animationSpeed: animationSpeed, loopMode: loopMode)
        case .loadingState:
            self.successAnimationView.isHidden = true
            self.failedAnimationView.isHidden = true
            self.loadingAnimationView.isHidden = false
            self.inProgressAnimationView.isHidden = true
            self.doAnimation(view: loadingAnimationView, animationSpeed: animationSpeed, loopMode: loopMode)
        case .accountInProgress:
            self.successAnimationView.isHidden = true
            self.failedAnimationView.isHidden = true
            self.loadingAnimationView.isHidden = true
            self.inProgressAnimationView.isHidden = false
            self.doAnimation(view: inProgressAnimationView, animationSpeed: animationSpeed, loopMode: loopMode)
        }
        
    }
    
    func doAnimation(view: AnimationView, animationSpeed: CGFloat, loopMode: LottieLoopMode) {
        view.loopMode = loopMode
        view.animationSpeed = animationSpeed
        view.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        initViewSetup()
    }
    
    func initViewSetup() {
        self.successAnimationView.isHidden = true
        self.failedAnimationView.isHidden = true
        self.loadingAnimationView.isHidden = true
        self.inProgressAnimationView.isHidden = true
        self.contentView.backgroundColor = .clear
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
}
