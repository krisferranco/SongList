//
//  CoreDataManagerProtocol.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/3/22.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    var viewContext: NSManagedObjectContext { get }
    
    func save()
    func getModelById<T: NSManagedObject>(_ id: String, type: T.Type) -> T?
    func getAll<T: NSManagedObject>(_ type: T.Type) -> [T]
}
