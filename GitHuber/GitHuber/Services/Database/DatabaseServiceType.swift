//
//  DatabaseServiceType.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import Foundation

protocol DatabaseServiceType {
    func usersCount() -> Int
    func getUsers(from: Int, completion: @escaping (Result<[UserEntity], Error>) -> Void)
    func saveUser(_ user: User)
    func saveNewUser(_ user: User)
    func updateUser(_ updatedUser: User)

    func hasNote(_ user: UserEntity) -> Bool
    func getNote(for profile: UserProfileEntity) -> NoteEntity?
    func saveNote(for user: UserEntity)
}
