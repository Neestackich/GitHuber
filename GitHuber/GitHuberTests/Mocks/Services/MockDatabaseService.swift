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
            let entityDescription = NSEntityDescription.entity(forEntityName: "UserEntity", in: testContext)
            userEntity = UserEntity(entity: entityDescription!, insertInto: testContext)
            completion(.success([userEntity]))
        } else {
            completion(.failure(DatabaseError.fetchError))
        }
    }

    func getUser(_ user: UserEntity, completion: @escaping (Result<UserEntity, Error>) -> Void) {
        getUserCalled = true

        if !usersEmpty {
            let userEntityDescription = NSEntityDescription.entity(forEntityName: "UserEntity", in: testContext)
            userEntity = UserEntity(entity: userEntityDescription!, insertInto: testContext)
            let userProfileDescription = NSEntityDescription.entity(forEntityName: "UserProfileEntity", in: testContext)
            profileEntity = UserProfileEntity(entity: userProfileDescription!, insertInto: testContext)
            userEntity.profile = profileEntity
            completion(.success(userEntity))
        } else {
            completion(.failure(DatabaseError.fetchError))
        }
    }

    func saveUsers(_ users: [User]) {
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
