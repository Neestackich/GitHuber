//
//  MockFileSystemManager.swift
//  GitHuberTests
//
//  Created by Vittcal Neestackich on 9.10.22.
//

import XCTest
@testable import GitHuber

final class MockFileSystemManager: FileSystemManagerType {

    var data = Data()
    var fileSystemError: Error?
    var fileExists = false

    var fileExistsResourceId = ""
    var fileExistsType: FileType?
    var fileExistsCalled = false

    var getFileFromCacheResourceId = ""
    var getFileFromCacheType: FileType?
    var getFileFromCacheCalled = false

    var saveFileToCacheResourceId = ""
    var saveFileToCacheType: FileType?
    var saveFileToCacheData = Data()
    var saveFileToCacheCalled = false

    func fileExists(_ resourceId: String, type: FileType) -> Bool {
        fileExistsCalled = true
        fileExistsResourceId = resourceId
        fileExistsType = type

        return fileExists
    }

    func getFileFromCache(_ resourceId: String, type: FileType, completion: @escaping (Result<Data, Error>) -> Void) {
        getFileFromCacheCalled = true
        getFileFromCacheResourceId = resourceId
        getFileFromCacheType = type

        if fileExists {
            completion(.success(data))
        } else {
            if let error = fileSystemError {
                completion(.failure(error))
            }
        }
    }

    func saveFileToCache(_ resourceId: String, type: FileType, data: Data) {
        saveFileToCacheCalled = true
        saveFileToCacheResourceId = resourceId
        saveFileToCacheType = type
        saveFileToCacheData = data
    }

}
