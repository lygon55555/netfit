//
//  MyClassViewController.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/17.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import Foundation
import UIKit

class MyClassViewController: UIViewController {
    
    @IBOutlet var topView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var myClass0CollectionView: UICollectionView!
    @IBOutlet var myClass1CollectionView: UICollectionView!
    @IBOutlet var myClass0TitleLabel: UILabel!
    @IBOutlet var myClass1TitleLabel: UILabel!
    
    let trainerNames: [String] = ["김수연", "원다솜", "김용현"]
    let classNames: [String] = ["일어나란 말이야 지금 잠들때가 아니라 말이야", "삼겹살을 먹으려면 PT를 해야 할껄?", "1:1 발레 자세 교정으로 당당한 걸음을"]
    let trainerImg: [String] = ["trainer0", "trainer1", "trainer2"]
    let classImg: [String] = ["class0", "class1", "class2"]
    
    override func viewDidLoad() {
        myClass0CollectionView.delegate = self
        myClass0CollectionView.dataSource = self
        myClass1CollectionView.delegate = self
        myClass1CollectionView.dataSource = self
        
        let string0 = "AI코칭 수강 클래스 x3"
        let string1 = "실시간 트레이닝 코칭 수강 클래스 x5"
        
        let attributedString0: NSMutableAttributedString  = NSMutableAttributedString(string: string0)
        attributedString0.setColor(color: UIColor.init(red: 47/255, green: 47/255, blue: 47/255, alpha: 1), forText: "AI코칭 수강 클래스")
        attributedString0.setColor(color: UIColor.init(red: 36/255, green: 116/255, blue: 254/255, alpha: 1), forText: "x3")
        myClass0TitleLabel.attributedText = attributedString0
        
        let attributedString1: NSMutableAttributedString  = NSMutableAttributedString(string: string1)
        attributedString1.setColor(color: UIColor.init(red: 47/255, green: 47/255, blue: 47/255, alpha: 1), forText: "실시간 트레이닝 코칭 수강 클래스")
        attributedString1.setColor(color: UIColor.init(red: 36/255, green: 116/255, blue: 254/255, alpha: 1), forText: "x5")
        myClass1TitleLabel.attributedText = attributedString1
        
        viewDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func viewDesign() {
        let rect:CGRect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 65, height: 30))
        let titleView: UIView = UIView.init(frame: rect)

        let titleImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 65, height: 24))
        titleImage.image = UIImage(named: "netfitLogo")
        titleImage.contentMode = .scaleAspectFit
        titleView.addSubview(titleImage)

        self.navigationItem.titleView = titleView
        
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
        
//        let gradientLayer2 = CAGradientLayer()
//        gradientLayer2.frame = self.myClass0CollectionView.bounds
//        gradientLayer2.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer2.endPoint = CGPoint(x: 1, y: 0.5)
//        gradientLayer2.colors = [
//            UIColor(red: 219/255, green: 234/255, blue: 255/255, alpha: 1).cgColor,
//            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
//        ]
//        gradientLayer2.locations = [0, 0.4]
//        let gradientView = UIView(frame: self.myClass0CollectionView.bounds)
//        gradientView.layer.insertSublayer(gradientLayer2, at: 0)
//        myClass0CollectionView.backgroundView = gradientView
//
//
//        let gradientLayer3 = CAGradientLayer()
//        gradientLayer3.frame = self.myClass1CollectionView.bounds
//        gradientLayer3.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer3.endPoint = CGPoint(x: 1, y: 0.5)
//        gradientLayer3.colors = [
//            UIColor(red: 219/255, green: 234/255, blue: 255/255, alpha: 1).cgColor,
//            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
//        ]
//        gradientLayer3.locations = [0, 0.4]
//        let gradientView1 = UIView(frame: self.myClass1CollectionView.bounds)
//        gradientView1.layer.insertSublayer(gradientLayer3, at: 0)
//        myClass1CollectionView.backgroundView = gradientView1
    }
}

extension MyClassViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == myClass0CollectionView {
            return 6
        }
        else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == myClass0CollectionView {
            let cell = myClass0CollectionView.dequeueReusableCell(withReuseIdentifier: "MyClass0Cell", for: indexPath) as! MyClass0CollectionViewCell
            
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
            let cell = myClass1CollectionView.dequeueReusableCell(withReuseIdentifier: "MyClass1Cell", for: indexPath) as! MyClass1CollectionViewCell
            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == myClass0CollectionView {
            UserDefaults.standard.set("이슬", forKey: UserDefaultKey.selectedTrainer)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let exerciseViewController = mainStoryboard.instantiateViewController(withIdentifier: "InfluencerDetailVC") as! InfluencerDetailViewController
            self.navigationController?.pushViewController(exerciseViewController, animated: true)
        }
        else {
            UserDefaults.standard.set("한지훈", forKey: UserDefaultKey.selectedTrainer)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let exerciseViewController = mainStoryboard.instantiateViewController(withIdentifier: "InfluencerDetailVC") as! InfluencerDetailViewController
            self.navigationController?.pushViewController(exerciseViewController, animated: true)
        }
    }
}

extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
}
