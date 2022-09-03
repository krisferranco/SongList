//
//  Song.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/2/22.
//

import Foundation

struct Song: Codable {
    let id: String
    let name: String
    let audioURL: String
    var fileName: String?
}
