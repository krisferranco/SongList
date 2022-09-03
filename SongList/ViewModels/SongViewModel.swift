//
//  SongViewModel.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/2/22.
//

import Foundation

protocol SongViewModelDelegate: AnyObject {
    func updatedState(_ state: SongState)
}

class SongViewModel: NSObject, SongViewModelProtocol {
    
    private var song: Song
    
    var state: SongState {
        didSet {
            self.delegate?.updatedState(state)
        }
    }
    
    var songName: String {
        return song.name
    }
    
    weak var delegate: SongViewModelDelegate?
    
    private lazy var songPlayer: SongPlayer = {
        ///Initialize only SongPlayer if audio file is already downloaded
        let songPlayer = SongPlayer(song)
        songPlayer.delegate = self
        return songPlayer
    }()
    
    private lazy var downloadService: DownloadFileService = {
        let downloadService = DownloadFileService(song.audioURL)
        downloadService.delegate = self
        return downloadService
    }()
    
    private let coreDataManager = CoreDataManager.shared
    
    init(song: Song) {
        self.song = song
        state = song.fileName != nil ? .available : .initial
        super.init()
    }
    
    func startDownload() {
        downloadService.startDownload()
    }
    
    func playAudio() {
        songPlayer.play()
    }

    func pauseAudio() {
        songPlayer.pause()
    }
}

extension SongViewModel: SongPlayerDelegate {
    func didChangeState(_ state: SongState) {
        self.state = state
    }
}

extension SongViewModel: DownloadFileServiceDelegate {
    func didReceiveProgress(_ progress: Float) {
        state = .downloading(progress)
    }
    
    func didFinishedDownload(_ fileName: String, savedURL: URL) {
        song.fileName = fileName
        if let songModel = coreDataManager.getSongById(song.id) {
            songModel.fileName = fileName
            coreDataManager.save()
        }
        state = .available
    }
    
    func didReceiveError(_ error: APIError) {
        state = .failed(error)
    }
}

