//
//  ViewController.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/13.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import AVFoundation
import UIKit
import VideoToolbox
import AVKit
import CoreVideo

class ViewController: UIViewController {

//    @IBOutlet var videoView: UIView!
//    @IBOutlet var cameraView: UIView!
//    @IBOutlet var poseCameraView: PoseImageView!

//    private let videoCapture = VideoCapture()
//    private var poseNet: PoseNet!
//    private var currentFrame: CGImage?
//    private var algorithm: Algorithm = .single
//    private var poseBuilderConfiguration = PoseBuilderConfiguration()
    
//    var splitVC = SplitViewController()
//    var cameraVC = CameraViewController()
//    var videoVC = VideoViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.addChild(splitVC)
//        splitVC.view.frame = self.view.bounds
//        splitVC.view.autoresizingMask = .flexibleHeight
//        self.view.addSubview(splitVC.view)
//        splitVC.didMove(toParent: self)
//        splitVC.arrangement = .vertical
//
//        splitVC.firstChild = videoVC
//        splitVC.secondChild = cameraVC
        
//        splitVC.firstChild = cameraVC
//        splitVC.secondChild = videoVC
        
//        UIApplication.shared.isIdleTimerDisabled = true
//
//        do {
//            poseNet = try PoseNet()
//        } catch {
//            fatalError("Failed to load model. \(error.localizedDescription)")
//        }
//
//        poseNet.delegate = self
//        setupAndBeginCapturingVideoFrames()
        
//        playVideo(from: "pilatesVideo.mov")
        
        
    }
    
//    func playVideo(from file:String) {
//        let file = file.components(separatedBy: ".")
//
//        guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
//            debugPrint( "\(file.joined(separator: ".")) not found")
//            return
//        }
//        let player = AVPlayer(url: URL(fileURLWithPath: path))
//
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.videoView.bounds
//        playerLayer.videoGravity = .resizeAspectFill
//        self.videoView.layer.addSublayer(playerLayer)
//        player.play()
//    }

//    private func setupAndBeginCapturingVideoFrames() {
//        videoCapture.setUpAVCapture { error in
//            if let error = error {
//                print("Failed to setup camera with error \(error)")
//                return
//            }
//
//            self.videoCapture.delegate = self
//            self.videoCapture.startCapturing()
//        }
//    }

//    override func viewWillDisappear(_ animated: Bool) {
//        videoCapture.stopCapturing {
//            super.viewWillDisappear(animated)
//        }
//    }
//
//    override func viewWillTransition(to size: CGSize,
//                                     with coordinator: UIViewControllerTransitionCoordinator) {
//        // Reinitilize the camera to update its output stream with the new orientation.
//        setupAndBeginCapturingVideoFrames()
//    }
}

//// MARK: - VideoCaptureDelegate
//
//extension ViewController: VideoCaptureDelegate {
//    func videoCapture(_ videoCapture: VideoCapture, didCaptureFrame capturedImage: CGImage?) {
//        guard currentFrame == nil else {
//            return
//        }
//        guard let image = capturedImage else {
//            fatalError("Captured image is null")
//        }
//
//        currentFrame = image
//        poseNet.predict(image)
//    }
//}
//
//// MARK: - PoseNetDelegate
//
//extension ViewController: PoseNetDelegate {
//    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
//        defer {
//            // Release `currentFrame` when exiting this method.
//            self.currentFrame = nil
//        }
//
//        guard let currentFrame = currentFrame else {
//            return
//        }
//
//        let poseBuilder = PoseBuilder(output: predictions,
//                                      configuration: poseBuilderConfiguration,
//                                      inputImage: currentFrame)
//
//        let poses = algorithm == .single
//            ? [poseBuilder.pose]
//            : poseBuilder.poses
//
//        poseCameraView.show(poses: poses, on: currentFrame)
//    }
//}
