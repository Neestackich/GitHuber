//
//  UserProfileCoordinator.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import UIKit

final class UserProfileCoordinator: UserProfileCoordinatorType {

    // MARK: Properties

    private(set) weak var navigationController: UINavigationController?

    private struct Constants {
        static let storyboardName = "UserProfile"
        static let viewControllerID = "UserProfileID"
    }

    // MARK: Initialization

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

}

// MARK: - Public

extension UserProfileCoordinator {

    // MARK: Coordination

    func start() {
        let decoder = JSONDecoder()
        let apiConfig = APIConfig()
        let apiClient = APIClient(apiConfig: apiConfig)
        let databaseService = DatabaseService()
        let networkConnectionListener: NetworkConnectionListenerType = NetworkConnectionListener()
        let viewModel = UserProfileViewModel(coordinator: self,
                                             decoder: decoder,
                                             apiClient: apiClient,
                                             databaseService: databaseService,
                                             networkConnectionListener: networkConnectionListener)

        let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: nil)

        guard let userProfileViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerID) as? UserProfileView else {
            return
        }

        userProfileViewController.viewModel = viewModel
        navigationController?.pushViewController(userProfileViewController, animated: true)
    }

}
