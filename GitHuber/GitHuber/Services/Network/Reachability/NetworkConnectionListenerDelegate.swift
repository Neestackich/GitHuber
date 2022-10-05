//
//  NetworkConnectionListenerDelegate.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import Foundation

protocol NetworkConnectionListenerDelegate: AnyObject {
    func handleOfflineMode()
    func handleOnlineMode()
}
