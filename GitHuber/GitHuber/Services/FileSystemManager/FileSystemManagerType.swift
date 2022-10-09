//
//  FileSystemManagerType.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 6.10.22.
//

import Foundation

protocol FileSystemManagerType {
    func fileExists(_ resourceId: String, type: FileType) -> Bool
    func getFileFromCache(_ resourceId: String, type: FileType, completion: @escaping (Result<Data, Error>) -> Void)
    func saveFileToCache(_ resourceId: String, type: FileType, data: Data)
}
