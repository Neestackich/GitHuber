//
//  UserProfileEntity+CoreDataProperties.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 8.10.22.
//
//

import Foundation
import CoreData


extension UserProfileEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfileEntity> {
        return NSFetchRequest<UserProfileEntity>(entityName: "UserProfileEntity")
    }

    @NSManaged public var avatarUrl: String?
    @NSManaged public var bio: String?
    @NSManaged public var blog: String?
    @NSManaged public var company: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var email: String?
    @NSManaged public var eventsUrl: String?
    @NSManaged public var followers: Int32
    @NSManaged public var followersUrl: String?
    @NSManaged public var following: Int32
    @NSManaged public var followingUrl: String?
    @NSManaged public var gistsUrl: String?
    @NSManaged public var gravatarId: String?
    @NSManaged public var hireable: String?
    @NSManaged public var htmlUrl: String?
    @NSManaged public var id: Int64
    @NSManaged public var location: String?
    @NSManaged public var login: String?
    @NSManaged public var name: String?
    @NSManaged public var nodeId: String?
    @NSManaged public var organizationsUrl: String?
    @NSManaged public var publicGists: Int32
    @NSManaged public var publicRepos: Int32
    @NSManaged public var receivedEventsUrl: String?
    @NSManaged public var reposUrl: String?
    @NSManaged public var siteAdmin: Bool
    @NSManaged public var starredUrl: String?
    @NSManaged public var subscriptionsUrl: String?
    @NSManaged public var twitterUsername: String?
    @NSManaged public var type: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var url: String?
    @NSManaged public var note: NoteEntity?
    @NSManaged public var user: UserEntity?

}

extension UserProfileEntity : Identifiable {

}
