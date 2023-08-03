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
    
    var orientation: UIInterfaceOrientation {
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else {
            fatalError()
        }
        return orientation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = ARBodyTrackingConfiguration()
        arView?.session.delegate = self
        arView?.session.run(configuration)
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        guard let cameraTransform = session.currentFrame?.camera.transform else {
            return
        }
        
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else {
                continue
            }
            
            let bodyPosition = simd_make_float4(bodyAnchor.transform.columns.3)
            
            let cameraPosition = simd_make_float4(cameraTransform.columns.3)
            
            let distanceToCamera = simd_distance(bodyPosition, cameraPosition)
            
            print("Uzaklık: \(distanceToCamera) metre")
        }
    }
    
}
