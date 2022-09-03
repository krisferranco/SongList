//
//  SongModel+Extension.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/3/22.
//

import Foundation

extension SongModel {
    
    var song: Song? {
        guard
            let id = id,
            let name = name,
            let audioURL = audioURLString
        else {
            return nil
        }
        return Song(id: id, name: name, audioURL: audioURL, fileURL: fileURLString)
    }
    
    func updateValues(_ song: Song) {
        id = song.id
        name = song.name
        audioURLString = song.audioURL
        fileURLString = song.fileURL
    }
}
