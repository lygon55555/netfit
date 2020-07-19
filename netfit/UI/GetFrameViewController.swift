//
//  GetFrameViewController.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/16.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import AVFoundation
import UIKit
import VideoToolbox
import AVKit
import CoreVideo
import CoreML
import Vision

class GetFrameViewController: UIViewController {
    
    @IBOutlet var imgView: PoseImageView!
    @IBOutlet var poseCameraView: PoseImageView!
    
    private let videoCapture = VideoCapture()
    private var poseNet: PoseNet!
    private var currentFrame: CGImage?
    private var algorithm: Algorithm = .single
    private var poseBuilderConfiguration = PoseBuilderConfiguration()
    
    
    private var generator:AVAssetImageGenerator!
    
    var timer = Timer()
    var countTime = 0.05
    
    var savePoses:[Pose] = []
    var i = 0
    var after: Bool = false
    
    override func viewDidLoad() {
        UIApplication.shared.isIdleTimerDisabled = true
        
        do {
            poseNet = try PoseNet()
        } catch {
            fatalError("Failed to load model. \(error.localizedDescription)")
        }

        poseNet.delegate = self
        setupAndBeginCapturingVideoFrames()
        
        let file = "pilatesVideo.mov".components(separatedBy: ".")
        guard let path = Bundle.main.path(forResource: file[0], ofType: file[1]) else { return }
        let videoUrl: URL = URL(fileURLWithPath: path)
        let asset:AVAsset = AVAsset(url: videoUrl)
        self.generator = AVAssetImageGenerator(asset: asset)
        self.generator.appliesPreferredTrackTransform = true
        
        scheduledTimerWithTimeInterval()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            print("save complete")
            self.savePosesToUserDefaults()
            self.after = true
            self.countTime = 0.05
            self.scheduledTimerWithTimeInterval()

        }
    }
    
    func scheduledTimerWithTimeInterval() {
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }

    @objc func updateCounting() {
        NSLog("counting..")
        
        countTime = countTime + 0.05

        if after {
            showFrame(fromTime: countTime)
        }
        else {
            getFrame(fromTime: countTime)
        }
    }
    
    func showFrame(fromTime: Float64) {
        let time:CMTime = CMTimeMakeWithSeconds(fromTime, preferredTimescale:600)
        let image:CGImage
        do {
           try image = self.generator.copyCGImage(at:time, actualTime:nil)
        }
        catch {
           return
        }
        
        self.imgView.show(poses: [savePoses[i]], on: image)
        i = i+1
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
//        poseNet.predict(image)
        
        let modelInputSize = CGSize(width: 513, height: 513)
        let outputStride = 16
        
        DispatchQueue.global(qos: .userInitiated).async {
            let input = PoseNetInput(image: image, size: modelInputSize)
            guard let prediction = try? self.poseNet.poseNetMLModel.prediction(from: input) else { return }
            let poseNetOutput = PoseNetOutput(prediction: prediction, modelInputSize: modelInputSize, modelOutputStride: outputStride)

            let poseBuilder = PoseBuilder(output: poseNetOutput, configuration: self.poseBuilderConfiguration, inputImage: image)
            let poses = self.algorithm == .single ? [poseBuilder.pose] : poseBuilder.poses
                        
            self.savePoses.append(contentsOf: poses)
//            self.imgView.show(poses: poses, on: image)
        }
    }
    
    func savePosesToUserDefaults() {
        UserDefaults.standard.setValue(savePoses, forKey: "poses1")
    }
    
    func getThumbnailFrom(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)

            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
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
}

// MARK: - VideoCaptureDelegate

extension GetFrameViewController: VideoCaptureDelegate {
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

extension GetFrameViewController: PoseNetDelegate {
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
    }
}
