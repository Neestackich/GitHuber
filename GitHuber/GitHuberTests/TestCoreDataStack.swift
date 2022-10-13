//
//  TestCoreDataStack.swift
//  GitHuberTests
//
//  Created by Vittcal Neestackich on 9.10.22.
//

import XCTest
@testable import GitHuber
import CoreData

final class TestCoreDataStack: NSObject, CoreDataStackType {

    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: "GitHuber")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

}

extension TestCoreDataStack {

    func getManagedObjectContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }

    func saveContextsIfNeeded() {
        // persistentContainer.viewContext.save()
    }

}
