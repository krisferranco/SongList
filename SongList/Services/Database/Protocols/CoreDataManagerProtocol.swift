//
//  CoreDataManagerProtocol.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/3/22.
//

import Foundation
import CoreData

/**
 Protocol for Persistent store management, communicated by the viewModel as its dependency
*/
protocol CoreDataManagerProtocol {
    var viewContext: NSManagedObjectContext { get }
    
    /// Saving any changes to managed object context
    func save()
    
    /// Get by id the specific ManagedObject defined by `type` parameter
    /// Make sure that the model has exact attribute name of `id`
    /// Will return a managedObject that matches the id else return nil
    func getModelById<T: NSManagedObject>(_ id: String, type: T.Type) -> T?
    
    /// Will fetch all saved ManagedObject with specific type defined by `type` parameter
    func getAll<T: NSManagedObject>(_ type: T.Type) -> [T]
}
