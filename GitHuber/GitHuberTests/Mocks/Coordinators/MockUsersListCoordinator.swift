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
    var delegate: UserProfileViewModelDelegate?
    var indexPath: IndexPath?
    var userCellTapCalled = false

    func start() {
        
    }

    func userCellTap(userEntity: UserEntity, delegate: UserProfileViewModelDelegate, _ indexPath: IndexPath) {
        userCellTapCalled = true
        self.userEntity = userEntity
        self.delegate = delegate
        self.indexPath = indexPath
    }

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

}
