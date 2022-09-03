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
        return Song(id: id, name: name, audioURL: audioURL, fileName: fileName)
    }
    
    func updateValues(_ song: Song) {
        id = song.id
        name = song.name
        
        ///Condition if the audioURL from api changes
        ///Update value of saved fileURL if any
        ///This is to prevent downloading the same file multiple times
        if audioURLString != song.audioURL {
            audioURLString = song.audioURL
            fileName = song.fileName
        }
    }
}
