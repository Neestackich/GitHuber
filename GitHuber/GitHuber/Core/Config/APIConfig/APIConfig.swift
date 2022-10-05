//
//  APIConfig.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import Foundation

final class APIConfig: APIConfigType {

    // MARK: Properties

    private var config: [String: Any] = [:]

    var baseBackend: String {
        if let url = config["BaseBackend"] as? String {
            return url
        }
        return ""
    }

    // MARK: Initialization

    init() {
        if let path = Bundle.main.path(forResource: "APIConfig", ofType: "plist"), let config = NSDictionary(contentsOfFile: path) as? [String: Any] {
            #if DEBUG
            if let devConfig = config["Development"] as? [String: Any] {
                self.config = devConfig
            }
            #else
            if let prodConfig = config["Production"] as? [String: Any] {
                self.config = prodConfig
            }
            #endif
        }
    }

}
