//
//  Api.swift
//  PJIOnlineTransport
//
//  Created by Tirta Rivaldi on 7/17/18.
//  Copyright © 2018 Tirta Rivaldi. All rights reserved.
//

import Foundation

class Api: Service {
    
    func base() -> String {
        return baseUrl
    }
    
    func uri(_ route: Route) -> String {
        return "\(baseUrl)\(route.rawValue)/\(callback)"
    }
    
    var addSaldo: String {
        switch BuildModeEndpoint.buildMode {
        case .orion :
            return "https://astrapay.com/webviews/top-up/top-up-method?crafterSite=astrapaycom&account="
        case .cygnus :
            return "https://cms-sit.astrapay.com/webviews/top-up/top-up-method?crafterSite=astrapaycom&account="
        case .vega :
           return "https://cms-sit.astrapay.com/webviews/top-up/top-up-method?crafterSite=astrapaycom&account="
        }
        
    }
    
    var faq: String {
        return "\(coreBaseUrl)/FIFPay/FIFPayFAQ.html"
    }
    
    var faqV2 : String {
        return "\(coreBaseUrl)/FIFPay/FIFPayFAQnew.html"
    }
    
    func uriAstraku(_ route: Route) -> String {
           return "\(baseUrlMobileGateway)/loyalty-service/\(route.rawValue)"
       }
    func uriQR(_ route: Route) -> String {
        return "\(baseUrl)astraku/\(route.rawValue)/\(callback)"
    }
    
    func uriPaymentQR(_ route: Route) -> String {
        return "\(coreBaseUrl)fifpayrest/fif/qr/\(route.rawValue)/\(callback)"
    }
    
    var tncCrafter: String {
        switch BuildModeEndpoint.buildMode {
        case .cygnus:
            return "https://cms-delivery-sit.astrapay.com/webviews/terms-and-conditions"
        case .orion:
            //return "https://orion.astrapay.com/FIFPay/PrivacyPolicy.html"
            //return "\(coreBaseUrl)/FIFPay/PrivacyPolicy.html"
            return "https://www.astrapay.com/webviews/terms-and-conditions"
        case .vega:
            return "https://cms-delivery-uat.astrapay.com/webviews/terms-and-conditions"
        
        }
    }
}


