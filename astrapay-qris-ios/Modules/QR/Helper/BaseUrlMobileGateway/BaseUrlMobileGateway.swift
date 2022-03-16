//
// Created by Gilbert on 26/11/21.
// Copyright (c) 2021 Astra Digital Arta. All rights reserved.
//

import Foundation

var baseUrlMobileGatewayQr: String {
    switch BuildModeEndpoint.buildMode {
    case .cygnus :
        return "https://frontend-sit.astrapay.com"
    case .orion :
        return "https://frontend-sit.astrapay.com"
    case .vega :
        return "https://frontend-sit.astrapay.com"
    }
}