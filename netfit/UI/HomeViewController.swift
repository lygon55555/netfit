//
//  HomeViewController.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/15.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var gradientView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var influencerCollectionView: UICollectionView!
    @IBOutlet var exerciseTableView: UITableView!
    @IBOutlet var myInfoView: ShadowView!
    @IBOutlet var weekView: UIView!
    
    var storyNames: [String] = ["김수연", "원다솜", "김용현"]

    override func viewDidLoad() {
        influencerCollectionView.delegate = self
        influencerCollectionView.dataSource = self
        exerciseTableView.delegate = self
        exerciseTableView.dataSource = self
                
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        homeViewDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
        
    func homeViewDesign() {
        myInfoView.layer.cornerRadius = 15
        weekView.layer.addBorder(edge: UIRectEdge.top, color: UIColor.init(red: 114/255, green: 163/255, blue: 253/255, alpha: 1), thickness: 1)
        weekView.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.init(red: 114/255, green: 163/255, blue: 253/255, alpha: 1), thickness: 1)
        
        let rect:CGRect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 65, height: 30))
        let titleView: UIView = UIView.init(frame: rect)

        let titleImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 65, height: 24))
        titleImage.image = UIImage(named: "netfitLogo")
        titleImage.contentMode = .scaleAspectFit
        titleView.addSubview(titleImage)

        self.navigationItem.titleView = titleView
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.gradientView.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.colors = [
            UIColor(red: 105/255, green: 145/255, blue: 239/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0, 0.6]
        gradientView.layer.addSublayer(gradientLayer)
        
        
        
        self.exerciseTableView.setValue(UIColor.white , forKey: "tableHeaderBackgroundColor")

    }
    
    func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 + 0.5
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 0.5)
    }
    
    
    
    
    
    
}

// MARK: - Influencer Collection View
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = influencerCollectionView.dequeueReusableCell(withReuseIdentifier: "InfluencerCell", for: indexPath) as! InfluencerCollectionViewCell
        
        cell.profileName.text = storyNames[indexPath.row % 3]
        cell.profileImageView.image = UIImage(named: "img1")
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2
        
        if cell.isSelected {
            cell.profileImageView.layer.borderWidth = 2
            cell.profileImageView.layer.borderColor = UIColor.init(red: 121/255, green: 170/255, blue: 255/255, alpha: 1).cgColor
        }
        else {
            cell.profileImageView.layer.borderWidth = 0
            cell.profileImageView.layer.borderColor = UIColor.clear.cgColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! InfluencerCollectionViewCell
        cell.profileImageView.layer.borderWidth = 0
        cell.profileImageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! InfluencerCollectionViewCell
        cell.profileImageView.layer.borderWidth = 3
        cell.profileImageView.layer.borderColor = UIColor.init(red: 121/255, green: 170/255, blue: 255/255, alpha: 1).cgColor
    }
}

// MARK: - Exercise Table View
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = exerciseTableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseTableViewCell
        cell.exerciseImageView.image = UIImage(named: "img2")
        cell.exerciseImageView.layer.cornerRadius = 13
        cell.exerciseTitle1View.layer.cornerRadius = 10
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ExerciseTableViewCell
        cell.exerciseImageView.layer.sublayers?[0].backgroundColor = UIColor.white.cgColor
        cell.exerciseImageView.layer.sublayers?[0].opacity = 0.54
        
        let coverLayer = CALayer()
        coverLayer.frame = cell.exerciseTitle1View.bounds;
        coverLayer.backgroundColor = UIColor.white.cgColor
        coverLayer.opacity = 0.54
        cell.exerciseTitle1View.layer.addSublayer(coverLayer)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ExerciseTableViewCell
        cell.exerciseImageView.layer.sublayers?[0].backgroundColor = UIColor.black.cgColor
        cell.exerciseImageView.layer.sublayers?[0].opacity = 0.6
        
        cell.exerciseTitle1View.layer.sublayers?[1].removeFromSuperlayer()
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        let label = UILabel()
        label.text = "힙업 운동"
        label.frame = CGRect(x: 30, y: 5, width: 100, height: 35)
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy)
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    
    
    
    
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view:
//    UIView, forSection section: Int) {
//
//        switch section {
//        case 0:
//            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn, .curveEaseOut, .allowUserInteraction], animations: {() -> Void in
//                self.exerciseTableView.backgroundColor = UIColor.cyan.withAlphaComponent(0.4)
//
//            })
//
//        case 1:
//            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn, .curveEaseOut, .allowUserInteraction], animations: {() -> Void in
//                self.exerciseTableView.backgroundColor = UIColor.green.withAlphaComponent(0.4)
//
//            })
//
//        case 2:
//            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn, .curveEaseOut, .allowUserInteraction], animations: {() -> Void in
//                self.exerciseTableView.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
//
//            })
//
//        case 3:
//            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn, .curveEaseOut, .allowUserInteraction], animations: {() -> Void in
//                self.exerciseTableView.backgroundColor = UIColor.orange.withAlphaComponent(0.4)
//
//            })
//
//        case 4:
//            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn, .curveEaseOut, .allowUserInteraction], animations: {() -> Void in
//                self.exerciseTableView.backgroundColor = UIColor.magenta.withAlphaComponent(0.4)
//
//            })
//
//        default:
//            self.exerciseTableView.backgroundColor = UIColor.brown
//        }
//    }
    
    
    
    
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        for layer in self.view.layer.sublayers! {
//            if layer .isKind(of: CAGradientLayer.self) {
//                layer.removeFromSuperlayer()
//            }
//        }
//        let gradient = CAGradientLayer()
//        gradient.frame = self.view.bounds
//        gradient.colors = [self.generateRandomColor().cgColor, self.generateRandomColor().cgColor]
//        let anim:CABasicAnimation = CABasicAnimation.init(keyPath: "opacity")
//        anim.fromValue = 0.5
//        anim.toValue = 1
//        anim.duration = 1.0
//        gradient.add(anim, forKey: "opacity")
//        self.view.layer.addSublayer(gradient)
//        self.view.layoutIfNeeded()
//    }
}


extension CALayer {
  func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
    let border = CALayer()

    switch edge {
    case UIRectEdge.top:
        border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)

    case UIRectEdge.bottom:
        border.frame = CGRect(x:0, y: frame.height - thickness, width: frame.width, height:thickness)

    case UIRectEdge.left:
        border.frame = CGRect(x:0, y:0, width: thickness, height: frame.height)

    case UIRectEdge.right:
        border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)

    default: do {}
    }

    border.backgroundColor = color.cgColor

    addSublayer(border)
 }
}
