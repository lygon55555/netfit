//
//  InfluencerDetailViewController.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/17.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import Foundation
import UIKit

class InfluencerDetailViewController: UIViewController {
    
    @IBOutlet var trainerProfileImageView: UIImageView!
    @IBOutlet var trainerNameLabel: UILabel!
    @IBOutlet var liveCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true

        liveCollectionView.delegate = self
        liveCollectionView.dataSource = self

        navigationBarDesign()
        
        trainerProfileImageView.image = UIImage(named: "trainer1")
        trainerProfileImageView.layer.borderWidth = 2.2
        trainerProfileImageView.layer.borderColor = UIColor.init(red: 121/255, green: 170/255, blue: 255/255, alpha: 1).cgColor
        trainerProfileImageView.layer.cornerRadius = trainerProfileImageView.frame.size.width / 2
        trainerNameLabel.text = "연남점 핏쌤"
    }
    
    func navigationBarDesign() {
        let leftButton = UIButton(type: UIButton.ButtonType.custom)
        leftButton.setImage(UIImage(named: "backButton"), for: .normal)
        leftButton.addTarget(self, action:#selector(goBack), for: .touchDown)
        leftButton.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItems = [leftBarButton]
        
        let rightButton = UIButton(type: UIButton.ButtonType.custom)
        // 공유 버튼 애셋 없음
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}


extension InfluencerDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = liveCollectionView.dequeueReusableCell(withReuseIdentifier: "LiveCell", for: indexPath) as! LiveCollectionViewCell
        
        if indexPath.row == 0 {
            cell.liveImageView.backgroundColor = UIColor.init(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
            cell.liveImageView.layer.borderColor = UIColor.init(red: 121/255, green: 170/255, blue: 255/255, alpha: 1).cgColor
            cell.liveImageView.layer.borderWidth = 2.2
            cell.liveImageView.layer.cornerRadius = 13
            cell.liveLabel.text = "• Live"
            cell.liveLabel.textColor = UIColor.init(red: 121/255, green: 170/255, blue: 255/255, alpha: 1)
            return cell
        }
        else {
            cell.liveImageView.backgroundColor = UIColor.init(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
            cell.liveImageView.layer.cornerRadius = 13
            cell.liveLabel.text = "07.02"
            return cell
        }
    }
}
