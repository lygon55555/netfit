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
import Player

class ExerciseViewController: LottieLoading, UIGestureRecognizerDelegate {
    
    @IBOutlet var videoView: UIView!
    @IBOutlet var poseCameraView: PoseImageView!
    
    let checkTime: [Int] = [1, 3, 5, 7, 9, 11, 13, 15]
    var savePoses: [Pose] = []
    var timer = Timer()
    var countTime: Double = 0
    var after: Bool = false
    private var generator:AVAssetImageGenerator!

    private let videoCapture = VideoCapture()
    private var poseNet: PoseNet!
    private var currentFrame: CGImage?
    private var algorithm: Algorithm = .single
    private var poseBuilderConfiguration = PoseBuilderConfiguration()
    private var player = Player()
    
    let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
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
        
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.player.view.addGestureRecognizer(tapGestureRecognizer)
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        let rect:CGRect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 65, height: 30))
        let titleView: UIView = UIView.init(frame: rect)
        let titleImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 65, height: 24))
        titleImage.image = UIImage(named: "netfitLogo")
        titleImage.contentMode = .scaleAspectFit
        titleView.addSubview(titleImage)
        self.navigationItem.titleView = titleView
        
        self.tabBarController?.tabBar.isHidden = true
        
        videoView.layer.cornerRadius = 10
        videoView.clipsToBounds = true
        videoView.layer.shadowColor = UIColor.gray.cgColor
        videoView.layer.shadowOpacity = 1.0
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
        setupAndBeginCapturingVideoFrames() {
//            playVideo(from: "pilatesVideo.mov")
        }
        
        let selectedTheme = UserDefaults.standard.string(forKey: UserDefaultKey.selectedTheme)

        switch selectedTheme {
        case "승모근 스트레칭":
            let file = "video0_0.mp4".components(separatedBy: ".")
            guard let path = Bundle.main.path(forResource: file[0], ofType: file[1]) else { return }
            let videoUrl: URL = URL(fileURLWithPath: path)
            let asset:AVAsset = AVAsset(url: videoUrl)
            self.generator = AVAssetImageGenerator(asset: asset)
            self.generator.appliesPreferredTrackTransform = true
        case "승모근과 팔뚝살 빼기":
            let file = "video1_0.mp4".components(separatedBy: ".")
            guard let path = Bundle.main.path(forResource: file[0], ofType: file[1]) else { return }
            let videoUrl: URL = URL(fileURLWithPath: path)
            let asset:AVAsset = AVAsset(url: videoUrl)
            self.generator = AVAssetImageGenerator(asset: asset)
            self.generator.appliesPreferredTrackTransform = true
        case "전신 다이어트 스트레칭":
            let file = "video2_0.mp4".components(separatedBy: ".")
            guard let path = Bundle.main.path(forResource: file[0], ofType: file[1]) else { return }
            let videoUrl: URL = URL(fileURLWithPath: path)
            let asset:AVAsset = AVAsset(url: videoUrl)
            self.generator = AVAssetImageGenerator(asset: asset)
            self.generator.appliesPreferredTrackTransform = true
        case "층간소음 없는 유산소 운동":
            let file = "video3_0.mp4".components(separatedBy: ".")
            guard let path = Bundle.main.path(forResource: file[0], ofType: file[1]) else { return }
            let videoUrl: URL = URL(fileURLWithPath: path)
            let asset:AVAsset = AVAsset(url: videoUrl)
            self.generator = AVAssetImageGenerator(asset: asset)
            self.generator.appliesPreferredTrackTransform = true
        default: break
        }
        
        
//        let file = "video0_0.mp4".components(separatedBy: ".")
//        guard let path = Bundle.main.path(forResource: file[0], ofType: file[1]) else { return }
//        let videoUrl: URL = URL(fileURLWithPath: path)
//        let asset:AVAsset = AVAsset(url: videoUrl)
//        self.generator = AVAssetImageGenerator(asset: asset)
//        self.generator.appliesPreferredTrackTransform = true
        
