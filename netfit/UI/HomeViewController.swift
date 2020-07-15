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
    
    @IBOutlet var influencerCollectionView: UICollectionView!
    @IBOutlet var exerciseTableView: UITableView!
    @IBOutlet var myInfoView: ShadowView!
    @IBOutlet var weekView: UIView!
    
    var storyNames: [String] = ["김수연", "임다솜", "김용현"]

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
    
    func homeViewDesign() {
        myInfoView.layer.cornerRadius = 15
        weekView.layer.addBorder(edge: UIRectEdge.top, color: UIColor.init(red: 114/255, green: 163/255, blue: 253/255, alpha: 1), thickness: 1)
        weekView.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.init(red: 114/255, green: 163/255, blue: 253/255, alpha: 1), thickness: 1)
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
        return cell
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
        
//        let coverLayer = CALayer()
//        coverLayer.frame = cell.exerciseImageView.bounds;
//        coverLayer.backgroundColor = UIColor.black.cgColor
//        coverLayer.opacity = 0.6
//        cell.exerciseImageView.layer.addSublayer(coverLayer)

        
        return cell
    }

    
    
    
    
    
    
    // custom section header
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "힙업 운동"
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = .clear

        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView.init(frame: CGRect.init(x: 100, y: 0, width: tableView.frame.width, height: 50))
//
//        let label = UILabel()
//        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
//        label.text = "힙업 운동"
//
//        headerView.addSubview(label)
//
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
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
