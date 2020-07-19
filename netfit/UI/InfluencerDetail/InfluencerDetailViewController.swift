//
//  InfluencerDetailViewController.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/17.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import Foundation
import UIKit
import Player

class InfluencerDetailViewController: UIViewController {
    
    @IBOutlet var scrollContentView: UIView!
    @IBOutlet var trainerProfileImageView: UIImageView!
    @IBOutlet var trainerNameLabel: UILabel!
    @IBOutlet var liveCollectionView: UICollectionView!
    @IBOutlet var videoView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var introduceLabel: UILabel!
    

    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true

        liveCollectionView.delegate = self
        liveCollectionView.dataSource = self

        navigationBarDesign()
        scrollViewGradientDesign()
        
        trainerProfileImageView.layer.borderWidth = 2.2
        trainerProfileImageView.layer.borderColor = UIColor.init(red: 121/255, green: 170/255, blue: 255/255, alpha: 1).cgColor
        trainerProfileImageView.layer.cornerRadius = trainerProfileImageView.frame.size.width / 2
        
        
        if let name = UserDefaults.standard.string(forKey: UserDefaultKey.selectedTrainer) {
            print(name)
            
            trainerNameLabel.text = name
            switch(name) {
            case "강하나": trainerProfileImageView.image = UIImage(named: "kanghana")
            case "이슬": trainerProfileImageView.image = UIImage(named: "leeseul")
            case "한지훈": trainerProfileImageView.image = UIImage(named: "kanghana")
            self.titleLabel.text = "입문자를 위한 요가클래스"
            self.descLabel.text = "오늘도 간신히 버텨낸 하루였나요? 몸은 뻐근하게 바쁜 현대인들의 자기관리 시간이 갈수록 줄어들고 있습니다. 하지만 빠듯한 일상 속에서도 건강을 유지하고 아름다운 몸을 만들고 싶은 욕망은 좀처럼 줄어들지 않죠. 그래서 다들 홈트레이닝을 시도하고 계실거에요. 집에서 가볍게 할 수 있는 최고의 맨몸 운동은 요가입니다. 나에게 반드시 필요한 근력과 유연성을 향상시키고 스트레스를 해소시키며 활력을 불어넣는 운동이거든요. 점점 옷차림이 가벼워지는 이 계절, 요가소년과 함께 하루 10분씩 하는 요가로 온몸을 예쁘게 다듬어봅시다."
            self.introduceLabel.text = "반갑습니다, 저는 미국에서 ‘요가소년’ 으로 활동하고 있는 요가 크리에이터 한지훈입니다. “젊고 어리니까 괜찮아” 라는 생각으로 되는대로 살았습니다. 그러던 어느 날, 망가진 나의 몸을 만납니다. 아프지 않은 곳이 없더라고요. 그렇게 요가를 만났습니다. 그리고 지금은 하루 대부분의 시간을 요가로 채우고 있지요. 요가로 즐겁습니다. 그 즐거움을 보다 더 많은 이들과 나누고 싶네요. 하루에 단 10분, 15분이라도 내 몸에 귀를 기울이며 동작 하나하나를 함께 할게요. 저와 함께 매일 조금씩 틈을 내는 동안 내 몸의 근력과 유연성이 향상 되고, 그로 하여금 체형과 자세도 균형있게 다듬어 질 것입니다."
            case "푸름샘": trainerProfileImageView.image = UIImage(named: "leeseul")
                self.titleLabel.text = "우아한 발레핏 홈트"
                self.descLabel.text = "렛츠발레핏 프로그램은 근력운동 + 유산소 + 스트레칭 + 자세교정이 합쳐져 체중 감량은 물론 군살 없고 탄력 있는 몸을 만들어줘요. 헬스, 필라테스, 요가, 격투기, 크로스핏까지 많은 운동을 해보신 운동 매니아분도 “발레가 제일 힘든 것 같아요!” 라고 하소연 할 정도로 다이어트 효과를 확실히 보장합니다. 발레핏은 발레 동작을 익히는 동시에 전신 근육을 자극하여 체중을 감량하고, 내 몸의 발란스를 스스로 찾게 해주는 수업이에요. 아름다운 클래식 음악과 함께 발레 동작을 연습하다 보면 운동 효과는 물론 잡생각이나 묵은 스트레스까지 싹~ 사라진답니다."
                self.introduceLabel.text = "렛츠발레핏 푸름샘입니다."
            default: break
            }
        }
    }
    
    func scrollViewGradientDesign() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.scrollContentView.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.colors = [
            UIColor(red: 219/255, green: 234/255, blue: 255/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0, 0.8]
        scrollContentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func navigationBarDesign() {
        let rect:CGRect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 65, height: 30))
        let titleView: UIView = UIView.init(frame: rect)
        let titleImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 65, height: 24))
        titleImage.image = UIImage(named: "netfitLogo")
        titleImage.contentMode = .scaleAspectFit
        titleView.addSubview(titleImage)
        self.navigationItem.titleView = titleView
        
        let leftButton = UIButton(type: UIButton.ButtonType.custom)
        leftButton.setImage(UIImage(named: "backButton"), for: .normal)
        leftButton.addTarget(self, action:#selector(goBack), for: .touchDown)
        leftButton.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItems = [leftBarButton]
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyButton(_ sender: Any) {
        ToastUtil.showToastMessage(controller: self, toastMsg: "수강 신청 완료")
    }
}

extension InfluencerDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = liveCollectionView.dequeueReusableCell(withReuseIdentifier: "LiveCell", for: indexPath) as! LiveCollectionViewCell
        
        cell.liveImageView.image = UIImage(named: "\(indexPath.row+1)")
        cell.liveImageView.layer.cornerRadius = 13
        cell.liveLabel.text = "07.02"

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let exerciseViewController = mainStoryboard.instantiateViewController(withIdentifier: "ExerciseVC") as! ExerciseViewController
        switch indexPath.row {
        case 0: UserDefaults.standard.set("승모근 스트레칭", forKey: UserDefaultKey.selectedTheme)
        case 1: UserDefaults.standard.set("승모근과 팔뚝살 빼기", forKey: UserDefaultKey.selectedTheme)
        case 2: UserDefaults.standard.set("승모근 스트레칭", forKey: UserDefaultKey.selectedTheme)
        case 3: UserDefaults.standard.set("층간소음 없는 유산소 운동", forKey: UserDefaultKey.selectedTheme)
        case 4: UserDefaults.standard.set("전신 다이어트 스트레칭", forKey: UserDefaultKey.selectedTheme)
        default: break
        }
        self.navigationController?.pushViewController(exerciseViewController, animated: true)
    }
}
