//
//  CoreDataStack.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 6.10.22.
//

import Foundation
import CoreData

final class CoreDataStack {

    // MARK: Properties

    private let modelName: String

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private lazy var writeManageObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return managedObjectContext
    }()

     private lazy var readManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = writeManageObjectContext
        return managedObjectContext
    }()

    // MARK: Initialization

    init(modelName: String) {
        self.modelName = modelName
    }

}

// MARK: - Public

extension CoreDataStack {

    func getWriteContext() -> NSManagedObjectContext {
        return writeManageObjectContext
    }

    func getReadContext() -> NSManagedObjectContext {
        return readManagedObjectContext
    }

    func saveContextsIfNeeded() {
        guard readManagedObjectContext.hasPersistanceChanges || writeManageObjectContext.hasPersistanceChanges else {
            return
        }

        readManagedObjectContext.performAndWait() {
            do {
                try self.readManagedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }

        writeManageObjectContext.perform() {
            do {
                try self.writeManageObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
