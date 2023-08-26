//
//  ClassificationService.swift
//  ImageClassificationExample
//
//  Created by Hoye Lam on 14/09/2022.
//

import Foundation
import Vision
import UIKit

protocol ClassificationServiceProviding {
    var classificationsResultPub: Published<String>.Publisher { get }
    func updateClassifications(for image: UIImage)
}

final class ClassificationService: ClassificationServiceProviding {
    
    @Published private var classifications: String = ""
    var classificationsResultPub: Published<String>.Publisher { $classifications }
    
    /// - Tag: MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: GenderNet(configuration: MLModelConfiguration()).model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    
    // MARK: - Image Classification
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage) {
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        /// Clear old classifications
        self.classifications = ""
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    /// Updates the variable with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                // do nothing
            } else {
                // Find the most confident classification.
                let mostConfidentClassification = classifications.max { $0.confidence < $1.confidence }
                
                if let mostConfidentClassification = mostConfidentClassification {
                    // Extract the gender from the classification identifier.
                    let identifier = mostConfidentClassification.identifier
                    let gender = identifier.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    
                    // Format the classification for display; e.g. "You are *percent* *gender*".
                    let description = String(format: "You Are %.2f%% %@\n", mostConfidentClassification.confidence * 100, gender)
                    self.classifications = description
                }
            }
        }
    }



}


///
/// https://developer.apple.com/documentation/imageio/cgimagepropertyorientation
///
extension CGImagePropertyOrientation {
    /**
     Converts a `UIImageOrientation` to a corresponding
     `CGImagePropertyOrientation`. The cases for each
     orientation are represented by different raw values.
     
     - Tag: ConvertOrientation
     */
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default:
            fatalError()
        }
    }
}

