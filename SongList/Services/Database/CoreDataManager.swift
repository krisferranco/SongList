//
//  CoreDataManager.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/3/22.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "SongList")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    func save() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save song")
        }
    }
    
    func writeSong(_ song: Song) {
        if let savedSong = getSongById(song.id) {
            savedSong.updateValues(song)
        } else {
            let songModel = SongModel(context: persistentContainer.viewContext)
            songModel.updateValues(song)
        }
        save()
    }
    
    func getSongById(_ id: String) -> SongModel? {
        let predicate = NSPredicate(format: "id == %@", id)
        let fetchRequest: NSFetchRequest<SongModel> = SongModel.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest).first
        } catch {
            return nil
        }
    }
    
    func getAllSongs() -> [SongModel] {
        let fetchRequest: NSFetchRequest<SongModel> = SongModel.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
}
