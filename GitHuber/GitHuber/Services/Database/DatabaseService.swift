//
//  DatabaseService.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import UIKit
import CoreData

final class DatabaseService: DatabaseServiceType {

    private let fetchLimit: Int

    let readContext = (UIApplication.shared.delegate as? AppDelegate)?.getReadContext()
    let writeContext = (UIApplication.shared.delegate as? AppDelegate)?.getWriteContext()

    init(fetchLimit: Int) {
        self.fetchLimit = fetchLimit
    }

}

// MARK: - Public

extension DatabaseService {

    func usersCount() -> Int {
        guard let readContext = readContext else {
            return 0
        }

        let fetchRequest = UserEntity.fetchRequest()

        do {
            let count = try readContext.count(for: fetchRequest)
            return count
        } catch {
            return 0
        }
    }

    func getUsers(from: Int, completion: @escaping (Result<[UserEntity], Error>) -> Void) {
        guard let readContext = readContext else {
            completion(.failure(DatabaseError.contextError))
            return
        }

        let request = UserEntity.fetchRequest()
        let sortById = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sortById]
        request.fetchLimit = fetchLimit
        request.fetchOffset = from

        do {
            let users = try readContext.fetch(request)
            completion(.success(users))
        } catch {
            completion(.failure(DatabaseError.fetchError))
        }
    }

    func saveUser(_ user: User) {
        if userExists(user) {
            updateUser(user)
        } else {
            saveNewUser(user)
        }
    }

    func saveNewUser(_ user: User) {
        guard let writeContext = writeContext else {
            return
        }

        let userEntity = UserEntity(context: writeContext)
        userEntity.login = user.login
        userEntity.id = Int64(user.id)
        userEntity.nodeId = user.nodeId
        userEntity.avatarUrl = user.avatarUrl
        userEntity.gravatarId = user.gravatarId
        userEntity.url = user.url
        userEntity.htmlUrl = user.htmlUrl
        userEntity.followersUrl = user.followersUrl
        userEntity.followingUrl = user.followingUrl
        userEntity.gistsUrl = user.gistsUrl
        userEntity.starredUrl = user.starredUrl
        userEntity.subscriptionsUrl = user.subscriptionsUrl
        userEntity.organizationsUrl = user.organizationsUrl
        userEntity.reposUrl = user.reposUrl
        userEntity.eventsUrl = user.eventsUrl
        userEntity.receivedEventsUrl = user.receivedEventsUrl
        userEntity.type = user.type.rawValue
        userEntity.siteAdmin = user.siteAdmin
        userEntity.isSeen = false
    }

    func updateUser(_ updatedUser: User) {
        guard let writeContext = writeContext else {
            return
        }

        let fetchRequest = UserEntity.fetchRequest()
        let idPredicate = NSPredicate(format: "id = %@", String(updatedUser.id))
        fetchRequest.predicate = idPredicate

        do {
            let users = try writeContext.fetch(fetchRequest)
            guard let persistentUser = users.first else {
                return
            }

            persistentUser.login = updatedUser.login
            persistentUser.id = Int64(updatedUser.id)
            persistentUser.nodeId = updatedUser.nodeId
            persistentUser.avatarUrl = updatedUser.avatarUrl
            persistentUser.gravatarId = updatedUser.gravatarId
            persistentUser.url = updatedUser.url
            persistentUser.htmlUrl = updatedUser.htmlUrl
            persistentUser.followersUrl = updatedUser.followersUrl
            persistentUser.followingUrl = updatedUser.followingUrl
            persistentUser.gistsUrl = updatedUser.gistsUrl
            persistentUser.starredUrl = updatedUser.starredUrl
            persistentUser.subscriptionsUrl = updatedUser.subscriptionsUrl
            persistentUser.organizationsUrl = updatedUser.organizationsUrl
            persistentUser.reposUrl = updatedUser.reposUrl
            persistentUser.eventsUrl = updatedUser.eventsUrl
            persistentUser.receivedEventsUrl = updatedUser.receivedEventsUrl
            persistentUser.type = updatedUser.type.rawValue
            persistentUser.siteAdmin = updatedUser.siteAdmin
        } catch {
            return
        }
    }

    func hasNote(_ user: UserEntity) -> Bool {
        guard let readContext = readContext else {
            return false
        }

        let fetchRequest = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user = %@", user)

        do {
            let count = try readContext.count(for: fetchRequest)
            if count != 0 {
                return true
            }
        } catch let error {
            print("Error fetching songs: \(error)")
        }
        return false
    }

    func getNote(for profile: UserProfileEntity) -> NoteEntity? {
        return nil
    }

    func saveNote(for user: UserEntity) {
        
    }

}

// MARK: - Private

private extension DatabaseService {

    private func userExists(_ user: User) -> Bool {
        guard let readContext = readContext else {
            return false
        }

        let fetchRequest = UserEntity.fetchRequest()
        let idPredicate = NSPredicate(format: "id = %@", String(user.id))
        fetchRequest.predicate = idPredicate

        do {
            let count = try readContext.count(for: fetchRequest)
            if count != 0 {
                return true
            }
        } catch {
            print("Error fetching users count: \(error)")
        }

        return false
    }

}
