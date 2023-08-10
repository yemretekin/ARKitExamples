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

    // Cihazın geçerli yönlendirmesini döndüren bir özellik
    var orientation: UIInterfaceOrientation {
        guard let orientation = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.interfaceOrientation else {
                fatalError("Cannot determine interface orientation.")
        }
        return orientation
    }

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

        for anchor in anchors {
            
            guard let bodyAnchor = anchor as? ARBodyAnchor else {
                continue
            }

            let skeleton = bodyAnchor.skeleton

            // Her bir eklemi döngü ile gezin
            for (i, joint) in skeleton.definition.jointNames.enumerated() {
                print("Joint Index:", i, "Joint Name:", joint)
            }

            // Ayak ve baş eklem noktalarının yükseklik değerlerini al
            let toesJointPos = skeleton.jointModelTransforms[10].columns.3.y
            let headJointPos = skeleton.jointModelTransforms[51].columns.3.y

            // Ayak ve baş arasındaki farkı hesapla ve sonuç text'ine yaz
            let heightDifference = headJointPos - toesJointPos
            resultLabel.text = String(heightDifference)
            print("Height Difference:", heightDifference)
        }
    }
}
