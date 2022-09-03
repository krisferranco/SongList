//
//  CoreDataManagerProtocol.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/3/22.
//

import Foundation

protocol CoreDataManagerProtocol {
    func save()
    func writeSong(_ song: Song)
    func getSongById(_ id: String) -> SongModel?
    func getAllSongs() -> [SongModel]
}
