//
//  UsersListViewModel.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import UIKit

final class UsersListViewModel: UsersListViewModelType {

    // MARK: Properties

    private var users: [UserEntity] = []
    private var sortedUsers: [UserEntity] = []

    private let coordinator: UsersListCoordinatorType
    private let decoder: JSONDecoder
    private let apiClient: APIClientType
    private var networkConnectionListener: NetworkConnectionListenerType
    private let apiConfig: APIConfigType
    private let databaseService: DatabaseServiceType
    private let fileManager: FileSystemManagerType

    // MARK: CallBacks

    var reloadData: (() -> Void)?
    var endTableViewRefreshing: (() -> Void)?
    var showLoading: ((Bool) -> Void)?
    var showOfflineView: ((Bool) -> Void)?

    // MARK: Initialization

    init(coordinator: UsersListCoordinatorType,
         decoder: JSONDecoder,
         apiClient: APIClientType,
         networkConnectionListener: NetworkConnectionListenerType,
         apiConfig: APIConfigType,
         databaseService: DatabaseServiceType,
         fileManager: FileSystemManagerType) {
        self.coordinator = coordinator
        self.decoder = decoder
        self.apiClient = apiClient
        self.networkConnectionListener = networkConnectionListener
        self.apiConfig = apiConfig
        self.databaseService = databaseService
        self.fileManager = fileManager
    }

    // MARK: Lifecycle

    func onViewDidLoad() {
        loadUsersFromDataBase(from: users.count)
        startConnectionListener()
        loadUsersFromBackend(from: 0)
    }

}

// MARK: - Public

extension UsersListViewModel {

    func userCellTap() {
        coordinator.userCellTap()
    }

    func getUsersCount() -> Int {
        return sortedUsers.count
    }

    func getSortedUsersCount() -> Int {
        return sortedUsers.count
    }

    func getCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UserCellType? {
        let cellType = getCellType(cellForRowAt: indexPath)
        let userEntity = sortedUsers[indexPath.row]

        switch cellType {
        case .normal:
            let viewModel = NormalUserCellViewModel(userEntity: userEntity, apiClient: apiClient, databaseService: databaseService, fileManager: fileManager)
            let cell = viewModel.getCell(tableView, cellForRowAt: indexPath)
            return cell
        case .note:
            let viewModel = NoteUserCellViewModel(userEntity: userEntity, apiClient: apiClient, databaseService: databaseService, fileManager: fileManager)
            let cell = viewModel.getCell(tableView, cellForRowAt: indexPath)
            return cell
        case .inverted:
            let imageInverter = ImageInversion()
            let viewModel = InvertedUserCellViewModel(userEntity: userEntity, apiClient: apiClient, databaseService: databaseService, fileManager: fileManager, imageInverter: imageInverter)
            let cell = viewModel.getCell(tableView, cellForRowAt: indexPath)
            return cell
        }
    }

    func searchBarTextDidBeginEditing() {
        // disable pagination
    }

    func searchBarTextDidChange(with query: String) {
        guard !query.isEmpty else {
            sortedUsers = users
            reloadData?()
            return
        }

        sortedUsers.removeAll()
        let usersWithSameUserName = users.filter { $0.login?.contains(query) ?? false }
        sortedUsers = usersWithSameUserName

        DispatchQueue.main.async { [weak self] in
            self?.reloadData?()
        }
        // gets user's note
    }

    func searchBarTextDidEndEditing() {
        sortedUsers = users
        DispatchQueue.main.async { [weak self] in
            self?.reloadData?()
        }
    }

}

// MARK: - Private

private extension UsersListViewModel {

    private func startConnectionListener() {
        networkConnectionListener.startMonitoring()
    }

    private func loadUsersFromDataBase(from: Int) {
        databaseService.getUsers(from: from) { [weak self] result in
            switch result {
            case .success(let users):
                if from == 0 {
                    self?.users = users
                    self?.sortedUsers = users
                } else {
                    self?.users += users
                    self?.sortedUsers += users
                }

                DispatchQueue.main.async {
                    self?.reloadData?()
                }
            case .failure(let error):
                // show error alert
                print(error)
                break
            }
        }
    }

    private func loadUsersFromBackend(from: Int) {
        apiClient.sendRequestToQueue(endpoint: .getUsersList(apiConfig: apiConfig, userNumberToStartFrom: from)) { [weak self] response in
            switch response {
            case .success(let data):
                if let users = try? self?.decoder.decode([User].self, from: data) {

                    for user in users {
                        self?.databaseService.saveUser(user)
                    }

                    self?.loadUsersFromDataBase(from: from)
                } else if let errorData = try? self?.decoder.decode(ErrorResponse.self, from: data) {
                    // show alert pop up here
                    print(errorData)
                }
                break
            case .failure(let error):
                print(error)
                break
                // show alert pop up here
            }
        }
    }

    private func getCellType(cellForRowAt indexPath: IndexPath) -> CellType {
        if (indexPath.row + 1) % 4 == 0 {
            return .inverted
        } else if hasNotes(cellForRowAt: indexPath) {
            return .note
        } else {
            return .normal
        }
    }

    private func hasNotes(cellForRowAt indexPath: IndexPath) -> Bool {
        guard indexPath.row > 0, users.count > indexPath.row else {
            return false
        }

        let user = users[indexPath.row]

        return databaseService.hasNote(user)
    }

}

// MARK: - NetworkConnectionHandlerDelegate

extension UsersListViewModel: NetworkConnectionListenerDelegate {

    func handleOfflineMode() {
        DispatchQueue.main.async { [weak self] in
            self?.showLoading?(false)
            self?.showOfflineView?(true)
        }
    }

    func handleOnlineMode() {
        DispatchQueue.main.async { [weak self] in
            self?.showOfflineView?(false)
        }
    }

}

// MARK: - APIClientDelegate

extension UsersListViewModel: APIClientDelegate {

    func handleLoadingStart() {
        DispatchQueue.main.async { [weak self] in
            self?.showLoading?(true)
        }
    }

    func handleLoadingFinish() {
        DispatchQueue.main.async { [weak self] in
            self?.showLoading?(false)
        }
    }

}