//        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            print("save complete")
//            self.savePosesToUserDefaults()
//            self.after = true
//            self.countTime = 0
//            self.scheduledTimerWithTimeInterval()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let selectedTheme = UserDefaults.standard.string(forKey: UserDefaultKey.selectedTheme)
        switch selectedTheme {
        case "승모근 스트레칭":
            let file = "video0_0.mp4".components(separatedBy: ".")
            guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
                debugPrint( "\(file.joined(separator: ".")) not found")
                return
            }
            self.player.url = URL(fileURLWithPath: path)
        case "승모근과 팔뚝살 빼기":
            let file = "video1_0.mp4".components(separatedBy: ".")
            guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
                debugPrint( "\(file.joined(separator: ".")) not found")
                return
            }
            self.player.url = URL(fileURLWithPath: path)
        case "전신 다이어트 스트레칭":
            let file = "video2_0.mp4".components(separatedBy: ".")
            guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
                debugPrint( "\(file.joined(separator: ".")) not found")
                return
            }
            self.player.url = URL(fileURLWithPath: path)
        case "층간소음 없는 유산소 운동":
            let file = "video3_0.mp4".components(separatedBy: ".")
            guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
                debugPrint( "\(file.joined(separator: ".")) not found")
                return
            }
            self.player.url = URL(fileURLWithPath: path)
        default: break
        }
        self.player.playFromBeginning()
        self.showLoading()
    }
    
    func scheduledTimerWithTimeInterval() {
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    func savePosesToUserDefaults() {
        UserDefaults.standard.setValue(savePoses, forKey: "poses1")
    }
    
    @objc func updateCounting() {
        NSLog("counting..")
        countTime = countTime + 0.1

        if after {
//            showFrame(fromTime: countTime)
            getFrame(fromTime: Float64(countTime))
        }
        else {
            getFrame(fromTime: Float64(countTime))
        }
    }
    
    func getFrame(fromTime:Float64) {
        let time:CMTime = CMTimeMakeWithSeconds(fromTime, preferredTimescale:600)
        let image:CGImage
        do {
            try image = self.generator.copyCGImage(at:time, actualTime:nil)
        }
        catch {
            return
        }

//        imgView.image = UIImage(cgImage: image)
        poseNet.predict(image)

        let modelInputSize = CGSize(width: 513, height: 513)
        let outputStride = 16

        DispatchQueue.global(qos: .userInitiated).async {
            let input = PoseNetInput(image: image, size: modelInputSize)
            guard let prediction = try? self.poseNet.poseNetMLModel.prediction(from: input) else { return }
            let poseNetOutput = PoseNetOutput(prediction: prediction, modelInputSize: modelInputSize, modelOutputStride: outputStride)

            let poseBuilder = PoseBuilder(output: poseNetOutput, configuration: self.poseBuilderConfiguration, inputImage: image)
            let poses = self.algorithm == .single ? [poseBuilder.pose] : poseBuilder.poses
        
            self.savePoses = poses
//            self.savePoses.append(contentsOf: poses)
//            UserDefaults.standard.setValue(poses, forKey: "poses1")
//            self.imgView.show(poses: poses, on: image)
        }
    }
    
    @objc func didTapBackwardButton(sender: AnyObject) {
        let selectedTheme = UserDefaults.standard.string(forKey: UserDefaultKey.selectedTheme)
        switch selectedTheme {
        case "승모근 스트레칭":
            ToastUtil.showToastMessage(controller: self, toastMsg: "영상이 1개입니다")
        case "승모근과 팔뚝살 빼기":
            if let url = self.player.url {
                if url.absoluteString.contains("video1_0") {
                    ToastUtil.showToastMessage(controller: self, toastMsg: "첫번재 영상입니다")
                }
                else {
                    let file = "video1_1.mp4".components(separatedBy: ".")
                    guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
                        debugPrint( "\(file.joined(separator: ".")) not found")
                        return
                    }
                    self.player.url = URL(fileURLWithPath: path)
//                    self.player.playFromBeginning()
                }
            }
        case "전신 다이어트 스트레칭":
            if let url = self.player.url {
                if url.absoluteString.contains("video2_0") {
                    ToastUtil.showToastMessage(controller: self, toastMsg: "첫번재 영상입니다")
                }
                else {
                    let file = "video2_1.mp4".components(separatedBy: ".")
                    guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
                        debugPrint( "\(file.joined(separator: ".")) not found")
                        return
                    }
                    self.player.url = URL(fileURLWithPath: path)
                    self.player.playFromBeginning()
                }
            }
        case "층간소음 없는 유산소 운동":
            ToastUtil.showToastMessage(controller: self, toastMsg: "영상이 1개입니다")
        default: break
        }
        
        print("back")
    }

    @objc func didTapForwardButton(sender: AnyObject) {
        let selectedTheme = UserDefaults.standard.string(forKey: UserDefaultKey.selectedTheme)
        switch selectedTheme {
        case "승모근 스트레칭":
            ToastUtil.showToastMessage(controller: self, toastMsg: "영상이 1개입니다")
        case "승모근과 팔뚝살 빼기":
            let file = "video1_0.mp4".components(separatedBy: ".")
            guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
                debugPrint( "\(file.joined(separator: ".")) not found")
                return
            }
            self.player.url = URL(fileURLWithPath: path)
        case "전신 다이어트 스트레칭":
            let file = "video2_0.mp4".components(separatedBy: ".")
            guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
                debugPrint( "\(file.joined(separator: ".")) not found")
                return
            }
            self.player.url = URL(fileURLWithPath: path)
        case "층간소음 없는 유산소 운동":
            ToastUtil.showToastMessage(controller: self, toastMsg: "영상이 1개입니다")
        default: break
        }
        
        print("forward")
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupAndBeginCapturingVideoFrames(completion: () -> Void) {
        videoCapture.setUpAVCapture { error in
            if let error = error {
                print("Failed to setup camera with error \(error)")
                return
            }

            self.videoCapture.delegate = self
            self.videoCapture.startCapturing()
        }
        completion()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        videoCapture.stopCapturing {
            super.viewWillDisappear(animated)
        }
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        // Reinitilize the camera to update its output stream with the new orientation.
        setupAndBeginCapturingVideoFrames() {
            
        }
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
        
        
        
        if poses == savePoses {
            print("same poses")
        }
        else {
            print("different poses")
        }
        
        print("count count \(savePoses.count)")
    }
}

extension ExerciseViewController: PlayerDelegate {
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

extension ExerciseViewController: PlayerPlaybackDelegate {
    func playerCurrentTimeDidChange(_ player: Player) {
//        print(Int(player.currentTime))
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

extension ExerciseViewController {
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
