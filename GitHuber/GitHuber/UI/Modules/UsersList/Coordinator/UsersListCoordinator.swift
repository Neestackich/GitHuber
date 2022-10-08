//
//  UsersListCoordinator.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import UIKit

final class UsersListCoordinator: UsersListCoordinatorType {

    // MARK: Properties

    private(set) weak var navigationController: UINavigationController?

    private struct Constants {
        static let storyboardName = "UsersList"
        static let viewControllerID = "UsersListID"
    }

    // MARK: Initialization

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

}

// MARK: - Public

extension UsersListCoordinator {

    // MARK: Coordination

    func start() {
        let decoder = JSONDecoder()
        let apiConfig = APIConfig()
        let networkConnectionListener = NetworkConnectionListener()
        let apiClient = APIClient()
        let databaseService = DatabaseService(fetchLimit: 30)
        let fileManager = FileSystemManager()
        

        let viewModel = UsersListViewModel(coordinator: self,
                                           decoder: decoder,
                                           apiClient: apiClient,
                                           networkConnectionListener: networkConnectionListener,
                                           apiConfig: apiConfig,
                                           databaseService: databaseService,
                                           fileManager: fileManager)
        networkConnectionListener.delegate = viewModel
        apiClient.delegate = viewModel

        let usersListViewController = UsersListView()

        usersListViewController.viewModel = viewModel
        navigationController?.pushViewController(usersListViewController, animated: true)
    }

    func userCellTap() {
        let userProfileCoordinator = UserProfileCoordinator(navigationController: navigationController)
        userProfileCoordinator.start()
    }

}
