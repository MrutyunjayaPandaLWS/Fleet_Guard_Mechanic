//
//  UiViewControllerExtenssion.swift
//  Hoya Thailand
//
//  Created by syed on 15/02/23.
//

import Foundation
import UIKit
import Lottie


extension UIViewController{

    func lottieAnimation( animationView: LottieAnimationView){
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
    }
    
}

