//
//  MockImageInversion.swift
//  GitHuberTests
//
//  Created by Vittcal Neestackich on 9.10.22.
//

import XCTest
@testable import GitHuber

final class MockImageInversion: ImageInversionType {

    var image: UIImage?
    var invertedImage: UIImage?
    var invertImageCalled = false

    func invertImage(_ image: UIImage) -> UIImage? {
        invertImageCalled = true
        self.image = image

        return invertedImage
    }

}
