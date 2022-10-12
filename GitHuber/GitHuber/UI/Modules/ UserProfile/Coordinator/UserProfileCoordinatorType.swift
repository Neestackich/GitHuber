//
//  UserProfileCoordinatorType.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import Foundation

protocol UserProfileCoordinatorType: CoordinatorType {

    // MARK: Coordination
    func start(with userEntity: UserEntity)

}
