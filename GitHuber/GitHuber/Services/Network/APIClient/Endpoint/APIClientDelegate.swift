//
//  APIClientDelegate.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 8.10.22.
//

import Foundation

protocol APIClientDelegate: AnyObject {

    func handleLoadingStart()
    func handleLoadingFinish()

}
