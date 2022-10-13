//
//  DatabaseService.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import Foundation
import CoreData

final class DatabaseService: DatabaseServiceType {

    // MARK: Contexts

    private let coreDataStack: CoreDataStackType
    private let managedObjectContext: NSManagedObjectContext

    init(coreDataStack: CoreDataStackType) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.getManagedObjectContext()
    }

}

// MARK: - Public

extension DatabaseService {

    func getUsers(completion: @escaping (Result<[UserEntity], Error>) -> Void) {
        managedObjectContext.perform { [weak self] in
            guard let managedObjectContext = self?.managedObjectContext else {
                return
            }

            let request = UserEntity.fetchRequest()
            let sortById = NSSortDescriptor(key: "id", ascending: true)
            request.sortDescriptors = [sortById]

            do {
                let users = try managedObjectContext.fetch(request)
                completion(.success(users))
            } catch {
                completion(.failure(DatabaseError.fetchError))
            }
        }
    }

    func getUser(_ user: UserEntity, completion: @escaping (Result<UserEntity, Error>) -> Void) {
        managedObjectContext.perform { [weak self] in
            guard let managedObjectContext = self?.managedObjectContext, let login = user.login else {
                return
            }

            let fetchRequest = UserEntity.fetchRequest()
            let idPredicate = NSPredicate(format: "login = %@", login)
            fetchRequest.predicate = idPredicate

            do {
                let users = try managedObjectContext.fetch(fetchRequest)
                guard let persistentUser = users.first else {
                    completion(.failure(DatabaseError.fetchError))
                    return
                }

                completion(.success(persistentUser))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func saveUsers(_ users: [User]) {
        managedObjectContext.performAndWait { [weak self] in
            for user in users {
                if let exists = self?.userExists(user), exists {
                    self?.updateUser(user)
                } else {
                    self?.saveNewUser(user)
                }
            }

            self?.coreDataStack.saveContextsIfNeeded()
        }
    }

    func saveNote(for user: UserEntity, text: String?) {
        managedObjectContext.performAndWait { [weak self] in
            if let note = user.note {
                note.text = text
            } else {
                self?.saveNewNote(for: user, text: text)
            }

            self?.coreDataStack.saveContextsIfNeeded()
        }
    }

    func saveUserProfile(for user: UserEntity, profileData: UserProfile) {
        managedObjectContext.performAndWait { [weak self] in
            if user.profile != nil {
                self?.updateUserProfile(for: user, profileData: profileData)
            } else {
                self?.saveNewUserProfile(for: user, profileData: profileData)
            }

            self?.coreDataStack.saveContextsIfNeeded()
        }
    }

}

// MARK: - Private

private extension DatabaseService {

    private func userExists(_ user: User) -> Bool {
        let fetchRequest = UserEntity.fetchRequest()
        let idPredicate = NSPredicate(format: "login = %@", user.login)
        fetchRequest.predicate = idPredicate

        do {
            let count = try managedObjectContext.count(for: fetchRequest)
            if count != 0 {
                return true
            }
        } catch {
            print("Error \(#function): \(error)")
        }

        return false
    }

    private func saveNewUser(_ user: User) {
        let userEntity = UserEntity(context: managedObjectContext)
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
    }

    private func updateUser(_ updatedUser: User) {
        let fetchRequest = UserEntity.fetchRequest()
        let idPredicate = NSPredicate(format: "login = %@", updatedUser.login)
        fetchRequest.predicate = idPredicate

        do {
            let users = try managedObjectContext.fetch(fetchRequest)

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
            print("Error \(#function): \(error)")
        }
    }

    private func saveNewNote(for user: UserEntity, text: String?) {
        let newNote = NoteEntity(context: managedObjectContext)
        newNote.text = text
        user.note = newNote
        user.hasNote = true
    }

    private func updateUserProfile(for user: UserEntity, profileData: UserProfile) {
        user.profile?.login = profileData.login
        user.profile?.id = Int64(profileData.id)
        user.profile?.nodeId = profileData.nodeId
        user.profile?.avatarUrl = profileData.avatarUrl
        user.profile?.gravatarId = profileData.gravatarId
        user.profile?.url = profileData.url
        user.profile?.htmlUrl = profileData.htmlUrl
        user.profile?.followersUrl = profileData.followersUrl
        user.profile?.followingUrl = profileData.followingUrl
        user.profile?.gistsUrl = profileData.gistsUrl
        user.profile?.starredUrl = profileData.starredUrl
        user.profile?.subscriptionsUrl = profileData.subscriptionsUrl
        user.profile?.organizationsUrl = profileData.organizationsUrl
        user.profile?.reposUrl = profileData.reposUrl
        user.profile?.eventsUrl = profileData.eventsUrl
        user.profile?.receivedEventsUrl = profileData.receivedEventsUrl
        user.profile?.type = profileData.type.rawValue
        user.profile?.siteAdmin = profileData.siteAdmin
        user.profile?.name = profileData.name
        user.profile?.company = profileData.company
        user.profile?.blog = profileData.blog
        user.profile?.location = profileData.location
        user.profile?.email = profileData.email
        user.profile?.hireable = profileData.hireable
        user.profile?.bio = profileData.bio
        user.profile?.twitterUsername = profileData.twitterUsername
        user.profile?.publicRepos = Int32(profileData.publicRepos)
        user.profile?.publicGists = Int32(profileData.publicGists)
        user.profile?.followers = Int32(profileData.followers)
        user.profile?.following = Int32(profileData.following)
        user.profile?.createdAt = profileData.createdAt
        user.profile?.updatedAt = profileData.updatedAt
    }

    private func saveNewUserProfile(for user: UserEntity, profileData: UserProfile) {
        let newProfile = UserProfileEntity(context: managedObjectContext)
        newProfile.login = profileData.login
        newProfile.id = Int64(profileData.id)
        newProfile.nodeId = profileData.nodeId
        newProfile.avatarUrl = profileData.avatarUrl
        newProfile.gravatarId = profileData.gravatarId
        newProfile.url = profileData.url
        newProfile.htmlUrl = profileData.htmlUrl
        newProfile.followersUrl = profileData.followersUrl
        newProfile.followingUrl = profileData.followingUrl
        newProfile.gistsUrl = profileData.gistsUrl
        newProfile.starredUrl = profileData.starredUrl
        newProfile.subscriptionsUrl = profileData.subscriptionsUrl
        newProfile.organizationsUrl = profileData.organizationsUrl
        newProfile.reposUrl = profileData.reposUrl
        newProfile.eventsUrl = profileData.eventsUrl
        newProfile.receivedEventsUrl = profileData.receivedEventsUrl
        newProfile.type = profileData.type.rawValue
        newProfile.siteAdmin = profileData.siteAdmin
        newProfile.name = profileData.name
        newProfile.company = profileData.company
        newProfile.blog = profileData.blog
        newProfile.location = profileData.location
        newProfile.email = profileData.email
        newProfile.hireable = profileData.hireable
        newProfile.bio = profileData.bio
        newProfile.twitterUsername = profileData.twitterUsername
        newProfile.publicRepos = Int32(profileData.publicRepos)
        newProfile.publicGists = Int32(profileData.publicGists)
        newProfile.followers = Int32(profileData.followers)
        newProfile.following = Int32(profileData.following)
        newProfile.createdAt = profileData.createdAt
        newProfile.updatedAt = profileData.updatedAt

        user.profile = newProfile
        user.isSeen = true
    }

}
