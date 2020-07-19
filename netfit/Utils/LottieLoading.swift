//
//  LottieLoading.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/19.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import UIKit
import Lottie

class LottieLoading: UIViewController {
    let loadingView = AnimationView(name: "heart.json")
    
    func showLoading() {
        print("START")
        
        loadingView.frame       = self.view.frame
        loadingView.center      = self.view.center
        loadingView.contentMode = .center
        loadingView.loopMode    = .loop
        
        self.view.addSubview(loadingView)
        loadingView.play()
    }
    
    func hideLoading() {
        loadingView.stop()
        loadingView.removeFromSuperview()
    }
}
