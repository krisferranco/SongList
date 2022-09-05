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
    
    @Inject private var dependencyManager: DependencyManagerProtocol
    
    weak var delegate: SongListViewModelDelegate?
    
    var songViewModels: [SongViewModel] = []
    let refreshSongQueue = DispatchQueue.global(qos: .default)
    
    init() {
        refreshSongQueue.sync { [weak self] in
            self?.refreshSongs()
        }
    }
    
    func fetchSongs() {
        dependencyManager.apiSession.request(.songList, type: SongListResponse.self) { [weak self] response, error in
            guard
                let self = self,
                let songListResponse = response as? SongListResponse
            else { return }
            
            if let error = error {
                self.delegate?.receivedError(error)
            } else {
                self.saveSongs(songListResponse.data)
            }
        }
    }
    
    private func refreshSongs() {
        self.songViewModels = []
        let songModels = dependencyManager.coreDataManager.getAll(SongModel.self)
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
            SongModel.writeModel(song, coreDataManager: self.dependencyManager.coreDataManager)
        }
        
        refreshSongQueue.sync { [weak self] in
            self?.refreshSongs()
            self?.delegate?.songsUpdated()
        }
    }
}
