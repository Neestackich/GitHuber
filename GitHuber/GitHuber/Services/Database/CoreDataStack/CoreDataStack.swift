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

    private lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = writeManagedObjectContext

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

    func getManagedObjectContext() -> NSManagedObjectContext {
        return managedObjectContext
    }

    func saveContextsIfNeeded() {
        guard managedObjectContext.hasPersistanceChanges || writeManagedObjectContext.hasPersistanceChanges else {
            return
        }

        managedObjectContext.performAndWait() {
            do {
                try self.managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }

        writeManagedObjectContext.perform() {
            do {
                try self.writeManagedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
