//
//  DepthMapViewController.swift
//  MeinLidar
//
//  Created by Emre Tekin on 3.08.2023.
//

import RealityKit
import ARKit

class DepthMapViewController: UIViewController, ARSessionDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var arView: ARView?
    
    var orientation: UIInterfaceOrientation {
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else {
            fatalError()
        }
        return orientation
    }
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    lazy var imageViewSize: CGSize = {
        CGSize(width: view.bounds.size.width, height: imageViewHeight.constant)
    }()

    override func viewDidLoad() {
        func buildConfigure() -> ARWorldTrackingConfiguration {
            let configuration = ARWorldTrackingConfiguration()

            configuration.environmentTexturing = .automatic
            if type(of: configuration).supportsFrameSemantics(.sceneDepth) {
               configuration.frameSemantics = .sceneDepth
            }

            return configuration
        }
        super.viewDidLoad()
        arView?.session.delegate = self
        let configuration = buildConfigure()
        arView?.session.run(configuration)
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if let depthData = session.currentFrame?.sceneDepth?.depthMap {
            let depthWidth = CVPixelBufferGetWidth(depthData)
            let depthHeight = CVPixelBufferGetHeight(depthData)
            
            let dotX = depthWidth / 2
            let dotY = depthHeight / 2
            
            CVPixelBufferLockBaseAddress(depthData, .readOnly)
            let floatBuffer = unsafeBitCast(CVPixelBufferGetBaseAddress(depthData), to: UnsafeMutablePointer<Float32>.self)
            let depthValue = floatBuffer[dotY * depthWidth + dotX]
            CVPixelBufferUnlockBaseAddress(depthData, .readOnly)
            
            print("Depth value at the center (x: \(dotX), y: \(dotY)): \(depthValue)")
            
        }
        imageView?.image = session.currentFrame?.depthMapTransformedImage(orientation: orientation, viewPort: self.imageView.bounds)
    }

}
