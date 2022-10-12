//
//  NSManagedObject+Extension.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 12.10.22.
//

import Foundation
import CoreData

public extension NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }

}
