//
// Created by Gilbert on 3/8/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation

protocol QRTransactionIsProcessViewModelProtocol{
    func goToHome()
    func goToHistoryPage()
}

struct QRTransactionIsProcessViewModel{

    var delegate: QRTransactionIsProcessViewModelProtocol?
    func navigateToHistoryListPage(){
        self.delegate?.goToHome()
        self.delegate?.goToHistoryPage()
    }
}