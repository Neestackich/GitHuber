//
//  UserEntity+CoreDataProperties.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 9.10.22.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var avatarUrl: String?
    @NSManaged public var eventsUrl: String?
    @NSManaged public var followersUrl: String?
    @NSManaged public var followingUrl: String?
    @NSManaged public var gistsUrl: String?
    @NSManaged public var gravatarId: String?
    @NSManaged public var htmlUrl: String?
    @NSManaged public var id: Int64
    @NSManaged public var isSeen: Bool
    @NSManaged public var login: String?
    @NSManaged public var nodeId: String?
    @NSManaged public var organizationsUrl: String?
    @NSManaged public var receivedEventsUrl: String?
    @NSManaged public var reposUrl: String?
    @NSManaged public var siteAdmin: Bool
    @NSManaged public var starredUrl: String?
    @NSManaged public var subscriptionsUrl: String?
    @NSManaged public var type: String?
    @NSManaged public var url: String?
    @NSManaged public var hasNote: Bool
    @NSManaged public var note: NoteEntity?
    @NSManaged public var profile: UserProfileEntity?

}

extension UserEntity : Identifiable {

}
