//
//  VideoViewController.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/14.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import UIKit
import AVKit
import CoreVideo
import VersaPlayer

class VideoViewController: UIViewController {
    
    var playerView = VersaPlayerView()
    var videoView = UIView()
    
    override func viewDidLoad() {
        videoView.frame = view.bounds
        videoView.layer.borderWidth = 0.0
        videoView.clipsToBounds = true
        videoView.contentMode = .scaleAspectFill
        view.addSubview(videoView)
        videoView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        videoView.isUserInteractionEnabled = true
        
        playVideo(from: "pilatesVideo.mov")
        
//        if let url = URL.init(string: "pilatesVideo.mov") {
//            let item = VersaPlayerItem(url: url)
//            playerView.set(item: item)
//        }
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        playVideo(from: "pilatesVideo.mov")
//    }
    
    override func viewDidLayoutSubviews() {
        
//        self.videoView.frame = self.view.bounds
//        videoView.contentMode = .scaleAspectFill
//        videoView.autoresizingMask = .flexibleHeight
    }
    
    func playVideo(from file:String) {
        let file = file.components(separatedBy: ".")

        guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
            debugPrint( "\(file.joined(separator: ".")) not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(playerLayer)
        player.play()
    }
}
