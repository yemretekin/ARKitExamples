//
//  BodyDistanceViewController.swift
//  MeinLidar
//
//  Created by Emre Tekin on 3.08.2023.
//

import RealityKit
import ARKit

class BodyDistanceViewController: UIViewController, ARSessionDelegate {
    
    @IBOutlet weak var arView: ARView?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
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
        
        startFaceTrackingSession()
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    func startFaceTrackingSession() {
        let configuration = ARFaceTrackingConfiguration()
        arView?.session.delegate = self
        arView?.session.run(configuration)
    }
    
    func startBodyTrackingSession() {
        let configuration = ARBodyTrackingConfiguration()
        arView?.session.delegate = self
        arView?.session.run(configuration)
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let cameraTransform = session.currentFrame?.camera.transform else {
            return
        }
        
        for anchor in anchors {
            if let faceAnchor = anchor as? ARFaceAnchor {
                let facePosition = simd_make_float4(faceAnchor.transform.columns.3)
                let cameraPosition = simd_make_float4(cameraTransform.columns.3)
                let distanceToCamera = simd_distance(facePosition, cameraPosition)
                resultLabel.text = "Distance: \(distanceToCamera) meter (Face)"
            } else if let bodyAnchor = anchor as? ARBodyAnchor {
                let bodyPosition = simd_make_float4(bodyAnchor.transform.columns.3)
                let cameraPosition = simd_make_float4(cameraTransform.columns.3)
                let distanceToCamera = simd_distance(bodyPosition, cameraPosition)
                resultLabel.text = "Distance: \(distanceToCamera) meter (Body)"
            }
        }
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            startFaceTrackingSession()
        } else {
            startBodyTrackingSession()
        }
    }
}
