//
//  CoreDataStack.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 12.10.22.
//

import Foundation
import CoreData

final class CoreDataStack: CoreDataStackType {

    // MARK: - Properties

    private let containerName: String

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private lazy var writeManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator

        return managedObjectContext
    }()

    private lazy var readManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = writeManagedObjectContext
        managedObjectContext.automaticallyMergesChangesFromParent = true

        return managedObjectContext
    }()

    // MARK: - Initialization

    init(containerName:  String) {
        self.containerName = containerName
    }

}

// MARK: - Public

extension CoreDataStack {

    // MARK: Contexts Management

    func getReadManagedObjectContext() -> NSManagedObjectContext {
        return readManagedObjectContext
    }

    func getWriteManagedObjectContext() -> NSManagedObjectContext {
        return writeManagedObjectContext
    }

}
