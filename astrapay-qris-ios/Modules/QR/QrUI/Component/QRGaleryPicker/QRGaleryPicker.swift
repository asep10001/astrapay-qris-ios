//
//  GaleryPicker.swift
//  astrapay
//
//  Created by Sandy Chandra on 17/02/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import Foundation
import UIKit
import Photos

protocol QRGaleryPickerProtocol {
    func didFinishSelectImage(image: UIImage)
    func didFailedSelectImage()
    func didAuthorizedOpenGalery()
    func didDeniedOpenGalery()
}

class QRGaleryPicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker = UIImagePickerController()
    var delegate: QRGaleryPickerProtocol?
    
    override init() {
        super.init()
        self.picker.delegate = self
    }
    
    func checkPermissionGalery() {
        let photos = PHPhotoLibrary.authorizationStatus()
        switch photos {
        case .authorized:
            self.delegate?.didAuthorizedOpenGalery()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({status in
                switch status {
                case .authorized:
                    self.delegate?.didAuthorizedOpenGalery()
                case .denied:
                    self.delegate?.didDeniedOpenGalery()
                case .restricted:
                    self.delegate?.didDeniedOpenGalery()
                case .limited:
                    self.delegate?.didDeniedOpenGalery()
                default:
                    self.delegate?.didDeniedOpenGalery()
                }
            })
        default:
            self.delegate?.didDeniedOpenGalery()
        }
    }
    
    func openGalery(view: UIViewController) {
        DispatchQueue.main.async {
            self.picker.sourceType = .savedPhotosAlbum
            view.present(self.picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.delegate?.didFinishSelectImage(image: image)
        } else {
            self.delegate?.didFailedSelectImage()
        }
    }
}
