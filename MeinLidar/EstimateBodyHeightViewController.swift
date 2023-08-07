//
//  EstimateBodyHeightViewController.swift
//  MeinLidar
//
//  Created by Emre Tekin on 3.08.2023.
//

import RealityKit
import ARKit

class EstimateBodyHeightViewController: UIViewController, ARSessionDelegate {

    @IBOutlet weak var arView: ARView?

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var resultLabel: UILabel!

    var orientation: UIInterfaceOrientation {
        guard let orientation = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.interfaceOrientation else {
                fatalError()
        }
        return orientation
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let configuration = ARBodyTrackingConfiguration()
        configuration.automaticSkeletonScaleEstimationEnabled = true
        arView?.session.delegate = self
        arView?.session.run(configuration)
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {

        for anchor in anchors {

            guard let bodyAnchor = anchor as? ARBodyAnchor
            else { return }

            let skeleton = bodyAnchor.skeleton
            let value = bodyAnchor.estimatedScaleFactor
            print("Value: \(value)")


            for (i, joint) in skeleton.definition.jointNames.enumerated() {
                print(i, joint)

                // [10] right_toes_joint
                // [51] head_joint
            }

            let toesJointPos = skeleton.jointModelTransforms[10].columns.3.y
            print("Ayak noktası \(toesJointPos)")
            let headJointPos = skeleton.jointModelTransforms[51].columns.3.y
            print("Kafa noktası \(headJointPos)")
            resultLabel.text = String(headJointPos - toesJointPos)
            print(headJointPos - toesJointPos)
        }
    }
}




