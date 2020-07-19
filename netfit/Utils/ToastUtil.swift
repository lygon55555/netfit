//
//  ToastUtil.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/19.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import Foundation
import UIKit

class ToastUtil {
    static func showToastMessage(controller: UIViewController, toastMsg: String) {
        let alert = UIAlertController(title: nil, message: toastMsg, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            alert.dismiss(animated: true)
        }
    }
}
