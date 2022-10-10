//
//  MockNetworkConnectionListener.swift
//  GitHuberTests
//
//  Created by Vittcal Neestackich on 9.10.22.
//

import XCTest
@testable import GitHuber

final class MockNetworkConnectionListener: NetworkConnectionListenerType {

    var delegate: NetworkConnectionListenerDelegate?
    var delegateHandleOnlineModeCalled = false
    var delegateHandleOfflineModeCalled = false
    var networkConnectionExists = false
    var startMonitoringCalled = false

    func startMonitoring() {
        startMonitoringCalled = true

        if networkConnectionExists {
            delegateHandleOnlineModeCalled = true
            delegate?.handleOnlineMode()
        } else {
            delegateHandleOfflineModeCalled = true
            delegate?.handleOfflineMode()
        }
    }

}
