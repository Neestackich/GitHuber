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
    private let readManagedObjectContext: NSManagedObjectContext
    private let writeManagedObjectOntext: NSManagedObjectContext

    init(coreDataStack: CoreDataStackType) {
        self.coreDataStack = coreDataStack
        self.readManagedObjectContext = coreDataStack.getReadManagedObjectContext()
        self.writeManagedObjectOntext = coreDataStack.getWriteManagedObjectContext()
    }

}

// MARK: - Public

extension DatabaseService {

    func getUsers(completion: @escaping (Result<[UserEntity], Error>) -> Void) {
        readManagedObjectContext.perform { [weak self] in
            guard let managedObjectContext = self?.readManagedObjectContext else {
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
        readManagedObjectContext.perform { [weak self] in
            guard let managedObjectContext = self?.readManagedObjectContext, let login = user.login else {
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
        writeManagedObjectOntext.performAndWait { [weak self] in
            for user in users {
                if let exists = self?.userExists(user), exists {
                    self?.updateUser(user)
                } else {
                    self?.saveNewUser(user)
                }
            }

            try? self?.writeManagedObjectOntext.save()
        }
    }

    func saveNote(for user: UserEntity, text: String?) {
        writeManagedObjectOntext.performAndWait { [weak self] in
            if let note = user.note {
                note.text = text
            } else {
                self?.saveNewNote(for: user, text: text)
            }

            try? self?.writeManagedObjectOntext.save()
        }
    }

    func saveUserProfile(for user: UserEntity, profileData: UserProfile) {
        writeManagedObjectOntext.performAndWait { [weak self] in
            if user.profile != nil {
                self?.updateUserProfile(for: user, profileData: profileData)
            } else {
                self?.saveNewUserProfile(for: user, profileData: profileData)
            }

            try? self?.writeManagedObjectOntext.save()
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
            let count = try readManagedObjectContext.count(for: fetchRequest)
            if count != 0 {
                return true
            }
        } catch {
            print("Error \(#function): \(error)")
        }

        return false
    }

    private func saveNewUser(_ user: User) {
        let userEntity = UserEntity(context: writeManagedObjectOntext)
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
            let users = try writeManagedObjectOntext.fetch(fetchRequest)

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
        let newNote = NoteEntity(context: writeManagedObjectOntext)
        newNote.text = text

        let userObjectId = user.objectID
        let userCopy = writeManagedObjectOntext.object(with: userObjectId) as? UserEntity

        userCopy?.note = newNote
        userCopy?.hasNote = true
    }

    private func updateUserProfile(for user: UserEntity, profileData: UserProfile) {
        let objectId = user.objectID
        let userCopy = writeManagedObjectOntext.object(with: objectId) as? UserEntity

        userCopy?.profile?.login = profileData.login
        userCopy?.profile?.id = Int64(profileData.id)
        userCopy?.profile?.nodeId = profileData.nodeId
        userCopy?.profile?.avatarUrl = profileData.avatarUrl
        userCopy?.profile?.gravatarId = profileData.gravatarId
        userCopy?.profile?.url = profileData.url
        userCopy?.profile?.htmlUrl = profileData.htmlUrl
        userCopy?.profile?.followersUrl = profileData.followersUrl
        userCopy?.profile?.followingUrl = profileData.followingUrl
        userCopy?.profile?.gistsUrl = profileData.gistsUrl
        userCopy?.profile?.starredUrl = profileData.starredUrl
        userCopy?.profile?.subscriptionsUrl = profileData.subscriptionsUrl
        userCopy?.profile?.organizationsUrl = profileData.organizationsUrl
        userCopy?.profile?.reposUrl = profileData.reposUrl
        userCopy?.profile?.eventsUrl = profileData.eventsUrl
        userCopy?.profile?.receivedEventsUrl = profileData.receivedEventsUrl
        userCopy?.profile?.type = profileData.type.rawValue
        userCopy?.profile?.siteAdmin = profileData.siteAdmin
        userCopy?.profile?.name = profileData.name
        userCopy?.profile?.company = profileData.company
        userCopy?.profile?.blog = profileData.blog
        userCopy?.profile?.location = profileData.location
        userCopy?.profile?.email = profileData.email
        userCopy?.profile?.hireable = profileData.hireable
        userCopy?.profile?.bio = profileData.bio
        userCopy?.profile?.twitterUsername = profileData.twitterUsername
        userCopy?.profile?.publicRepos = Int32(profileData.publicRepos)
        userCopy?.profile?.publicGists = Int32(profileData.publicGists)
        userCopy?.profile?.followers = Int32(profileData.followers)
        userCopy?.profile?.following = Int32(profileData.following)
        userCopy?.profile?.createdAt = profileData.createdAt
        userCopy?.profile?.updatedAt = profileData.updatedAt
    }

    private func saveNewUserProfile(for user: UserEntity, profileData: UserProfile) {
        let newProfile = UserProfileEntity(context: writeManagedObjectOntext)
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

        let userObjectId = user.objectID
        let userCopy = writeManagedObjectOntext.object(with: userObjectId) as? UserEntity

        userCopy?.profile = newProfile
        userCopy?.isSeen = true
    }

}
