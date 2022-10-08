//
//  ImageInversion.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import UIKit

final class ImageInversion: ImageInversionType {

}

// MARK: - Public

extension ImageInversion {

    func invertImage(_ image: UIImage) -> UIImage? {
        let ciImage = CIImage(image: image)
        let filter = CIFilter(name: "CIColorInvert")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)

        if let filteredCiImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage,
           let filteredCgImage = CIContext(options: nil).createCGImage(filteredCiImage, from: filteredCiImage.extent) {
            return UIImage(cgImage: filteredCgImage)
        }

        return nil
    }

}

