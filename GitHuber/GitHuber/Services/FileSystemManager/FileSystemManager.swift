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

    func getCachedFile(with id: String) -> Data? {
        return nil
    }

    func saveFileToCache(with id: String) -> Bool {
        return true
    }

}

// MARK: - Private

private extension FileSystemManager {

    func getCacheDirectory() -> URL? {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    }

    func fileExists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }

}
