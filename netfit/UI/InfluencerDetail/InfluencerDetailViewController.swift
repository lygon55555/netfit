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
    private var player = Player()
    
    deinit {
        self.player.willMove(toParent: nil)
        self.player.view.removeFromSuperview()
        self.player.removeFromParent()
    }

    override func viewDidLoad() {
        self.player.playerDelegate = self
        self.player.playbackDelegate = self
        self.videoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.player.fillMode = .resizeAspectFill
        self.player.view.layer.frame = self.videoView.bounds
        self.addChild(self.player)
        self.videoView.addSubview(self.player.view)
        self.player.didMove(toParent: self)
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.player.view.addGestureRecognizer(tapGestureRecognizer)
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        self.tabBarController?.tabBar.isHidden = true

        liveCollectionView.delegate = self
        liveCollectionView.dataSource = self

        navigationBarDesign()
        scrollViewGradientDesign()
        
        trainerProfileImageView.image = UIImage(named: "trainer1")
        trainerProfileImageView.layer.borderWidth = 2.2
        trainerProfileImageView.layer.borderColor = UIColor.init(red: 121/255, green: 170/255, blue: 255/255, alpha: 1).cgColor
        trainerProfileImageView.layer.cornerRadius = trainerProfileImageView.frame.size.width / 2
        trainerNameLabel.text = "연남점 핏쌤"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let file = "pilatesVideo.mov".components(separatedBy: ".")
        guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
            debugPrint( "\(file.joined(separator: ".")) not found")
            return
        }
        self.player.url = URL(fileURLWithPath: path)
        self.player.playFromBeginning()
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
    
    @IBAction func timeTableButton(_ sender: Any) {
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

extension InfluencerDetailViewController: PlayerDelegate {
    func playerReady(_ player: Player) {
        print("\(#function) ready")
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        print("\(#function) \(player.playbackState.description)")
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        print("\(#function) error.description")
    }
}

extension InfluencerDetailViewController: PlayerPlaybackDelegate {
    func playerCurrentTimeDidChange(_ player: Player) {
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
    }

    func playerPlaybackDidLoop(_ player: Player) {
    }
}

extension InfluencerDetailViewController {
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        switch self.player.playbackState {
        case .stopped:
            self.player.playFromBeginning()
            break
        case .paused:
            self.player.playFromCurrentTime()
            break
        case .playing:
            self.player.pause()
            break
        case .failed:
            self.player.pause()
            break
        }
    }
}
