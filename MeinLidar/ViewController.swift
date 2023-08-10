//
//  ViewController.swift
//  MeinLidar
//
//  Created by Emre Tekin on 2.08.2023.
//
import RealityKit
import ARKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBAction func depthMapTapped(_ sender: Any) {
        performSegue(withIdentifier: "toDepth", sender: nil)
    }
    @IBAction func confidenceMapTapped(_ sender: Any) {
        performSegue(withIdentifier: "toConfidence", sender: nil)
    }
}
