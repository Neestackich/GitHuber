//
//  InvertedUserCellViewModel.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 6.10.22.
//

import UIKit

final class InvertedUserCellViewModel: InvertedUserCellViewModelType {

    // MARK: Properties

    private let userEntity: UserEntity
    private let apiClient: APIClientType
    private let fileManager: FileSystemManagerType
    private let imageInverter: ImageInversionType

    // MARK: Callbacks

    var showLoading: ((Bool) -> Void)?
    var updateAvatar: ((UIImage?) -> Void)?

    // MARK: Initialization

    init(userEntity: UserEntity, apiClient: APIClientType, fileManager: FileSystemManagerType, imageInverter: ImageInversionType) {
        self.userEntity = userEntity
        self.apiClient = apiClient
        self.fileManager = fileManager
        self.imageInverter = imageInverter
    }

    func onAwakeFromNib() {
        loadAvatar()
    }

}

// MARK: - Public

extension InvertedUserCellViewModel {

    func getCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UserCellType? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "invertedUserCell") as? InvertedUserCell else {
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

private extension InvertedUserCellViewModel {

    private func loadAvatar() {
        guard let avatarUrl = userEntity.avatarUrl, let avatarName = avatarUrl.components(separatedBy: "/").last else {
            return
        }

        if fileManager.fileExists(avatarName, type: .png) {
            fileManager.getFileFromCache(avatarName, type: .png) { [weak self] result in
                switch result {
                case .success(let data):
                    guard let avatar = UIImage(data: data) else {
                        return
                    }

                    let invertedAvatar = self?.imageInverter.invertImage(avatar)

                    DispatchQueue.main.async {
                        self?.updateAvatar?(invertedAvatar)
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

                let invertedAvatar = self?.imageInverter.invertImage(avatar)

                DispatchQueue.main.async {
                    self?.showLoading?(false)
                    self?.updateAvatar?(invertedAvatar)
                }
            case .failure(_):
                break
            }
        }
    }

}
