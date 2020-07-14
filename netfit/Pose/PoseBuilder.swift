//
//  PoseBuilder.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/13.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import CoreGraphics

struct PoseBuilder {
    /// A prediction from the PoseNet model.
    ///
    /// Prediction outputs are analyzed to find and construct poses.
    let output: PoseNetOutput

    /// A transformation matrix used to map joints from the PoseNet model's input image size onto the original image size.
    let modelToInputTransformation: CGAffineTransform

    /// The parameters the Pose Builder uses in its pose algorithms.
    var configuration: PoseBuilderConfiguration

    init(output: PoseNetOutput, configuration: PoseBuilderConfiguration, inputImage: CGImage) {
        self.output = output
        self.configuration = configuration

        // Create a transformation matrix to transform joint positions back into the space
        // of the original input size.
        modelToInputTransformation = CGAffineTransform(scaleX: inputImage.size.width / output.modelInputSize.width,
                                                       y: inputImage.size.height / output.modelInputSize.height)
    }
}
