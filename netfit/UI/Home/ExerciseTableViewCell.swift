//
//  ExerciseTableViewCell.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/15.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import Foundation
import UIKit

class ExerciseTableViewCell: UITableViewCell {
    @IBOutlet var exerciseImageView: UIImageView!
    @IBOutlet var exerciseTitle1Label: UILabel!
    @IBOutlet var exerciseTitle1View: UIView!
    @IBOutlet var exerciseTitle2Label: UILabel!
    @IBOutlet var exerciseTimeLabel: UILabel!
    @IBOutlet var exercisePlayButton: UIButton!
    @IBOutlet var shadowView: ShadowView!
    
    override func awakeFromNib() {
        let coverLayer = CALayer()
        coverLayer.frame = self.exerciseImageView.bounds;
        coverLayer.backgroundColor = UIColor.black.cgColor
        coverLayer.opacity = 0.6
        self.exerciseImageView.layer.addSublayer(coverLayer)
        
        shadowView.layer.cornerRadius = 13
    }
}
