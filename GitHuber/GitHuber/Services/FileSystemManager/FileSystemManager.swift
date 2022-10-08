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
            let cacheDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = cacheDirectory.appendingPathComponent(resourceId + type.rawValue)

            return FileManager.default.fileExists(atPath: fileURL.path)
        } catch {
            return false
        }
    }

    func getFileFromCache(_ resourceId: String, type: FileType) -> Data? {
        do {
            let cacheDirectory = try getCacheDirectory()
            let fileURL = cacheDirectory.appendingPathComponent(resourceId + type.rawValue)
            let data = try Data(contentsOf: fileURL)

            return data
        } catch {
            return nil
        }
    }

    func saveFileToCache(_ resourceId: String, type: FileType, data: Data) {
        do {
            let cacheDirectory = try getCacheDirectory()
            let fileURL = cacheDirectory.appendingPathComponent(resourceId + type.rawValue)

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
