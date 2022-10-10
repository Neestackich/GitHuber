//
//  MockDatabaseService.swift
//  GitHuberTests
//
//  Created by Vittcal Neestackich on 9.10.22.
//

import XCTest
@testable import GitHuber
import CoreData

final class MockDatabaseService: DatabaseServiceType {

    var databaseError: DatabaseError?

    var getUsersCalled = false

    var userEntity: UserEntity!
    var profileEntity: UserProfileEntity!
    var usersEmpty = false
    var getUserCalled = false

    var savedUser: UserEntity!
    var saveUserCalled = false

    var savedUsers: [UserEntity]!
    var saveUsersCalled = false

    var text: String?
    var saveNoteCalled = false

    var saveUserProfileCalled = false

    private var testContext: NSManagedObjectContext!

    init(testContext: NSManagedObjectContext) {
        self.testContext = testContext
    }

    func getUsers(completion: @escaping (Result<[UserEntity], Error>) -> Void) {
        getUsersCalled = true

        if !usersEmpty {
            userEntity = UserEntity(context: testContext)
            completion(.success([userEntity]))
        } else {
            completion(.failure(DatabaseError.fetchError))
        }
    }

    func getUser(_ user: UserEntity, completion: @escaping (Result<UserEntity, Error>) -> Void) {
        getUserCalled = true

        if !usersEmpty {
            userEntity = UserEntity(context: testContext)
            profileEntity = UserProfileEntity(context: testContext)
            userEntity.profile = profileEntity
            completion(.success(userEntity))
        } else {
            completion(.failure(DatabaseError.fetchError))
        }
    }

    func saveUser(_ user: User) {
        saveUserCalled = true
    }

    func saveNote(for user: UserEntity, text: String?) {
        saveNoteCalled = true
        self.text = text
    }

    func saveUserProfile(for user: UserEntity, profileData: UserProfile) {
        saveUserProfileCalled = true
    }

}
