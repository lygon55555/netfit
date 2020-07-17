//
//  ExerciseViewController.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/15.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import AVFoundation
import UIKit
import VideoToolbox
import AVKit
import CoreVideo

class ExerciseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var videoView: UIView!
    @IBOutlet var poseCameraView: PoseImageView!
    
    private let videoCapture = VideoCapture()
    private var poseNet: PoseNet!
    private var currentFrame: CGImage?
    private var algorithm: Algorithm = .single
    private var poseBuilderConfiguration = PoseBuilderConfiguration()

    
    
    var lastRotation: CGFloat = 0

    
    
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        videoView.layer.cornerRadius = 10
        videoView.layer.shadowOpacity = 0.7
        videoView.layer.shadowOffset = CGSize(width: 0, height: 0)
        videoView.layer.shadowRadius = 10
        videoView.layer.masksToBounds = false
        
        self.view.isUserInteractionEnabled = true
        self.view.isMultipleTouchEnabled = true
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(doPinch(_:)))
        self.view.addGestureRecognizer(pinch)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(drag))
        videoView.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(panGesture)
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotate(_:)))
        self.view.addGestureRecognizer(rotate)
        pinch.delegate = self
        panGesture.delegate = self
        rotate.delegate = self
        
        UIApplication.shared.isIdleTimerDisabled = true
        do {
            poseNet = try PoseNet()
        } catch {
            fatalError("Failed to load model. \(error.localizedDescription)")
        }
        poseNet.delegate = self
//        setupAndBeginCapturingVideoFrames()
        
        playVideo(from: "pilatesVideo.mov")
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
        self.videoView.layer.addSublayer(playerLayer)
        player.play()
    }
    
    private func setupAndBeginCapturingVideoFrames() {
        videoCapture.setUpAVCapture { error in
            if let error = error {
                print("Failed to setup camera with error \(error)")
                return
            }

            self.videoCapture.delegate = self
            self.videoCapture.startCapturing()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        videoCapture.stopCapturing {
            super.viewWillDisappear(animated)
        }
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        // Reinitilize the camera to update its output stream with the new orientation.
        setupAndBeginCapturingVideoFrames()
    }
    
    @objc func doPinch(_ pinch: UIPinchGestureRecognizer) {
        // 이미지를 스케일에 맞게 변환
        self.videoView.transform = self.videoView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
        // 다음 변환을 위해 핀치의 스케일 속성을 1로 설정
        pinch.scale = 1
    }
    
    @objc func drag(sender: UIPanGestureRecognizer) {
        // self는 여기서 ViewController이므로 self.view ViewController가 기존에가지고 있는 view이다.
        let translation = sender.translation(in: self.videoView) // translation에 움직인 위치를 저장한다.

        // sender의 view는 sender가 바라보고 있는 circleView이다. 드래그로 이동한 만큼 circleView를 이동시킨다.
        videoView!.center = CGPoint(x: videoView!.center.x + translation.x, y: videoView!.center.y + translation.y)
        sender.setTranslation(.zero, in: self.videoView) // 0으로 움직인 값을 초기화 시켜준다.
        
        // 화면 범위 못 넘어가게 하고
        // rotate 가능하게 하고
        // 클릭하면 전체화면으로 UIView.animate 써서 만들기
    }
    
    @objc func rotate(_ gesture: UIRotationGestureRecognizer) {
        videoView.transform = videoView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - VideoCaptureDelegate

extension ExerciseViewController: VideoCaptureDelegate {
    func videoCapture(_ videoCapture: VideoCapture, didCaptureFrame capturedImage: CGImage?) {
        guard currentFrame == nil else {
            return
        }
        guard let image = capturedImage else {
            fatalError("Captured image is null")
        }

        currentFrame = image
        poseNet.predict(image)
    }
}

// MARK: - PoseNetDelegate

extension ExerciseViewController: PoseNetDelegate {
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
        defer {
            // Release `currentFrame` when exiting this method.
            self.currentFrame = nil
        }

        guard let currentFrame = currentFrame else {
            return
        }

        let poseBuilder = PoseBuilder(output: predictions,
                                      configuration: poseBuilderConfiguration,
                                      inputImage: currentFrame)

        let poses = algorithm == .single
            ? [poseBuilder.pose]
            : poseBuilder.poses
        
        poseCameraView.show(poses: poses, on: currentFrame)
//        poseCameraView.show(poses: [], on: currentFrame)
    }
}
