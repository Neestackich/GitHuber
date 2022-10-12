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

    private var paginationEnabled = true

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
        loadUsersFromBackend(from: 0)
        startConnectionListener()
    }

    func onViewWillAppear() {
        loadUsersFromDataBase()
    }

}

// MARK: - Public

extension UsersListViewModel {

    func userCellTap(didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 > 0, sortedUsers.count > indexPath.row else {
            return
        }

        let userEntity = sortedUsers[indexPath.row]
        coordinator.userCellTap(userEntity: userEntity)
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
            let viewModel = NormalUserCellViewModel(userEntity: userEntity, apiClient: apiClient, fileManager: fileManager)
            let cell = viewModel.getCell(tableView, cellForRowAt: indexPath)
            return cell
        case .note:
            let viewModel = NoteUserCellViewModel(userEntity: userEntity, apiClient: apiClient, fileManager: fileManager)
            let cell = viewModel.getCell(tableView, cellForRowAt: indexPath)
            return cell
        case .inverted:
            let imageInverter = ImageInversion()
            let viewModel = InvertedUserCellViewModel(userEntity: userEntity, apiClient: apiClient, fileManager: fileManager, imageInverter: imageInverter)
            let cell = viewModel.getCell(tableView, cellForRowAt: indexPath)
            return cell
        }
    }

    func searchBarTextDidBeginEditing() {
        paginationEnabled = false
    }

    func searchBarTextDidChange(with query: String) {
        guard !query.isEmpty else {
            sortedUsers = users
            reloadData?()
            return
        }

        sortedUsers.removeAll()
        let usersWithSameUserName = users.filter { ($0.login?.contains(query) ?? false) || (($0.note?.text?.contains(query)) ?? false) }
        sortedUsers = usersWithSameUserName

        DispatchQueue.main.async { [weak self] in
            self?.reloadData?()
        }
    }

    func searchBarTextDidEndEditing() {
        paginationEnabled = true
        sortedUsers = users
        DispatchQueue.main.async { [weak self] in
            self?.reloadData?()
        }
    }

    func paginate() {
        if paginationEnabled, let lastUserId = users.last?.id {
            loadUsersFromBackend(from: Int(lastUserId))
        }
    }

}

// MARK: - Private

private extension UsersListViewModel {

    private func startConnectionListener() {
        networkConnectionListener.startMonitoring()
    }

    private func loadUsersFromDataBase() {
        databaseService.getUsers() { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.sortedUsers = users

                DispatchQueue.main.async {
                    self?.reloadData?()
                }
            case .failure(let error):
                print(error)
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

                    self?.loadUsersFromDataBase()
                } else if let errorData = try? self?.decoder.decode(ErrorResponse.self, from: data) {
                    print(errorData)
                }
            case .failure(let error):
                print(error)
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
        guard indexPath.row + 1 > 0, sortedUsers.count > indexPath.row else {
            return false
        }

        let user = sortedUsers[indexPath.row]

        return user.hasNote
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
