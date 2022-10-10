//
//  MockAPIClient.swift
//  GitHuberTests
//
//  Created by Vittcal Neestackich on 9.10.22.
//

import XCTest
@testable import GitHuber

final class MockAPIClient: APIClientType {

    var delegate: APIClientDelegate?
    var dataToReturn = Data()
    var endpoint: Endpoint?
    var error: APIClientError?
    var sendRequestToQueueCalled = false

    func sendRequestToQueue(endpoint: Endpoint, completion: @escaping (Result<Data, Error>) -> Void) {
        sendRequestToQueueCalled = true
        self.endpoint = endpoint

        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(dataToReturn))
        }
    }

}
