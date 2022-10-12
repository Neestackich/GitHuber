//
//  UsersListCoordinatorType.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import Foundation

protocol UsersListCoordinatorType: CoordinatorType {

    // MARK: Coordination
    func start()
    func userCellTap(userEntity: UserEntity)

}
