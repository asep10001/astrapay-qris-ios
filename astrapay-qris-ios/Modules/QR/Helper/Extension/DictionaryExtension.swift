//
// Created by Gilbert on 2/24/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation
extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .utf8)
    }
}
