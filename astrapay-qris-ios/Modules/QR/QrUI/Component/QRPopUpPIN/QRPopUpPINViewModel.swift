//
// Created by Gilbert on 2/24/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation


struct QRPopUpPINViewModel {

    var retryPin: String?

    var warningText: String? {
        switch Int(self.retryPin ?? "0"){
        case 1:
            return "PIN yang kamu masukkan salah"
        case 2:
            return "PIN salah, kamu punya kesempatan 1 kali lagi"
        default:
            return "Tidak terjadi apa apa"
        }
    }

    var isErrorMessageShow: Bool {
        if self.warningText == "Tidak terjadi apa apa"{
            return true
        } else  {
            return false
        }
    }

}