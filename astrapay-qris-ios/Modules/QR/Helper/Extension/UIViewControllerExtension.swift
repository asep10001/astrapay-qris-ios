//
//  UIViewControllerExtension.swift
//  astrapay
//
//  Created by Sandy Chandra on 21/10/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import Foundation
import UIKit


enum StateLoading {
    case show
    case dismiss
}

extension UIViewController {

    static let QRtagContainer = 10000
    static let QRtagSubview = 10001

    static let QRtagContainerPopUP = 10002
    static let QRtagSubviewPopUP = 10003

    static let QRbtmSheetAnimationDuration = 0.15
    static let QRbtmSheetAnimationCloseDuration = 0.2
    static let QRpopUpAnimationfadeDuration = 0.2

    static let QRtoleranceHeightOfDismissingViewIphoneStandard : CGFloat = 0.5
    static let QRtoleranceHeightOfDismissingViewIphone7More : CGFloat = 0.35

    static var popUpBottomDelegate : PopUpBottomProtocol?
    
    enum NavigationTheme {
        case normal
        case Transparent
        case BlueBase
        
        func primaryColor(on vc: UIViewController) -> UIColor {
            switch self {
            case .normal:
                return QRBaseColor.QRProperties.baseWhiteColor
            case .Transparent:
                return UIColor.clear
            case .BlueBase:
                return QRBaseColor.QRProperties.baseColor//UIColor(string: "#0476bf")
            }
        }
        
        var secondaryColor: UIColor {
            switch self {
            case .normal:
                return UIColor.black
            case .Transparent:
                return UIColor.white
            case .BlueBase:
                return UIColor.white
            }
        }
    }
    
    enum ViewNavigatorType {
        case none
        case back
        case close
        
        var icon: UIImage {
            switch self {
            case .none:
                return UIImage()
            case .back:
                return UIImage(named: "ic_arrow_back")!
            case .close:
                return UIImage(named: "ic_close")!
            }
        }
        
        var callback: Selector {
            switch self {
            case .none:
                return #selector(onBlankTapped)
            case .back:
                return #selector(onBackTapped)
            case .close:
                return #selector(onCloseTapped)
            }
            
        }
        
    }



    @objc private func onBlankTapped() { }
    
