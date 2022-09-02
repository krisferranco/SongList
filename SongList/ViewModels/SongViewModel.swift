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

//TODO: Create Protocol
class SongViewModel: NSObject {
    
    var song: Song
    var state: SongState = .initial {
        didSet {
            self.delegate?.updatedState(state)
        }
    }
    var downloadTask: URLSessionDownloadTask? = nil

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
