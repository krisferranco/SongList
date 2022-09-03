//
//  CoreDataManager.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/3/22.
//

import Foundation
import CoreData

/**
 Manages the persistent store that is derived from Datamodel
 Handles the saving, updating, and fetching managedObject model from persistent store
 */
class CoreDataManager: CoreDataManagerProtocol {
    
    private let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "SongList")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    ///Saving any changes to managedObjectContext
    func save() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save song")
        }
    }
    
    func getModelById<T: NSManagedObject>(_ id: String, type: T.Type) -> T? {
        let predicate = NSPredicate(format: "id == %@", id)
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
        fetchRequest.predicate = predicate
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest).first
        } catch {
            return nil
        }
    }
    
    func getAll<T: NSManagedObject>(_ type: T.Type) -> [T] {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
}
