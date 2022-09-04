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
    
    weak var delegate: SongViewModelDelegate?
    private let dependencyManager: DependencyManagerProtocol
    private var song: Song
    private let stateQueue = DispatchQueue.global(qos: .default)
    
    var state: SongState {
        didSet {
            self.delegate?.updatedState(state)
        }
    }
    
    var songName: String {
        return song.name
    }
    
    private lazy var songPlayer: AudioPlayerProtocol = {
        ///Initialize only SongPlayer if audio file is already downloaded
        var songPlayer = dependencyManager.generateAudioPlayerService(song.fileName ?? "")
        songPlayer.delegate = self
        return songPlayer
    }()
    
    private lazy var downloadService: DownloadFileServiceProtocol = {
        ///Initialize service only as needed
        var downloadService = dependencyManager.generateDownloadFileService(song.audioURL)
        downloadService.delegate = self
        return downloadService
    }()
    
    init(song: Song, dependencyManager: DependencyManagerProtocol) {
        self.song = song
        self.dependencyManager = dependencyManager
        state = song.fileName != nil ? .available : .initial
        super.init()
    }
    
    ///Will start download request base from the audio URL of Song model
    func startDownload() {
        downloadService.startDownload()
    }
    
    
    func playAudio() {
        songPlayer.play()
        updateState(.playing)
    }

    func pauseAudio() {
        songPlayer.pause()
        updateState(.available)
    }
    
    private func updateState(_ newState: SongState) {
        stateQueue.sync { [weak self] in
            guard let self = self else { return }
            self.state = newState
        }
    }
}

//MARK: DownloadFileServiceDelegate methods
extension SongViewModel: DownloadFileServiceDelegate {
    func didReceiveProgress(_ progress: Float) {
        updateState(.downloading(progress))
    }
    
    func didFinishedDownload(_ fileName: String, savedURL: URL) {
        song.fileName = fileName
        if let songModel = dependencyManager.coreDataManager.getModelById(song.id, type: SongModel.self) {
            songModel.fileName = fileName
            dependencyManager.coreDataManager.save()
        }
        updateState(.available)
    }
    
    func didReceiveError(_ error: APIError) {
        updateState(.failed(error))
    }
}

//MARK: SongPlayerDelegate methods
extension SongViewModel: SongPlayerDelegate {
    func didFinishPlaying(_ player: AudioPlayerProtocol) {
        updateState(.available)
    }
}

