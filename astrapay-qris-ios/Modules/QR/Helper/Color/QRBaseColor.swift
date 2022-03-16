//
//  BaseQRColor.swift
//  astrapay
//
//  Created by Gilbert on 01/11/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit

class QRBaseColor: UIColor {
    
    //MARK: BASE THEME
    struct QRProperties {
        static let baseColor : UIColor = UIColor(hexString: "#0045e5")
        static let blackColor = UIColor.black
        static let dandelion : UIColor = UIColor(hexString: "#eee809")
        
        static let baseEnabledTitleColor : UIColor = UIColor(hexString: "#333333")
        static let baseEnabledYellowColor : UIColor = UIColor(hexString: "#eee809")
        
        static let baseDisabledColor : UIColor = UIColor(hexString: "#e7eaf3")
        static let baseDisabledTitleColor : UIColor = UIColor(hexString: "#949494")
        
        static let baseWhiteColor : UIColor = UIColor(hexString: "#ffffff")
        
        static let colorOrangeVerifyEmail : UIColor = UIColor(hexString: "#ff8402")
        static let colorGreenVerifyEmail : UIColor = UIColor(hexString: "#47dba5")
        static let colorBlueVerifyEmail : UIColor = UIColor(hexString: "#0045e5")
    }
    
    
    //MARK: BASE BUTTON
    static let disabledColor : UIColor = QRProperties.baseDisabledColor
    static let disabledTitleColor = QRProperties.baseDisabledTitleColor
    
    static let enabledTitleColor = QRProperties.blackColor
    static let enabledColor : UIColor = QRProperties.baseColor
    static let enabledDandelion : UIColor = QRProperties.dandelion
    
    static let borderOrangeBtn : UIColor = QRProperties.colorOrangeVerifyEmail
    static let borderGreenBtn : UIColor = QRProperties.colorGreenVerifyEmail
    static let borderBlueBtn : UIColor = QRProperties.colorBlueVerifyEmail
    
    static let alertWrongColor: UIColor = UIColor(hexString: "#ff7575")
    
    //MARK: LOGIN
    static let loginBtnEnabled = QRProperties.dandelion
    static let loginBtnDisabled = QRProperties.baseDisabledColor
    
    //MARK: PIN
    static let pinPlaceholderColor : UIColor = QRProperties.baseWhiteColor
    
    
    //MARK: POP UP PIN
    static let pinUnfilledColor = QRProperties.baseEnabledTitleColor
    static let pinFilledColor = QRProperties.baseEnabledTitleColor
    static let pinBorder = QRProperties.baseEnabledTitleColor
    
    
    //MARK: Closed Account
    static let subLabelRekening: UIColor = UIColor(hexString: "#666666")
    static let separatorView: UIColor = UIColor(hexString: "#E5E5E5")
    
    //base
//    static let Properties.baseColor : UIColor = UIColor(string: "#0376bf")
//    static let Properties.baseColor : UIColor = UIColor(string: "#0476bf")
    static let baseBorderColor : UIColor = UIColor(hexString: "B2B2B2")
    //theme
   
    
    static let statusBerhasil : UIColor = UIColor(hexString: "#4caf50")
    static let statusDalamProses : UIColor = UIColor(hexString: "#ea9523")
    static let statusGagal : UIColor = UIColor(hexString: "#cf2a2a")

    
    
    //searchbar
    static let borderSearchColor : UIColor = UIColor(hexString: "#333333")
    
    //setings
    static let contactHeaderColor : UIColor = UIColor(hexString : "#D6EFFF")
    //#0376BF
    static let contactColor : UIColor = QRBaseColor.QRProperties.baseColor
    
    static let borderWebColor : UIColor = QRBaseColor.baseBorderColor
    
    //MARK: Red color info
    static let baseRedColor: UIColor = UIColor(hexString: "#e94c4c")
    
    //MARK: Orange cashout steps
    static let orangeCashout: UIColor = UIColor(hexString: "#ff8402")
    static let redAlertCashout: UIColor = UIColor(hexString: "#feb9b9")
    
    //MARK: Info cashout Alto Background
    static let blueAltoCashout: UIColor = UIColor(hexString: "#224685")
    
    //MARK: Gauge color Paylater Maucash
    static let bgColorGauge : UIColor = UIColor(hexString: "#e7eaf3")
    static let progressColorGauge : UIColor = UIColor(hexString: "#0040ee")
    
    //MARK: KYC
    static let greenCorrect: UIColor = UIColor(hexString: "#47dba5")
    static let greyCamera: UIColor = UIColor(hexString: "#d8d8d8")
    
    //MARK: Payment Result
    static let greyInfo: UIColor = UIColor(hexString: "#f1f1f1")
    
    //MARK: Home Reskin
    static let blueStatusUser: UIColor = UIColor(hexString: "#0145e4")
    static let blackSeparatorHome: UIColor = UIColor(hexString: "#272727")
    static let orangeClassic: UIColor = UIColor(hexString: "#de7502")
    static let pinkPreffered: UIColor = UIColor(hexString: "#bb0c78")
    static let purpleSeparatorHome: UIColor = UIColor(hexString: "#8a2aff")
    
    static let disableButtonRegisterText: UIColor = UIColor(hexString: "#87888d")
    
    //MARK: History and Detail
    static let orangeInProgress: UIColor = UIColor(hexString: "#ffba43")
    static let separatorHistory: UIColor = UIColor(hexString: "#efefef")
    
    //MARK: Profile Email Verification
    static let greenVerification: UIColor = UIColor(hexString: "#ebf7ee")
    static let orangeVerification: UIColor = UIColor(hexString: "#fff7ea")
    
    //MARK: Email verification
    static let orangeBgInfo: UIColor = UIColor(hexString: "#fff7ea")
    static let orangeBorderInfo: UIColor = UIColor(hexString: "#ff8500")
    static let orangeBgNotVerify: UIColor = UIColor(hexString: "fee5b9")
    
    static let greySubPaylater: UIColor = UIColor(hexString: "6f6f6f")
}
