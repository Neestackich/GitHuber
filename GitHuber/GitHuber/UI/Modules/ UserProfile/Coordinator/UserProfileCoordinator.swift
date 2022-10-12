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

    func start(with userEntity: UserEntity) {
        let decoder = JSONDecoder()
        let apiConfig = APIConfig()
        let networkConnectionListener = NetworkConnectionListener()
        let apiClient = APIClient()
        guard let coreDataStack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else {
            return
        }
        let databaseService = DatabaseService(coreDataStack: coreDataStack)
        let fileManager = FileSystemManager()
        let viewModel = UserProfileViewModel(
            userEntity: userEntity,
            coordinator: self,
            decoder: decoder,
            apiClient: apiClient,
            apiConfig: apiConfig,
            databaseService: databaseService,
            fileManager: fileManager,
            networkConnectionListener: networkConnectionListener)
        networkConnectionListener.delegate = viewModel
        apiClient.delegate = viewModel

        let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: nil)

        guard let userProfileViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerID) as? UserProfileView else {
            return
        }

        userProfileViewController.viewModel = viewModel
        navigationController?.pushViewController(userProfileViewController, animated: true)
    }

}
