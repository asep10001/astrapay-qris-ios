//
//  Route.swift
//  astrapay
//
//  Created by Tirta Rivaldi on 10/5/18.
//  Copyright © 2018 Tirta Rivaldi. All rights reserved.
//

import Foundation



enum Route: String {
    case login = "login"
    case logout = "logout"
    case register = "register"
    case profile = "getprofile"
    case balance = "getbalance"
    case region = "getProvince"
    case inquiryforgotpassword = "inquiryforgotpassword"
    case forgotpassword = "forgotpassword"
    case bankList = "getbanklist"
    case addmemberbank = "addMemberBank"
    case getmemberbank = "getMemberBank"
    case removememberbank = "removeMemberBank"
    case profilepage = "profilepage"
    case uploadidentity = "uploadIdentity"
    case uploadidentityotp = "uploadIdentity-otp"
    case changeEmail = "changeEmail"
    case inquirychangemsisdn = "changemsisdn"
    case changemsisdn = "processmsisdn"
    case changepassword = "changepassword"
    case checkbillers = "checkbillers"
    case requestotpbillpay = "requestotpbillpay"
    case sendemail = "sendreceipt"
    case paymentbillers = "paymentbillers"
    case inquiryvatova = "inquiryvatova"
    case transfervatova = "transfervatova"
    case inquiryvatoba = "inquiryvatoba"
    case transfervatoba = "transfervatoba"
    case gethistory = "gethistory2"
    case gethistorypage = "gethistorypage/mobile/"
    case inquiryclosedownaccount = "inquiryclosedownaccount"
    case transferclosedownaccount = "transferclosedownaccount"
    case getjoblist = "getjoblist"
    case checknotifread = "checknotifread"
    
    //Pundi Voucher
    case getListPundiVoucher = "coupons"

    //Astraku
    case getProduct = "vouchers/products"
    case getVoucher = "vouchers"
    case getVoucherById = "getVoucherById"
    case getHistory = "vouchers/history"
    case getBalance = "getBalance"
    case reedemProduct = "vouchers/products/purchase"
    case refreshTokenAstraku = "refreshToken"
    
    
    //uriQR
    case qrGetData = "getdata"
    
    //homeWebview
    case webViewLog = "astrapay/fif/activity/webview/log"
    
    case requestcheckpin = "billerValidatePin"
}


