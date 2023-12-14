//
//  UIImage+Extensions.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 13/12/2023.
//

import UIKit

extension UIImage {
    func invertImage(_ originalImage: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: originalImage) else {
            return nil
        }
        
        let filter = CIFilter(name: "CIColorInvert")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let outputCIImage = filter?.outputImage,
           let invertedImage = CIContext().createCGImage(outputCIImage, from: outputCIImage.extent) {
            return UIImage(cgImage: invertedImage)
        }
        
        return nil
    }
}
