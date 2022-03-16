//
//  QRCameraControlView.swift
//  astrapay
//
//  Created by Gilbert on 19/10/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit

protocol QRCameraControlViewProtocol {
    func didQRImagePressed()
    func didFlashPressed()
}

class QRCameraControlView: UIView {
    
    var delegate: QRCameraControlViewProtocol?

    @IBOutlet weak var flashImageView: UIImageView!
    @IBOutlet weak var flashImageLabel: UILabel!
    
    
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var qrImageLabel: UILabel!
    
    @IBOutlet weak var flashStackView: UIStackView!
    @IBOutlet weak var imageStackView: UIStackView!
    
    
    static let nibName = "QRCameraControlView"
    static let identifier = "QRCameraControlViewIdentifier"
    
    
    
    func setupView(){
//        self.qrImageView.image = UIImage(named: "icon_pay_picture")
//        self.flashImageView.image = UIImage(named: "icon_flash")
//
//        self.qrImageLabel.text = "Gallery"
//        self.flashImageLabel.text = "Flash"

        qrImageLabel.font = UIFont.setupFont(size: 14, fontType: .interRegular)
        flashImageLabel.font = UIFont.setupFont(size: 14, fontType: .interRegular)
        
        
        self.QRroundedTop()
        self.setupAction() 

    }
    
    func setupAction(){
        imageStackView.addTapGestureRecognizerQR(action: {
            self.delegate?.didQRImagePressed()
        })
        
        flashStackView.addTapGestureRecognizerQR(action: {
            self.delegate?.didFlashPressed()
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetupQR(nibName: QRCameraControlView.nibName)
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetupQR(nibName: QRCameraControlView.nibName)
    }

    override func awakeFromNib() {
        xibSetupQR(nibName: QRCameraControlView.nibName)
    }
    
    

}
