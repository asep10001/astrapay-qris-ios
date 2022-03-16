//
//  HomeRouter.swift
//  astrapay-qris-ios
//
//  Created by Asep on 14/03/22.
//

import Foundation
import UIKit

class HomeRouter {
    
    let vc : UIViewController?
    let storyboard =
    UIStoryboard(name: HomeVC.VCProperty.storyboardIdentifier, bundle: nil)
    
    init(viewController : UIViewController) {
        self.vc = viewController
    }
//
//    func navigateToQR(){
//    }
}
