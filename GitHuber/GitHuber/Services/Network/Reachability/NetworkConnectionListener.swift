//
//  NetworkConnectionListener.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import Foundation
import Network

final class NetworkConnectionListener: NetworkConnectionListenerType {

     private let monitor = NWPathMonitor()

    weak var delegate: NetworkConnectionListenerDelegate?

    init() {
        setupMonitoring()
    }

}

// MARK: - Public

extension NetworkConnectionListener {

    func startMonitoring() {
        monitor.start(queue: .global())
    }

}

// MARK: - Private

extension NetworkConnectionListener {

    private func setupMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            switch path.status {
            case .satisfied:
                self?.delegate?.handleOnlineMode()
            default:
                self?.delegate?.handleOfflineMode()
            }
        }
    }

}
