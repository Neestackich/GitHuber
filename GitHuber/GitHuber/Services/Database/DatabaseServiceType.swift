//
//  DatabaseServiceType.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import Foundation

protocol DatabaseServiceType {

    // MARK: - User
    func getUsers(completion: @escaping (Result<[UserEntity], Error>) -> Void)
    func getUser(_ user: UserEntity, completion: @escaping (Result<UserEntity, Error>) -> Void)
    func saveUsers(_ users: [User])

    // MARK: - Note
    func saveNote(for user: UserEntity, text: String?)

    // MARK: - Profile
    func saveUserProfile(for user: UserEntity, profileData: UserProfile)

}
