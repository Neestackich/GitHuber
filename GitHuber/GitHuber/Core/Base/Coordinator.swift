//
//  Coordinator.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import UIKit

protocol Coordinator: AnyObject {

    init(navigationController: UINavigationController?)
    func start()

}
