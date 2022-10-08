//
//  Endpoint.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import Foundation

struct Endpoint {
    let path: String
    let method: EndpointMethod

    init(path: String, method: EndpointMethod) {
        self.path = path
        self.method = method
    }
}

extension Endpoint {
    static func getUsersList(apiConfig: APIConfigType, userNumberToStartFrom: Int) -> Endpoint {
        return .init(path: "\(apiConfig.baseBackend)/users?since=\(userNumberToStartFrom)", method: .get)
    }
    static func getUserProfile(apiConfig: APIConfigType, username: String) -> Endpoint {
        return .init(path: "\(apiConfig.baseBackend)/users/\(username)", method: .get)
    }
    static func getImage(path: String) -> Endpoint {
        return .init(path: path, method: .get)
    }
}
