//
//  UserProfileCoordinatorType.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import Foundation

protocol UserProfileCoordinatorType: CoordinatorType {
    func start(with userEntity: UserEntity, delegate: UserProfileViewModelDelegate, _ indexPath: IndexPath)
}
