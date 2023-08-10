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

    // Elin son pozisyonunu ve zaman damgasını saklayan özellikler
    var lastArmPosition: SIMD4<Float>?
    var lastTimestamp: TimeInterval?

    override func viewDidLoad() {
        super.viewDidLoad()

        // ARBodyTrackingConfiguration kullanarak oturumu başlat
        let configuration = ARBodyTrackingConfiguration()
        configuration.automaticSkeletonScaleEstimationEnabled = true
        arView?.session.delegate = self
        arView?.session.run(configuration)
    }

    // ARSessionDelegate yöntemi: Çerçeve güncellendiğinde çağrılır
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        // İlk beden bağını al, diğerleriyle ilgilenmiyoruz
        guard let bodyAnchor = anchors.compactMap({ $0 as? ARBodyAnchor }).first else {
            return
        }

        // Sağ elin eklem indeksi
        let rightHandJointIndex = 66
        let rightHandPosition = bodyAnchor.skeleton.jointModelTransforms[rightHandJointIndex].columns.3

        // Şu anki zamanı al
        let currentTime = Date().timeIntervalSince1970

        if let lastPos = lastArmPosition, let lastTime = lastTimestamp {
            // Önceki pozisyon ve zamanı kullanarak hızı hesapla
            let distance = simd_distance(rightHandPosition, lastPos)
            let timeElapsed = currentTime - lastTime
            let movementSpeed = distance / Float(timeElapsed)

            // Hareket hızını text'e yaz
            resultLabel.text = String(format: "Movement Speed: %.2f", movementSpeed)
        }

        // Son el pozisyonunu ve zaman damgasını güncelle
        lastArmPosition = rightHandPosition
        lastTimestamp = currentTime
    }
}
