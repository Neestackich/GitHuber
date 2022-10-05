//
//  UsersListViewModel.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import Foundation

final class UsersListViewModel: UsersListViewModelType {

    // MARK: Properties

    private let coordinator: UsersListCoordinatorType
    private let decoder: JSONDecoder
    private let apiClient: APIClientType
    private let databaseService: DatabaseServiceType
    private let fileManager: FileSystemManagerType
    private let networkConnectionListener: NetworkConnectionListenerType

    // MARK: Initialization

    init(coordinator: UsersListCoordinatorType,
         decoder: JSONDecoder,
         apiClient: APIClientType,
         databaseService: DatabaseServiceType,
         fileManager: FileSystemManagerType,
         networkConnectionListener: NetworkConnectionListenerType) {
        self.coordinator = coordinator
        self.decoder = decoder
        self.apiClient = apiClient
        self.databaseService = databaseService
        self.fileManager = fileManager
        self.networkConnectionListener = networkConnectionListener
    }

}

// MARK: - Public

extension UsersListViewModel {

    func onViewDidLoad() {
        updateUsersList()
    }

    func userCellTap() {
        
    }

}

// MARK: - Private

private extension UsersListViewModel {

    private func updateUsersList() {
        apiClient.sendRequestToQueue(endpoint: .getUsersList(userNumberToStartFrom: 0)) { [weak self] response in
            switch response {
            case .success(let data):
                if let usersList = try? self?.decoder.decode([User].self, from: data) {
                    // save to db
                    // reload tableView
                    // stop spinner
                    // start loading images + followers + following
                } else if let errorData = try? self?.decoder.decode(ErrorResponse.self, from: data) {
                    // load data from db
                    // show alert pop up here
                }
                break
            case .failure(let error):
                break
                // load data from db
                // show alert pop up here
            }
        }
    }

}

// MARK: - NetworkConnectionHandlerDelegate

extension UsersListViewModel: NetworkConnectionListenerDelegate {

    func handleOfflineMode() {
        // load data from db
        // show connection lost view
    }

    func handleOnlineMode() {
        // hide connection lost view
    }

}
