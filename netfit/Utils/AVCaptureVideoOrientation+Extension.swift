//
//  AVCaptureVideoOrientation+Extension.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/13.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import AVFoundation
import UIKit

extension AVCaptureVideoOrientation {
    init(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .landscapeLeft:
            self = .landscapeLeft
        case .landscapeRight:
            self = .landscapeRight
        case .portrait:
            self = .portrait
        case .portraitUpsideDown:
            self = .portraitUpsideDown
        default:
            self = .portrait
        }
    }
}
