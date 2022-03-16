//
//  Service.swift
//  PJIOnlineTransport
//
//  Created by Tirta Rivaldi on 7/18/18.
//  Copyright © 2018 Tirta Rivaldi. All rights reserved.
//

import Foundation

enum BuildMode {
    case cygnus
    case vega
    case orion
}

enum BuildModeUrl: String, Encodable{
    case cygnus = "Cygnus"
    case vega = "Vega"
    case orion = "Orion"
}

struct BuildModeEndpoint {
    //setup endpoin of this app
    static let buildMode : BuildMode = .cygnus
}

//TODO : Becareful with using enum that make this url ambigous, i think it better to use directly on the var/struct
enum BaseUrl: String {
    case orion = "https://orion.astrapay.com"
    case cygnus = "https://cygnus.astrapay.com" // change http to https & delete port :8080
    case vega = "https://vega.astrapay.com"
}

//TODO : Becareful with using enum that make this url ambigous, i think it better to use directly on the var/struct
enum BaseUrlPaylater: String {
    case orion = "https://paylatersvc.astrapay.com"
    case cygnus = "https://paylatersvc-sit.astrapay.com"
    case vega = "https://paylatersvc-uat.astrapay.com"
}

//TODO : Becareful with using enum that make this url ambigous, i think it better to use directly on the var/struct
enum BaseMobile: String {
    case orion = "orion"
    case cygnus = "cygnus"
    case vega = "vega"
}   

//TODO : Becareful with using enum that make this url ambigous, i think it better to use directly on the var/struct
enum BaseIsUrlFifpayrest: String {
    case orion = "https://restapi.astrapay.co.id"
    case cygnus = "https://cygnus.astrapay.com" // change http to https & delete port :8080
    case vega = "https://vega.astrapay.com"
}

var coreBaseUrlQR: String {
    switch BuildModeEndpoint.buildMode {
    case .cygnus :
        return "https://qrengine-dev.astrapay.com/"
    case .orion :
        return "https://lyra.astrapay.com/"
    case .vega :
        return "https://qrengine-dev.astrapay.com/"
    }
}

var coreBaseUrl: String { // for fifpayrest
    switch BuildModeEndpoint.buildMode {
    case .orion:
        return "\(BaseIsUrlFifpayrest.orion.rawValue)/"
    case .cygnus:
        return "\(BaseIsUrlFifpayrest.cygnus.rawValue)/"
    case .vega :
        return "\(BaseIsUrlFifpayrest.vega.rawValue)/"
    }
    
}

var coreQREngineUrl : String{
    switch BuildModeEndpoint.buildMode {
    case .orion:
        return "https://lyra.astrapay.com/"
    case .cygnus:
        return "https://qrengine-dev.astrapay.com/"
    case .vega:
        return "https://qrengine-dev.astrapay.com/"
    }
}

var coreBaseUrlFif: String {
    switch BuildModeEndpoint.buildMode {
    case .cygnus :
        return "\(BaseUrl.cygnus.rawValue)/astrapay/fif/"
    case .orion :
        return "\(BaseUrl.orion.rawValue)/astrapay/fif/"
    case .vega :
        return "\(BaseUrl.vega.rawValue)/astrapay/fif/"
        
    }
}

var coreBaseUrlPLMC: String {
    switch BuildModeEndpoint.buildMode {
    case .cygnus :
        return "\(BaseUrlPaylater.cygnus.rawValue)/"
    case .orion :
        return "\(BaseUrlPaylater.orion.rawValue)/"
    case .vega :
        return "\(BaseUrlPaylater.vega.rawValue)/"
        
    }
}

var baseUrlMobileGateway: String {
    switch BuildModeEndpoint.buildMode {
    case .cygnus :
        return "https://frontend-sit.astrapay.com"
    case .orion :
        return "https://frontend.astrapay.com"
    case .vega :
        return "https://frontend-sit.astrapay.com"
    }
}

var coreCallback: String {
    return "mobile"
}

class Service {
        
    var baseUrl: String {
        switch BuildModeEndpoint.buildMode {
        case .cygnus:
            return "\(BaseUrl.cygnus.rawValue)/astrapay/fif/"
        case .orion :
             return "\(BaseUrl.orion.rawValue)/astrapay/fif/"
        case .vega :
            return "\(BaseUrl.vega.rawValue)/astrapay/fif/"
        }
    }
    
    var baseMobile: String {
        switch BuildModeEndpoint.buildMode {
        case .cygnus:
            return "\(BaseMobile.cygnus.rawValue)"
        case .orion :
            return "\(BaseMobile.orion.rawValue)"
        case .vega :
            return "\(BaseMobile.vega.rawValue)"
        }
        
    }
    
    let callback: String = "mobile"
    
    func baseMobileUrl()-> String {
        return baseMobile
    }
}


var urlOTPToken : String {
    switch BuildModeEndpoint.buildMode {
    case .cygnus:
        return "https://qrotp-dev.astrapay.com/otp-engine/token"
    case .orion:
        return "https://otp-engine.astrapay.com/otp-engine/token"
    case .vega:
        return "https://qrotp-dev.astrapay.com/otp-engine/token"
    }
}

var urlOTPRequest : String
{
    switch BuildModeEndpoint.buildMode {
    case .cygnus:
        return "https://qrotp-dev.astrapay.com/otp-engine/request"
    case .orion:
        return "https://otp-engine.astrapay.com/otp-engine/request"
    case .vega:
        return "https://qrotp-dev.astrapay.com/otp-engine/request"
    }
}

var urlOTPValidation : String
{
    switch BuildModeEndpoint.buildMode {
    case .cygnus:
        return "https://qrotp-dev.astrapay.com/otp-engine/validation"
    case .orion:
        return "https://otp-engine.astrapay.com/otp-engine/validation"
    case .vega:
        return "https://qrotp-dev.astrapay.com/otp-engine/validation"
    }
}

// endpoint api fifpayrest to -> https://restapi.astrapay.com:8443/
//full url : "https://restapi.astrapay.com:8443/fifpayrest/fif/getnotiflist/"

