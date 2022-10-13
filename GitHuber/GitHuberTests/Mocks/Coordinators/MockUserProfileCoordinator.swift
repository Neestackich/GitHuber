//
//  MockUserProfileCoordinator.swift
//  GitHuberTests
//
//  Created by Vittcal Neestackich on 10.10.22.
//

import XCTest
@testable import GitHuber

final class MockUserProfileCoordinator: UserProfileCoordinatorType {

    var navigationController: UINavigationController?

    var userEntity: UserEntity?
    var startCalled = false

    func start(with userEntity: UserEntity) {
        startCalled = true
        self.userEntity = userEntity
    }

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

}
