//
//  APIClient.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import Foundation

final class APIClient: APIClientType {

    // MARK: Properties

    private let serialQueue = DispatchQueue(label: "com.GitHuber.SerialNetworkRequestQueue", qos: .background, attributes: .concurrent)
    private let group = DispatchGroup()
    private let semaphore = DispatchSemaphore(value: 1)

    weak var delegate: APIClientDelegate?

}

// MARK: - Public

extension APIClient {

    func sendRequestToQueue(endpoint: Endpoint, completion: @escaping (Result<Data, Error>) -> Void) {
        serialQueue.async(group: group) { [weak self] in
            guard let sself = self else { return }
            sself.group.enter()
            sself.semaphore.wait()

            self?.delegate?.handleLoadingStart()

            sself.request(endpoint: endpoint) { response in
                switch response {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
                sself.group.leave()
                sself.semaphore.signal()
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.delegate?.handleLoadingFinish()
        }
    }

}

// MARK: - Private

private extension APIClient {

    private func request(endpoint: Endpoint, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            let urlRequest = try setupRequest(endpoint: endpoint)
            let config = URLSessionConfiguration.default
            config.waitsForConnectivity = true
            let session = URLSession(configuration: config)

            let task = session.dataTask(with: urlRequest) { data, _, error in
                if let data = data {
                    completion(.success(data))
                } else if let error = error {
                    completion(.failure(error))
                }
            }

            task.resume()
        } catch {
            completion(.failure(error))
        }
    }

    private func setupRequest(endpoint: Endpoint) throws -> URLRequest {
        guard let url = URL(string: endpoint.path) else { throw APIClientError.urlCreateError }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }

}
