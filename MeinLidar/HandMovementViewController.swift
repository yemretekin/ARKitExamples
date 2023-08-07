//
//  HandMovementViewController.swift
//  MeinLidar
//
//  Created by Emre Tekin on 7.08.2023.
//

import UIKit
import RealityKit
import ARKit

class HandMovementViewController: UIViewController, ARSessionDelegate {

    @IBOutlet weak var arView: ARView?
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var lastArmPosition: SIMD4<Float>?
    var lastTimestamp: TimeInterval?

    override func viewDidLoad() {
        super.viewDidLoad()

        let configuration = ARBodyTrackingConfiguration()
        configuration.automaticSkeletonScaleEstimationEnabled = true
        arView?.session.delegate = self
        arView?.session.run(configuration)
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let bodyAnchor = anchors.compactMap({ $0 as? ARBodyAnchor }).first else {
            return
        }

        let rightHandJointIndex = 66
        let rightHandPosition = bodyAnchor.skeleton.jointModelTransforms[rightHandJointIndex].columns.3

        let currentTime = Date().timeIntervalSince1970
        if let lastPos = lastArmPosition, let lastTime = lastTimestamp {
            let distance = simd_distance(rightHandPosition, lastPos)
            let timeElapsed = currentTime - lastTime
            let movementSpeed = distance / Float(timeElapsed)

            resultLabel.text = String(format: "Movement Speed: %.2f", movementSpeed)
        }

        lastArmPosition = rightHandPosition
        lastTimestamp = currentTime
    }
}

