//
//  ConfidenceViewController.swift
//  MeinLidar
//
//  Created by Emre Tekin on 3.08.2023.
//

import RealityKit
import ARKit

class ConfidenceMapViewController: UIViewController, ARSessionDelegate {

    @IBOutlet var arView: ARView?
    @IBOutlet weak var imageView: UIImageView!
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
        // ConfidenceMapTransformedImage fonksiyonuyla confidenceMap dönüştürülmüş bir görüntü olarak al
        imageView.image = session.currentFrame?.confidenceMapTransformedImage(orientation: orientation, viewPort: self.imageView.bounds)
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