    @objc private func onBackTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func onCloseTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func panGestureActs(_ recognizer: UIPanGestureRecognizer) {
        if let viewWithTag = self.view.viewWithTag(UIViewController.QRtagSubview) {
            let height = viewWithTag.frame.height

            var isUseAccsLabelNav = false
            if recognizer.accessibilityLabel == "true"{
                isUseAccsLabelNav = true
            }
            moveView(panGestureRecognizer: recognizer, height: height, isUseNavigationBar: isUseAccsLabelNav)
        }
    }
    func removeBorderNavigationQR(){
        //border in navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupNavigation(theme: NavigationTheme = .normal, title: String, navigator: ViewNavigatorType = .none, navigatorCallback: Selector? = nil) {
        self.setupTitleNavigation(theme: theme, title: title)
        self.setupNavigatorNavigation(theme: theme, type: navigator, navigatorCallback: navigatorCallback)
        self.setupBackgroundNavigation(theme: theme)
    }

    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer, height : CGFloat , isUseNavigationBar : Bool = false) {
        let translation = recognizer.translation(in: view)
        let fullView = UIScreen.main.bounds.height

        if let viewWithTag = self.view.viewWithTag(UIViewController.QRtagSubview) {

            var toleranceHeight : CGFloat {
                let conditionIphone7More = UIScreen.main.bounds.height > 700

                if conditionIphone7More {
                    return UIViewController.QRtoleranceHeightOfDismissingViewIphone7More
                }else {
                    return UIViewController.QRtoleranceHeightOfDismissingViewIphoneStandard
                }
            }

            let minY = viewWithTag.frame.minY
            let conditionClose = translation.y > height * toleranceHeight
            let conditionUnableToTop =  Int(translation.y) + Int(height) <= Int(height)
            let conditionBackToTop = translation.y + minY > height * toleranceHeight
            let isGestureEnded = recognizer.state == .ended
            if conditionUnableToTop {
                var yPos : CGFloat = (fullView - height)
                if !isUseNavigationBar {
                    yPos = yPos + 44
                }
                viewWithTag.frame = CGRect(x: 0,
                        y: yPos ,
                        width: viewWithTag.frame.width,
                        height: viewWithTag.frame.height)
            }else if conditionClose {
                if isGestureEnded {
                    UIView.animate(withDuration: UIViewController.QRbtmSheetAnimationCloseDuration,
                            delay: 0, options: [.allowUserInteraction],
                            animations: {
                                viewWithTag.frame = CGRect(x: 0,
                                        y: self.view.frame.height ,
                                        width: viewWithTag.frame.width,
                                        height: viewWithTag.frame.height)
                            }, completion:  {
                        finished in
                        print(finished)
                        if finished {
                            UIViewController.popUpBottomDelegate?.didDismiss()
                            viewWithTag.isUserInteractionEnabled = true
                            self.removePlaceHolderView()
                            viewWithTag.removeFromSuperview()
                        }
                    })
                }

            }else if conditionBackToTop {

                var yPosEarly : CGFloat = (fullView - height + translation.y)
                if !isUseNavigationBar {
                    yPosEarly = yPosEarly + 44
                }

                viewWithTag.frame = CGRect(x: 0,
                        y: yPosEarly,
                        width: viewWithTag.frame.width,
                        height: viewWithTag.frame.height)


                var yPos : CGFloat = (fullView - viewWithTag.frame.height)
                if !isUseNavigationBar {
                    yPos = yPos + 44
                }

                if isGestureEnded {
                    UIView.animate(withDuration: UIViewController.QRbtmSheetAnimationDuration,
                            delay: 0,
                            options: [.allowUserInteraction],
                            animations: {
                                viewWithTag.isUserInteractionEnabled = false
                                viewWithTag.frame = CGRect(x: 0,
                                        y: yPos,
                                        width: viewWithTag.frame.width,
                                        height: viewWithTag.frame.height)
                            }, completion:  {
                        finished in
                        if finished {
                            viewWithTag.isUserInteractionEnabled = true
                        }
                    })
                }

            }
        }
    }
    
    private func setupTitleNavigation(theme: NavigationTheme, title: String) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = true
        self.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.setupFont(size: 18, fontType: .interBold), NSAttributedString.Key.foregroundColor: theme.secondaryColor]
    }
    
    private func setupNavigatorNavigation(theme: NavigationTheme, type: ViewNavigatorType, navigatorCallback: Selector? = nil) {
        if let callback = navigatorCallback {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: type.icon, style: .plain, target: self, action: callback)
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: type.icon, style: .plain, target: self, action: type.callback)
        }
        self.navigationItem.leftBarButtonItem?.tintColor = theme.secondaryColor
        self.navigationItem.rightBarButtonItem?.tintColor = theme.secondaryColor
    }
    
    private func setupBackgroundNavigation(theme: NavigationTheme) {
        self.navigationController?.navigationBar.barTintColor = theme.primaryColor(on: self)
        
        switch theme {
        case .normal, .BlueBase:
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.backgroundColor = .white
            self.navigationController?.view.backgroundColor = .white
            self.navigationController?.navigationBar.barTintColor = .white
        case .Transparent:
            self.navigationController?.navigationBar.setBackgroundImage (UIImage(), for: .default) //UIImage.init(named: "transparent.png")
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.view.backgroundColor = .clear
            self.navigationController?.navigationBar.barTintColor = .none
            self.navigationController?.navigationBar.barStyle = .default
            self.navigationController?.navigationBar.backgroundColor = .clear
        }
    }

    func showQRPopUpBottomView(withView: UIView, height: CGFloat , isUseNavigationBar : Bool = true){

        let tagPlaceholder = UIViewController.QRtagContainer
        let tagSubView = UIViewController.QRtagSubview


        let viewContainer = UIView()
        viewContainer.frame = UIScreen.main.bounds
        viewContainer.tag = tagPlaceholder
        viewContainer.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        viewContainer.addTapGestureRecognizerQR(action: {
            self.removePlaceHolderView()
        })

        let subView = withView


        subView.frame = CGRect(x: 0,
                y: (UIScreen.main.bounds.height + height),
                width: self.view.frame.width, height: height)
        subView.isUserInteractionEnabled = false
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureActs))

        var accLabel = "false"
        if isUseNavigationBar {
            accLabel = "true"
        }


        gesture.accessibilityLabel = accLabel

        subView.addGestureRecognizer(gesture)
        subView.tag = tagSubView


