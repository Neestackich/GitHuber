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

    private let modelName: String

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
    
    lazy private var writeManageObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator

        return managedObjectContext
    }()

    lazy private var readManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = writeManageObjectContext
        managedObjectContext.automaticallyMergesChangesFromParent = true

        return managedObjectContext
    }()

    init(modelName: String) {
        self.modelName = modelName
    }

}

extension TestCoreDataStack {

    func getReadManagedObjectContext() -> NSManagedObjectContext {
        return readManagedObjectContext
    }

    func getWriteManagedObjectContext() -> NSManagedObjectContext {
        return writeManageObjectContext
    }

}
