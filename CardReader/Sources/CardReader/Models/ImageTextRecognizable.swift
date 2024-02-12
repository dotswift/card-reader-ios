import Foundation
import SwiftUI
import Vision
import VisionKit

public protocol ImageTextRecognizable: VNDocumentCameraViewControllerDelegate { }

public extension ImageTextRecognizable {

    func validateImage(image: UIImage?, completion: @escaping (Bool) -> Void) {
        guard let cgImage = image?.cgImage
        else { return completion(false) }
        var recognizedText = [String]()
        var textRecognitionRequest = VNRecognizeTextRequest()

        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = false
        textRecognitionRequest.customWords = String.insuranceKeywords
        textRecognitionRequest = VNRecognizeTextRequest() { (request, error) in
            guard let results = request.results,
                  !results.isEmpty,
                  let requestResults = request.results as? [VNRecognizedTextObservation]
            else { return completion(false) }
            recognizedText = requestResults.compactMap { observation in
                return observation.topCandidates(1).first?.string
            }
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
            let result = validateAndParse(insuranceCardData: recognizedText)
            if result {
                saveImage(cgImage)
            }
            completion(result)
        } catch {
            print(error)
        }
    }

    func validateAndParse(insuranceCardData: [String]) -> Bool {
        print("[INFO] validateAndParse\(insuranceCardData.description)")
        var insuranceKeywordsFound = 0

        for keyword in insuranceCardData {
            if String.insuranceKeywords.contains(keyword) {
                print("[INFO] keyword added= \(keyword)")
                insuranceKeywordsFound += 1
            }
        }
        let result = insuranceKeywordsFound > 3
        print("[INFO] validateAndParse result = \(result)")
        return result
    }

    func saveImage(_ cgImage: CGImage) {
        print("[INFO] saveImage width=\(cgImage.width) height=\(cgImage.height)")
    }
}
