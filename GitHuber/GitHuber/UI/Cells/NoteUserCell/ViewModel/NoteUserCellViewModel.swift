//
//  NoteUserCellViewModel.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 6.10.22.
//

import UIKit

final class NoteUserCellViewModel: NoteUserCellViewModelType {

    // MARK: Properties

    private let userEntity: UserEntity
    private let apiClient: APIClientType
    private let fileManager: FileSystemManagerType

    // MARK: Callbacks

    var showLoading: ((Bool) -> Void)?
    var updateAvatar: ((UIImage?) -> Void)?

    // MARK: Initialization

    init(userEntity: UserEntity, apiClient: APIClientType, fileManager: FileSystemManagerType) {
        self.userEntity = userEntity
        self.apiClient = apiClient
        self.fileManager = fileManager
    }

    func onAwakeFromNib() {
        loadAvatar()
    }

}

// MARK: - Public

extension NoteUserCellViewModel {

    func getCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UserCellType? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "noteUserCell") as? NoteUserCell else {
            return nil
        }

        cell.viewModel = self
        cell.bindViewModel()
        let userData = UserCellBindableData(username: userEntity.login ?? "", url: userEntity.htmlUrl ?? "", isSeen: userEntity.isSeen)
        cell.bindData(userData)

        return cell
    }

}

// MARK: - Private

private extension NoteUserCellViewModel {

    private func loadAvatar() {
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
            showLoading?(true)
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
                    self?.showLoading?(false)
                    self?.updateAvatar?(avatar)
                }
            case .failure(_):
                break
            }
        }
    }

}
