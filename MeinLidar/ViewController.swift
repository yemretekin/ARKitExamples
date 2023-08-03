//
//  ViewController.swift
//  MeinLidar
//
//  Created by Emre Tekin on 2.08.2023.
//
import RealityKit
import ARKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        
    }
    @IBAction func depthMapTapped(_ sender: Any) {
        performSegue(withIdentifier: "toDepth", sender: nil)
    }
    @IBAction func confidenceMapTapped(_ sender: Any) {
        performSegue(withIdentifier: "toConfidence", sender: nil)
    }
}












//import UIKit
//import AVFoundation
//import MobileCoreServices
//
//class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
//    private var captureSession: AVCaptureSession!
//    private var photoOutput: AVCapturePhotoOutput!
//    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupCamera()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.capturePhoto()
//        }
//    }
//
//    private func setupCamera() {
//        // Create and configure the capture session
//        captureSession = AVCaptureSession()
//
//        // Video input
//        let device = AVCaptureDevice.default(.builtInLiDARDepthCamera, for: .video, position: .back)!
//        guard let videoInput = try? AVCaptureDeviceInput(device: device), captureSession.canAddInput(videoInput) else {
//            fatalError("Failed to initialize video input.")
//        }
//        captureSession.addInput(videoInput)
//
//        // Photo output
//        photoOutput = AVCapturePhotoOutput()
//        photoOutput.maxPhotoQualityPrioritization = .quality
//        guard captureSession.canAddOutput(photoOutput) else {
//            fatalError("Failed to initialize photo output.")
//        }
//        captureSession.addOutput(photoOutput)
//        photoOutput.isDepthDataDeliveryEnabled = photoOutput.isDepthDataDeliverySupported
//
//        // Set session preset (you can adjust this based on your requirements)
//        captureSession.sessionPreset = .photo
//
//        // Create a preview layer and add it to the view
//        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        videoPreviewLayer.videoGravity = .resizeAspectFill
//        videoPreviewLayer.frame = view.bounds
//        view.layer.addSublayer(videoPreviewLayer)
//
//        // Start the session
//        captureSession.startRunning()
//    }
//
//
//
//
//    private func capturePhoto() {
//        let format: [String: Any] = [
//            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
//        ]
//
//        let settings = AVCapturePhotoSettings(format: format)
//        settings.isDepthDataDeliveryEnabled = photoOutput.isDepthDataDeliveryEnabled
//        settings.isDepthDataFiltered = photoOutput.isDepthDataDeliveryEnabled
//        settings.embedsDepthDataInPhoto = photoOutput.isDepthDataDeliveryEnabled
//
//        photoOutput.capturePhoto(with: settings, delegate: self)
//    }
//
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard error == nil else {
//            print("Error capturing photo: \(error!.localizedDescription)")
//            return
//        }
//
//        // Process the captured photo and depth data
//        createPhotoFile(photo: photo)
//    }
//
//    func createPhotoFile(photo: AVCapturePhoto) {
//        // Fetch the orientation from the photo settings
//        let orientation = photo.metadata[NSString(string: kCGImagePropertyOrientation) as String] as! NSNumber
//
//        let cgMainImage = photo.cgImageRepresentation()!
//        let mainImageData = NSMutableData()
//        let imageDest = CGImageDestinationCreateWithData(mainImageData, kUTTypeJPEG, 1, nil)!
//
//        var options: [CFString: Any] = [:]
//        options[kCGImageDestinationLossyCompressionQuality] = 0.8
//        options[kCGImagePropertyOrientation] = orientation
//        CGImageDestinationAddImage(imageDest, cgMainImage, options as CFDictionary)
//
//        if let depthData = photo.depthData?.converting(toDepthDataType: kCVPixelFormatType_DepthFloat16)
//            .applyingExifOrientation(CGImagePropertyOrientation(rawValue: orientation.uint32Value)!),
//            let depthDataDict = depthData.dictionaryRepresentation(forAuxiliaryDataType: nil)
//        {
//            CGImageDestinationAddAuxiliaryDataInfo(imageDest, kCGImageAuxiliaryDataTypeDepth, depthDataDict as CFDictionary)
//        }
//        CGImageDestinationFinalize(imageDest)
//
//        // Save the mainImageData to a file
//        let fileManager = FileManager.default
//        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            print("Error getting documents directory.")
//            return
//        }
//
//        let fileURL = documentsDirectory.appendingPathComponent("capturedPhoto.jpg")
//        do {
//            try mainImageData.write(to: fileURL)
//            print("Photo saved to: \(fileURL)")
//        } catch {
//            print("Error saving photo: \(error.localizedDescription)")
//        }
//
//        // final test ...
//        let imageSource = CGImageSourceCreateWithData(mainImageData as CFData, nil)!
//        let depthDataDict = CGImageSourceCopyAuxiliaryDataInfoAtIndex(
//            imageSource,
//            0,
//            kCGImageAuxiliaryDataTypeDepth
//        )
//        print("depthDataDict", depthDataDict ?? "nil")
//        // ... now the depthDataDict exists!
//    }
//
//}
