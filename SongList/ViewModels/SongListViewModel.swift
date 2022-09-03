//
//  SongListViewModel.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/2/22.
//

import Foundation

protocol SongListViewModelDelegate: AnyObject {
    func songsUpdated()
    func receivedError(_ error: APIError)
}

class SongListViewModel: SongListViewModelProtocol {
    
    private let apiSession = APISession.shared
    private let coreDataManager = CoreDataManager.shared
    
    var songViewModels: [SongViewModel] = []
    weak var delegate: SongListViewModelDelegate?
    
    init() {
        refreshSongs()
    }
    
    func fetchSongs() {
        apiSession.getSongs { [weak self] songs, error in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.receivedError(error)
            } else {
                self.saveSongs(songs)
            }
        }
    }
    
    private func refreshSongs() {
        self.songViewModels = []
        let songModels = coreDataManager.getAllSongs()
        let songs = songModels.map { $0.song }
        
        songs.forEach { [weak self] song in
            guard
                let self = self,
                let song = song
            else {
                return
            }
            self.songViewModels.append(SongViewModel(song: song))
        }
    }
    
    private func saveSongs(_ songs: [Song]) {
        songs.forEach { [weak self] song in
            guard let self = self else { return }
            self.coreDataManager.writeSong(song)
        }
        
        refreshSongs()
        delegate?.songsUpdated()
    }
}
