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
    
    var songViewModels: [SongViewModel] = []
    weak var delegate: SongListViewModelDelegate?
    
    
    func fetchSongs() {
        apiSession.getSongs { [weak self] songs, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.delegate?.receivedError(error)
                } else {
                    self.songViewModels = songs.map { SongViewModel(song: $0) }
                    self.delegate?.songsUpdated()
                }
            }
        }
    }
}
