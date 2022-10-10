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
    var delegate: UserProfileViewModelDelegate?
    var indexPath: IndexPath?
    var startCalled = false

    func start(with userEntity: UserEntity, delegate: UserProfileViewModelDelegate, _ indexPath: IndexPath) {
        startCalled = true
        self.userEntity = userEntity
        self.delegate = delegate
        self.indexPath = indexPath
    }

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

}
