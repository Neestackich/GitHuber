//
//  NSManagedObjectContext+Extension.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 7.10.22.
//

import CoreData

extension NSManagedObjectContext {

    /// Checks whether there are actually changes that will change the persistent store.
    /// The `hasChanges` method would return `true` for transient changes as well which can lead to false positives.
    var hasPersistanceChanges: Bool {
        return !insertedObjects.isEmpty || !deletedObjects.isEmpty || updatedObjects.contains(where: { $0.hasPersistentChangedValues })
    }

}