//        viewContainer.addSubview(subView)

        self.view.addSubview(viewContainer)
        self.view.addSubview(subView)

        var yPos : CGFloat = (UIScreen.main.bounds.height - height)
        if !isUseNavigationBar {
            yPos = yPos + 44
        }
        //Show view with animation
        UIView.animate(withDuration: UIViewController.QRbtmSheetAnimationDuration, animations: {
            subView.frame = CGRect(x: 0,
                    y: yPos,
                    width: self.view.frame.width,
                    height: height)
        }, completion: {
            finished in
            if finished {
                subView.isUserInteractionEnabled = true
            }
        })
    }

    func showPopUpViewQR(withView: UIView, isUseNavigationBar : Bool = true){

        let tagPlaceholder = UIViewController.QRtagContainerPopUP
        let tagSubView = UIViewController.QRtagSubviewPopUP

        let viewContainer = UIView()
        viewContainer.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        viewContainer.tag = tagPlaceholder
        viewContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)


        let subView = withView
        subView.frame = CGRect(x: self.view.frame.width * 0.1,
                y: 0,
                width: self.view.frame.width * 0.8, height: self.view.frame.height)
        subView.isUserInteractionEnabled = true
        subView.layer.zPosition = 2
        subView.tag = tagSubView

        subView.alpha = 0
        viewContainer.alpha = 0
        self.view.addSubview(viewContainer)
        self.view.addSubview(subView)

        UIView.animate(withDuration: UIViewController.QRpopUpAnimationfadeDuration, animations: {
            subView.alpha = 1
            viewContainer.alpha = 1
        }, completion: {
            finished in
            if finished {
                subView.isUserInteractionEnabled = true
            }
        })

        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(viewContainer)
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(subView)

    }

    func dismissPopUpViewQR() {
    if let viewWithTag = self.view.viewWithTag(UIViewController.QRtagContainerPopUP) {
            UIView.animate(withDuration: UIViewController.QRpopUpAnimationfadeDuration, animations: {
                viewWithTag.alpha = 0
            }, completion: {
                finished in
                if finished {
                    viewWithTag.removeFromSuperview()
                }
            })
        }

        if let subViewWithTag = self.view.viewWithTag(UIViewController.QRtagSubviewPopUP) {
            UIView.animate(withDuration: UIViewController.QRpopUpAnimationfadeDuration, animations: {
                subViewWithTag.alpha = 0
            }, completion: {
                finished in
                if finished {

                    subViewWithTag.removeFromSuperview()
                }
            })
        }

        if let viewWithTag = UIApplication.shared.windows.first?.viewWithTag(UIViewController.QRtagContainerPopUP) {
            viewWithTag.removeFromSuperview()
        }

        if let subViewWithTag = UIApplication.shared.windows.first?.viewWithTag(UIViewController.QRtagSubviewPopUP) {
            subViewWithTag.removeFromSuperview()
        }

    }


    private func removePlaceHolderView(){
        if let viewWithTag = self.view.viewWithTag(UIViewController.QRtagContainer) {
            viewWithTag.removeFromSuperview()
        }
        if let subViewWithTag = self.view.viewWithTag(UIViewController.QRtagSubview) {
            subViewWithTag.removeFromSuperview()
        }
    }

    func stateLoadingQR(state: StateLoading) {
        switch state {
        case .show:
            let loadingView = QRLoadingStateView()
            loadingView.setupView()
            loadingView.roundCorners(value: 15)
            popUpStateLoadingQR(withView: loadingView)
//            SVProgressHUD.setDefaultMaskType(.black)
//            SVProgressHUD.show()

        case .dismiss:
            dismissPopupStateLoading()
//            SVProgressHUD.dismiss()
        }
    }
    func popUpStateLoadingQR(withView: UIView) {
        if !UIViewController.isPresentLoading {
            UIViewController.isPresentLoading = true

            let tagPlaceholder = UIViewController.tagContainerLoading
            let tagSubView = UIViewController.tagSubViewLoading

            let widthView: CGFloat = 80
            let heightView: CGFloat = 80

            let viewContainer = UIView()
            viewContainer.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            viewContainer.tag = tagPlaceholder
            viewContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)

            let subView = withView
            subView.frame = CGRect(x: (self.view.frame.width / 2) - (widthView / 2),
                    y: (self.view.frame.height / 2) - (heightView / 2),
                    width: widthView, height: heightView)
            subView.isUserInteractionEnabled = true
            subView.layer.zPosition = 2
            subView.tag = tagSubView

//            self.view.addSubview(viewContainer)
//            self.view.addSubview(subView)

            subView.alpha = 1
            viewContainer.alpha = 1

            UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(viewContainer)
            UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(subView)

        } else {}

    }

}

//MARK: Error

extension QRViewController {
    func showErrorQR() {
//        Alert.show(title: .errorTitle, msg: .errorMsg)
        self.showPopupErrorMessage(message: "Terjadi gangguan pada fitur ini.\nCoba lagi ya nanti.")
    }
}
