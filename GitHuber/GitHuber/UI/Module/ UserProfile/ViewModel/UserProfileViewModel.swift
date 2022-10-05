//
//  UserProfileViewModel.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import Foundation

final class UserProfileViewModel: UserProfileViewModelType {

    // MARK: Properties

    private let coordinator: UserProfileCoordinatorType
    private let decoder: JSONDecoder
    private let apiClient: APIClientType
    private let databaseService: DatabaseServiceType
    private let networkConnectionListener: NetworkConnectionListenerType

    // MARK: Initialization

    init(coordinator: UserProfileCoordinatorType,
         decoder: JSONDecoder,
         apiClient: APIClientType,
         databaseService: DatabaseServiceType,
         networkConnectionListener: NetworkConnectionListenerType) {
        self.coordinator = coordinator
        self.decoder = decoder
        self.apiClient = apiClient
        self.databaseService = databaseService
        self.networkConnectionListener = networkConnectionListener
    }

}

// MARK: - Public

extension UserProfileViewModel {

    func onViewDidLoad() {
        
    }

}
