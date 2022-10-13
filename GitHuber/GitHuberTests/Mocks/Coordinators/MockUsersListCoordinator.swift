//
//  MockUsersListCoordinator.swift
//  GitHuberTests
//
//  Created by Vittcal Neestackich on 10.10.22.
//

import XCTest
@testable import GitHuber

final class MockUsersListCoordinator: UsersListCoordinatorType {

    var navigationController: UINavigationController?

    var userEntity: UserEntity?
    var userCellTapCalled = false

    func start() {
        
    }

    func userCellTap(userEntity: UserEntity) {
        userCellTapCalled = true
        self.userEntity = userEntity
    }

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

}
