//
//  UsersListCoordinatorType.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import Foundation

protocol UsersListCoordinatorType: CoordinatorType {
    func start()
    func userCellTap(userEntity: UserEntity, delegate: UserProfileViewModelDelegate, _ indexPath: IndexPath)
}
