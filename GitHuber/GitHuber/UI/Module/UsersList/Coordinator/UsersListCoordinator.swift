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
        let apiClient = APIClient(apiConfig: apiConfig)
        let databaseService = DatabaseService()
        let fileManager = FileSystemManager()
        let networkConnectionListener: NetworkConnectionListenerType = NetworkConnectionListener()
        let viewModel = UsersListViewModel(coordinator: self,
                                           decoder: decoder,
                                           apiClient: apiClient,
                                           databaseService: databaseService,
                                           fileManager: fileManager,
                                           networkConnectionListener: networkConnectionListener)

        let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: nil)

        guard let usersListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerID) as? UsersListView else {
            return
        }

        usersListViewController.viewModel = viewModel
        navigationController?.pushViewController(usersListViewController, animated: true)
    }

    func userCellTap() {
        let userProfileCoordinator = UserProfileCoordinator(navigationController: navigationController)
        userProfileCoordinator.start()
    }

}
