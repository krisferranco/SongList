//
//  Song.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/2/22.
//

import Foundation

//TODO: Create ManagedObject counterpart for Persistence
struct Song: Codable {
    let id: String
    let name: String
    let audioURL: String
    
    //set as optional not to break the response mapping
    //nil initially, and will have value when download is completed
    var fileURL: URL?
}
