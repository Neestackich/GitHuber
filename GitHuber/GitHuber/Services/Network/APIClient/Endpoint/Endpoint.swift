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
    static func getUsersList(userNumberToStartFrom: Int) -> Endpoint {
        return .init(path: "/users?since=\(userNumberToStartFrom)", method: .get)
    }
    static func getUserProfile(username: String) -> Endpoint {
        return .init(path: "/users/\(username)", method: .get)
    }
}
