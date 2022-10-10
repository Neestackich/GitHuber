//
//  UserProfileViewModel.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import UIKit

final class UserProfileViewModel: UserProfileViewModelType {

    // MARK: Properties

    private var userEntity: UserEntity
    private var indexPath: IndexPath

    weak var delegate: UserProfileViewModelDelegate?

    private let coordinator: UserProfileCoordinatorType
    private let decoder: JSONDecoder
    private let apiClient: APIClientType
    private let apiConfig: APIConfigType
    private let databaseService: DatabaseServiceType
    private let fileManager: FileSystemManagerType
    private let networkConnectionListener: NetworkConnectionListenerType

    private struct Constants {
        static let userNoteTextView = "Type to add note..."
    }

    // MARK: CallBacks

    var showLoading: ((Bool) -> Void)?
    var showOfflineView: ((Bool) -> Void)?
    var updateAvatar: ((UIImage?) -> Void)?
    var bindData: ((UserProfileViewBindableData) -> Void)?
    var updateTitle: ((String?) -> Void)?
    var updateNote: ((String?) -> Void)?
    var endEditing: (() -> Void)?

    // MARK: Initialization

    init(userEntity: UserEntity,
         indexPath: IndexPath,
         coordinator: UserProfileCoordinatorType,
         decoder: JSONDecoder,
         apiClient: APIClientType,
         apiConfig: APIConfigType,
         databaseService: DatabaseServiceType,
         fileManager: FileSystemManagerType,
         networkConnectionListener: NetworkConnectionListenerType) {
        self.userEntity = userEntity
        self.indexPath = indexPath
        self.coordinator = coordinator
        self.decoder = decoder
        self.apiClient = apiClient
        self.apiConfig = apiConfig
        self.databaseService = databaseService
        self.fileManager = fileManager
        self.networkConnectionListener = networkConnectionListener
    }

}

// MARK: - Public

extension UserProfileViewModel {

    // MARK: Lifecycle

    func onViewDidLoad() {
        userEntity.isSeen = true

        loadUserAvatar()
        bindUserProfileData()
        loadUserProfileFromBackend()
        startConnectionListener()
    }

    func saveNoteButtonClick(text: String?) {
        endEditing?()
        databaseService.saveNote(for: userEntity, text: text)
        delegate?.reloadUserCell(at: indexPath)
    }

    func textViewDidBeginEditing() {
        if userEntity.note?.text == nil {
            updateNote?("")
        }
    }

}

// MARK: - Private

private extension UserProfileViewModel {

    private func startConnectionListener() {
        networkConnectionListener.startMonitoring()
    }

    private func bindUserProfileData() {
        let bindableData = UserProfileViewBindableData(
            name: userEntity.profile?.name ?? "",
            company: userEntity.profile?.company ?? "No",
            blog: userEntity.profile?.blog ?? "No",
            followers: String(userEntity.profile?.followers ?? 0),
            following: String(userEntity.profile?.following ?? 0), note: userEntity.note?.text ?? Constants.userNoteTextView)

        DispatchQueue.main.async { [weak self] in
            self?.updateTitle?(self?.userEntity.profile?.login)
            self?.bindData?(bindableData)
        }
    }

    private func loadUserFromDataBase() {
        databaseService.getUser(userEntity) { [weak self] result in
            switch result {
            case .success(let user):
                self?.userEntity = user
                self?.bindUserProfileData()
            case .failure(let error):
                print(error)
            }
        }
    }

    private func loadUserProfileFromBackend() {
        guard let username = userEntity.login else {
            return
        }

        apiClient.sendRequestToQueue(endpoint: .getUserProfile(apiConfig: apiConfig, username: username)) { [weak self] response in
            switch response {
            case .success(let data):
                if let userProfile = try? self?.decoder.decode(UserProfile.self, from: data),
                   let user = self?.userEntity {
                    self?.databaseService.saveUserProfile(for: user, profileData: userProfile)
                    self?.loadUserFromDataBase()
                } else if let errorData = try? self?.decoder.decode(ErrorResponse.self, from: data) {
                    print(errorData)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func loadUserAvatar() {
        guard let avatarUrl = userEntity.avatarUrl, let avatarName = avatarUrl.components(separatedBy: "/").last else {
            return
        }

        if fileManager.fileExists(avatarName, type: .png) {
            fileManager.getFileFromCache(avatarName, type: .png) { [weak self] result in
                switch result {
                case .success(let data):
                    let avatar = UIImage(data: data)
                    DispatchQueue.main.async {
                        self?.updateAvatar?(avatar)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            downloadAvatar(url: avatarUrl)
        }
    }

    private func downloadAvatar(url: String) {
        apiClient.sendRequestToQueue(endpoint: .getImage(path: url)) { [weak self] response in
            switch response {
            case .success(let data):
                guard let avatar = UIImage(data: data), let avatarName = url.components(separatedBy: "/").last else {
                    return
                }

                self?.fileManager.saveFileToCache(avatarName, type: .png, data: data)

                DispatchQueue.main.async {
                    self?.updateAvatar?(avatar)
                }
            case .failure(_):
                break
            }
        }
    }

}

// MARK: - NetworkConnectionHandlerDelegate

extension UserProfileViewModel: NetworkConnectionListenerDelegate {

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

extension UserProfileViewModel: APIClientDelegate {

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
