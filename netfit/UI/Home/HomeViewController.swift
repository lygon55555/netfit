//
//  HomeViewController.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/15.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: LottieLoading {
    
    @IBOutlet var gradientView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var influencerCollectionView: UICollectionView!
    @IBOutlet var exerciseTableView: UITableView!
    @IBOutlet var myInfoView: ShadowView!
    @IBOutlet var weekView: UIView!
    @IBOutlet var settingButtonView: UIView!
    @IBOutlet var ddayLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    var storyNames: [String] = ["강하나", "이슬", "한지훈", "푸름샘"]
    var storyImage: [String] = ["kanghana", "leeseul"]
    var themeNames: [String] = ["승모근 스트레칭", "승모근과 팔뚝살 빼기", "전신 다이어트 스트레칭", "층간소음 없는 유산소 운동"]
    var themeTrainer: [String] = ["Trainer_이슬", "Trainer_강하나", "Trainer_강하나", "Trainer_강하나"]
    var runningTime: [Int] = [14, 37, 41, 9]

    override func viewDidLoad() {
        influencerCollectionView.delegate = self
        influencerCollectionView.dataSource = self
        exerciseTableView.delegate = self
        exerciseTableView.dataSource = self
                
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        homeViewDesign()
        
        if UserDefaults.exists(key: UserDefaultKey.boardMessage) {
            messageLabel.text = UserDefaults.standard.string(forKey: UserDefaultKey.boardMessage)
        }
        else {
            messageLabel.text = "목표 메시지를 설정해주세요"
        }
        
        if UserDefaults.exists(key: UserDefaultKey.boardDday) {
            ddayLabel.text = UserDefaults.standard.string(forKey: UserDefaultKey.boardDday)
        }
        else {
            ddayLabel.text = "D-day"
        }
        
//        showLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        if UserDefaults.exists(key: UserDefaultKey.boardMessage) {
            messageLabel.text = UserDefaults.standard.string(forKey: UserDefaultKey.boardMessage)
        }
        else {
            messageLabel.text = "목표 메시지를 설정해주세요"
        }
        
        if UserDefaults.exists(key: UserDefaultKey.boardDday) {
            ddayLabel.text = "D-\(UserDefaults.standard.integer(forKey: UserDefaultKey.boardDday))"
        }
        else {
            ddayLabel.text = "D-day"
        }
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
            UIColor(red: 219/255, green: 234/255, blue: 255/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientView.layer.addSublayer(gradientLayer)
        
        self.exerciseTableView.setValue(UIColor.white , forKey: "tableHeaderBackgroundColor")
        
        settingButtonView.layer.cornerRadius = 8
        settingButtonView.layer.borderColor = UIColor.init(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        settingButtonView.layer.borderWidth = 0.5
    }
}

// MARK: - Influencer Collection View
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storyNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = influencerCollectionView.dequeueReusableCell(withReuseIdentifier: "InfluencerCell", for: indexPath) as! InfluencerCollectionViewCell
        
        cell.profileName.text = storyNames[indexPath.row]
        cell.profileImageView.image = UIImage(named: storyImage[indexPath.row%2])
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! InfluencerCollectionViewCell
        UserDefaults.standard.set(cell.profileName.text, forKey: UserDefaultKey.selectedTrainer)
    }
}

// MARK: - Exercise Table View
extension HomeViewController: UITableViewDelegate, UITableViewDataSource, PlayButtonDelegate {
    
    func tapPlayButton(at index: IndexPath) {
        let cell = exerciseTableView.cellForRow(at: index) as! ExerciseTableViewCell
        UserDefaults.standard.set(cell.exerciseTitle2Label.text, forKey: UserDefaultKey.selectedTheme)
        
        print("index \(index.row)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = exerciseTableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseTableViewCell
        cell.delegate = self
        cell.exerciseImageView.image = UIImage(named: "img2")
        cell.exerciseImageView.layer.cornerRadius = 13
        cell.exerciseTitle1View.layer.cornerRadius = 10
        cell.selectionStyle = .none
        cell.exerciseTitle2Label.text = themeNames[indexPath.row]
        cell.trainerNameLabel.text = themeTrainer[indexPath.row]
        cell.exerciseTimeLabel.text = "\(runningTime[indexPath.row]) min"
        cell.indexPath = indexPath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ExerciseTableViewCell
        UserDefaults.standard.set(cell.exerciseTitle2Label.text, forKey: UserDefaultKey.selectedTheme)
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

extension UserDefaults {
    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
