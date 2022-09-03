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
    
    private var songPlayer: SongPlayer? = nil
    private var downloadTask: URLSessionDownloadTask? = nil
    private lazy var urlSession = URLSession(configuration: .default,
                                             delegate: self,
                                             delegateQueue: nil)
    
    init(song: Song) {
        self.song = song
        state = song.fileURL != nil ? .available : .initial
        super.init()
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
        songPlayer?.play()
    }

    func pauseAudio() {
        songPlayer?.pause()
    }
    
    private func saveFileURL(_ fileURL: URL) {
        song.fileURL = fileURL.absoluteString
        
        //Only initialized when audio file is downloaded
        songPlayer = SongPlayer(song)
        songPlayer?.delegate = self
    }
}

extension SongViewModel: SongPlayerDelegate {
    func didChangeState(_ state: SongState) {
        self.state = state
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
            self.saveFileURL(savedURL)
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
