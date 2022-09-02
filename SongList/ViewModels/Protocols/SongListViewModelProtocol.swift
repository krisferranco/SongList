//
//  SongListViewModelProtocol.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/2/22.
//

import Foundation

protocol SongListViewModelProtocol {
    
    var songs: [Song] { get }
    func fetchSongs()
}
