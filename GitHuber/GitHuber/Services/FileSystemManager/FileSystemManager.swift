//
//  FileSystemManager.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 6.10.22.
//

import Foundation

final class FileSystemManager: FileSystemManagerType {

}

// MARK: - Public

extension FileSystemManager {

    func fileExists(_ resourceId: String, type: FileType) -> Bool {
        do {
            let cacheDirectory: URL = try getCacheDirectory()
            let fileURL: URL = cacheDirectory.appendingPathComponent(resourceId + type.rawValue)
            return FileManager.default.fileExists(atPath: fileURL.path)
        } catch {
            return false
        }
    }

    func getFileFromCache(_ resourceId: String, type: FileType, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            let cacheDirectory: URL = try getCacheDirectory()
            let fileURL: URL = cacheDirectory.appendingPathComponent(resourceId + type.rawValue)
            let data = try Data(contentsOf: fileURL)

            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }

    func saveFileToCache(_ resourceId: String, type: FileType, data: Data) {
        do {
            let cacheDirectory: URL = try getCacheDirectory()
            let fileURL: URL = cacheDirectory.appendingPathComponent(resourceId + type.rawValue)

            try data.write(to: fileURL)
        } catch {
            print("File manager error: \(error)")
        }
    }

}

// MARK: - Private

private extension FileSystemManager {

    private func getCacheDirectory() throws -> URL {
        return try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }

}
