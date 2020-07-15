//
//  MainTabBarController.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/15.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    @IBOutlet var mainTabBar: UITabBar!
    
    override func viewDidLoad() {
//        self.mainTabBar.layer.shadowColor = UIColor.white.cgColor
//        self.mainTabBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//        self.mainTabBar.layer.shadowRadius = 5
//        self.mainTabBar.layer.shadowOpacity = 0
//        self.mainTabBar.layer.masksToBounds = false
        
        setupStyle()
    }
    
    func setupStyle() {
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .white, alpha: 1, x: 0, y: -10, blur: 20)
        tabBar.barTintColor = UIColor.init(red: 239/255, green: 244/255, blue: 251/255, alpha: 1)
    }
}

extension CALayer {
    // Sketch 스타일의 그림자를 생성하는 유틸리티 함수
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}

extension UITabBar {
    // 기본 그림자 스타일을 초기화해야 커스텀 스타일을 적용할 수 있다.
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
