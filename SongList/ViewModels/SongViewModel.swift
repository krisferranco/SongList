//
//  SongViewModel.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/2/22.
//

import Foundation
import AVFoundation

protocol SongViewModelDelegate: AnyObject {
    func updatedState(_ state: SongState)
}

class SongViewModel: NSObject, SongViewModelProtocol {
    
    var song: Song
    var state: SongState = .initial {
        didSet {
            self.delegate?.updatedState(state)
        }
    }
    private var downloadTask: URLSessionDownloadTask? = nil
    private var audioPlayer: AVAudioPlayer?

    weak var delegate: SongViewModelDelegate?
    
    private lazy var urlSession = URLSession(configuration: .default,
                                             delegate: self,
                                             delegateQueue: nil)
    
    var songName: String {
        return song.name
    }
    
    init(song: Song) {
        self.song = song
        
        super.init()
        
        if let url = URL(string: song.audioURL) {
            downloadTask = self.urlSession.downloadTask(with: url)
        }
    }
    
    func startDownload() {
        if let url = URL(string: song.audioURL) {
            state = .downloading(0.0)
            downloadTask = self.urlSession.downloadTask(with: url)
            downloadTask?.resume()
        } else {
            state = .failed(.invalidRequest)
        }
    }
    
    func playAudio() {
        guard let audioURL = song.fileURL else {
            return
        }
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            if let player = audioPlayer {
                state = .playing
                player.play()
            }
        } catch {
            state = .failed(.downloadError("AVAudioSession error"))
        }
    }
    
    func pauseAudio() {
        guard let audioPlayer = audioPlayer else {
            return
        }
        state = .available
        audioPlayer.pause()
    }
    
}

extension SongViewModel: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        //Validate response status code
        guard
            let httpResponse = downloadTask.response as? HTTPURLResponse,
            httpResponse.isSuccessStatusCode
        else {
            state = .failed(.serverError(nil))
            return
        }
        
        do {
            let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let savedURL = documentsURL.appendingPathComponent(location.lastPathComponent)
            //set fileURL or saved to CoreData
            self.song.fileURL = savedURL
            try FileManager.default.moveItem(at: location, to: savedURL)
            state = .available
        } catch {
            state = .failed(.downloadError("File system error"))
        }
    }

    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if downloadTask == self.downloadTask {
            let calculatedProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            state = .downloading(calculatedProgress)
        }
    }

    
}

//TODO: Move somewhere appropriate
extension HTTPURLResponse {
    var isSuccessStatusCode: Bool {
        return statusCode >= 200 && statusCode <= 299
    }
}
