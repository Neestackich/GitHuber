//
//  APIClientType.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import Foundation

protocol APIClientType {
    func sendRequestToQueue(endpoint: Endpoint, completion: @escaping (Result<Data, Error>) -> Void)
}
