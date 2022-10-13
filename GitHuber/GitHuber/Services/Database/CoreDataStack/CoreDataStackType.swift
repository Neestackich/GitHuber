//
//  CoreDataStackType.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 12.10.22.
//

import Foundation
import CoreData

protocol CoreDataStackType {

    // MARK: Contexts Management
    func getManagedObjectContext() -> NSManagedObjectContext
    func saveContextsIfNeeded()

}
