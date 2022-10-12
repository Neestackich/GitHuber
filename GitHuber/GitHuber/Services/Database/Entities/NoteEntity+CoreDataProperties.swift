//
//  NoteEntity+CoreDataProperties.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 12.10.22.
//
//

import Foundation
import CoreData


extension NoteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }

    @NSManaged public var text: String?
    @NSManaged public var user: UserEntity?

}

extension NoteEntity : Identifiable {

}
