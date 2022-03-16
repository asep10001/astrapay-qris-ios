//
// Created by Gilbert on 20/12/21.
// Copyright (c) 2021 Astra Digital Arta. All rights reserved.
//

import Foundation
import UIKit


protocol QRNewReaderProtocol {
    func didSuccessGetQRString(string: String)
    func didFailedGetQRString()
}

class QRNewReader {

    var delegate: QRNewReaderProtocol?

    func getQRStringFromImage(image: UIImage) {
        guard let imageCI = CIImage(image: image) else {
            self.delegate?.didFailedGetQRString()
            return
        }
        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                context: nil,
                options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])

        let features = detector?.features(in: imageCI) ?? []

        if features.count == 1 {
            for case let row as CIQRCodeFeature in features {
                self.delegate?.didSuccessGetQRString(string: row.messageString ?? "")
            }
        } else {
            self.delegate?.didFailedGetQRString()
        }

    }
}