//
//  SearchViewController.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/18.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet var classCollectionView: UICollectionView!
    @IBOutlet var themeCollectionView: UICollectionView!
    @IBOutlet var topView: UIView!
    @IBOutlet var bottomView: UIView!
    
    let trainerNames: [String] = ["김수연", "원다솜", "김용현"]
    let classNames: [String] = ["일어나란 말이야 지금 잠들때가 아니라 말이야", "삼겹살을 먹으려면 PT를 해야 할껄?", "1:1 발레 자세 교정으로 당당한 걸음을"]
    let trainerImg: [String] = ["trainer0", "trainer1", "trainer2"]
    let classImg: [String] = ["class0", "class1", "class2"]
    
    override func viewDidLoad() {
        classCollectionView.delegate = self
        classCollectionView.dataSource = self
        themeCollectionView.delegate = self
        themeCollectionView.dataSource = self
        
        
        viewDesign()
    }
    
    func viewDesign() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.topView.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.colors = [
            UIColor(red: 219/255, green: 234/255, blue: 255/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0, 0.6]
        topView.layer.insertSublayer(gradientLayer, at: 0)
        
        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.frame = self.bottomView.bounds
        gradientLayer1.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer1.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer1.colors = [
            UIColor(red: 219/255, green: 234/255, blue: 255/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        ]
        gradientLayer1.locations = [0, 0.6]
        bottomView.layer.insertSublayer(gradientLayer1, at: 0)
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == classCollectionView {
            return 6
        }
        else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == classCollectionView {
            let cell = classCollectionView.dequeueReusableCell(withReuseIdentifier: "ClassCell", for: indexPath) as! ClassCollectionViewCell
            
            cell.trainerNameLabel.text = trainerNames[indexPath.row % 3]
            cell.classDescLabel.text = classNames[indexPath.row % 3]
            cell.classImageView.image = UIImage(named: classImg[indexPath.row % 3])
            cell.trainerImageView.image = UIImage(named: trainerImg[indexPath.row % 3])
            cell.cellView.layer.cornerRadius = 10
            cell.cellInfoView.clipsToBounds = true
            cell.cellInfoView.layer.cornerRadius = 10
            cell.cellInfoView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            
            cell.cellView.layer.shadowColor = UIColor(red: 105/255, green: 145/255, blue: 239/255, alpha: 1).cgColor
            cell.cellView.layer.shadowOpacity = 0.3
            cell.cellView.layer.shadowOffset = CGSize(width: 1, height: 1)
            cell.cellView.layer.shadowRadius = 10
            cell.cellView.layer.masksToBounds = false
            
            
            return cell
        }
        else {
            let cell = themeCollectionView.dequeueReusableCell(withReuseIdentifier: "ThemeCell", for: indexPath) as! ThemeCollectionViewCell
            
            cell.trainerNameLabel.text = trainerNames[indexPath.row % 3]
            cell.classDescLabel.text = classNames[indexPath.row % 3]
            cell.classImageView.image = UIImage(named: classImg[indexPath.row % 3])
            cell.trainerImageView.image = UIImage(named: trainerImg[indexPath.row % 3])
            cell.cellView.layer.cornerRadius = 10
            cell.cellInfoView.clipsToBounds = true
            cell.cellInfoView.layer.cornerRadius = 10
            cell.cellInfoView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            
            cell.cellView.layer.shadowColor = UIColor(red: 105/255, green: 145/255, blue: 239/255, alpha: 1).cgColor
            cell.cellView.layer.shadowOpacity = 0.3
            cell.cellView.layer.shadowOffset = CGSize(width: 1, height: 1)
            cell.cellView.layer.shadowRadius = 10
            cell.cellView.layer.masksToBounds = false

            return cell
        }
    }
}
