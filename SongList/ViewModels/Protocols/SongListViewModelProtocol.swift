//
//  SongListViewModelProtocol.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/2/22.
//

import Foundation

protocol SongListViewModelProtocol {
    
    var delegate: SongListViewModelDelegate? { get set }
    var songViewModels: [SongViewModel] { get }
    func fetchSongs()
}
