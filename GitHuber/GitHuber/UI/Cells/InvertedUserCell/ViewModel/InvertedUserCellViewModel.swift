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
    private let databaseService: DatabaseServiceType
    private let fileManager: FileSystemManagerType
    private let imageInverter: ImageInversionType

    // MARK: Callbacks

    var showLoading: ((Bool) -> Void)?
    var updateAvatar: ((UIImage?) -> Void)?

    // MARK: Initialization

    init(userEntity: UserEntity, apiClient: APIClientType, databaseService: DatabaseServiceType, fileManager: FileSystemManagerType, imageInverter: ImageInversionType) {
        self.userEntity = userEntity
        self.apiClient = apiClient
        self.databaseService = databaseService
        self.fileManager = fileManager
        self.imageInverter = imageInverter
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
        let userData = UserCellData(username: userEntity.login ?? "", url: userEntity.htmlUrl ?? "")
        cell.bindData(userData)

        guard let avatarUrl = userEntity.avatarUrl, let avatarName = avatarUrl.components(separatedBy: "/").last else {
            return cell
        }

        if let imageData = fileManager.getFileFromCache(avatarName, type: .png), let avatar = UIImage(data: imageData) {
            let invertedAvatar = imageInverter.invertImage(avatar)
            updateAvatar?(invertedAvatar)
        } else {
            downloadAvatar(url: avatarUrl)
        }

        return cell
    }

}

// MARK: - Private

private extension InvertedUserCellViewModel {

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
                    self?.updateAvatar?(invertedAvatar)
                }
            case .failure(_):
                break
            }
        }
    }

}
