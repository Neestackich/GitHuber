//
//  NetworkConnectionListener.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import Foundation

final class NetworkConnectionListener: NSObject, NetworkConnectionListenerType {

    weak var delegate: NetworkConnectionListenerDelegate?

}

// MARK: - URLSessionDelegate

extension NetworkConnectionListener: URLSessionTaskDelegate {

    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        delegate?.handleOfflineMode()
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest: URLRequest, completionHandler: (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) {
        delegate?.handleOnlineMode()
    }

}
