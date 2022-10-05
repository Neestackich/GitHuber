//
//  FileSystemManagerType.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 6.10.22.
//

import Foundation

protocol FileSystemManagerType {
    func getCachedFile(with id: String) -> Data?
    func saveFileToCache(with id: String) -> Bool
}
