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
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!

    // Cihazın geçerli yönlendirmesini döndüren bir özellik
    var orientation: UIInterfaceOrientation {
        guard let orientation = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.interfaceOrientation else {
                fatalError("Cannot determine interface orientation.")
        }
        return orientation
    }

    // UIImageView boyutunu saklayan bir özellik
    lazy var imageViewSize: CGSize = {
        CGSize(width: view.bounds.size.width, height: imageViewHeight.constant)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // ARSession delegesini ayarla
        arView?.session.delegate = self

        // ARWorldTracking yapılandırmasını oluştur ve çalıştır
        let configuration = buildConfigure()
        arView?.session.run(configuration)
    }

    // ARSessionDelegate yöntemi: Kamera görüntüsü güncellendiğinde çağrılır
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if let depthData = session.currentFrame?.sceneDepth?.depthMap {
            // Derinlik haritasından orta noktanın derinliğini al
            let depthWidth = CVPixelBufferGetWidth(depthData)
            let depthHeight = CVPixelBufferGetHeight(depthData)
            let dotX = depthWidth / 2
            let dotY = depthHeight / 2
            
            CVPixelBufferLockBaseAddress(depthData, .readOnly)
            let floatBuffer = unsafeBitCast(CVPixelBufferGetBaseAddress(depthData), to: UnsafeMutablePointer<Float32>.self)
            CVPixelBufferUnlockBaseAddress(depthData, .readOnly)
            let depthValue = floatBuffer[dotY * depthWidth + dotX]
            
            print("Depth value at the center (x: \(dotX), y: \(dotY)): \(depthValue)")
        }
        
        // Derinlik haritasını görüntü olarak görüntüle
        imageView?.image = session.currentFrame?.depthMapTransformedImage(orientation: orientation, viewPort: self.imageView.bounds)
    }

    // ARWorldTrackingConfiguration yapılandırmasını oluşturan yardımcı fonksiyon
    func buildConfigure() -> ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()

        // Otomatik çevre dokusu ve sahne derinliği destekleniyorsa sahne derinliği kullan
        configuration.environmentTexturing = .automatic
        if type(of: configuration).supportsFrameSemantics(.sceneDepth) {
            configuration.frameSemantics = .sceneDepth
        }

        return configuration
    }
}
