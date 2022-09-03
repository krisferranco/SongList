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
        return dependencyManager.generateAudioPlayerService(song.fileName ?? "")
    }()
    
    private lazy var downloadService: DownloadFileServiceProtocol = {
        ///Initialize service only as needed
        let downloadService = DownloadFileService(song.audioURL)
        downloadService.delegate = self
        return downloadService
    }()
    
    init(song: Song, dependencyManager: DependencyManagerProtocol) {
        self.song = song
        self.dependencyManager = dependencyManager
        state = song.fileName != nil ? .available : .initial
        super.init()
    }
    
    func startDownload() {
        downloadService.startDownload()
    }
    
    func playAudio() {
        songPlayer.play()
        state = .playing
    }

    func pauseAudio() {
        songPlayer.pause()
        state = .available
    }
}

//MARK: DownloadFileServiceDelegate methods
extension SongViewModel: DownloadFileServiceDelegate {
    func didReceiveProgress(_ progress: Float) {
        state = .downloading(progress)
    }
    
    func didFinishedDownload(_ fileName: String, savedURL: URL) {
        song.fileName = fileName
        if let songModel = dependencyManager.coreDataManager.getModelById(song.id, type: SongModel.self) {
            songModel.fileName = fileName
            dependencyManager.coreDataManager.save()
        }
        state = .available
    }
    
    func didReceiveError(_ error: APIError) {
        state = .failed(error)
    }
}

