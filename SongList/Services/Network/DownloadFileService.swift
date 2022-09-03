//
//  DownloadFileService.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/3/22.
//

import Foundation

protocol DownloadFileServiceDelegate: AnyObject {
    func didReceiveProgress(_ progress: Float)
    func didFinishedDownload(_ fileName: String, savedURL: URL)
    func didReceiveError(_ error: APIError)
}

/**
 - Service that downloads file from server using the file URL String provided from initialization.
 - Saves the downloaded file to documents directory of FileManager.default
 - after calling 'startDownload', this will notify delegate for the progress of download and when it completed the download or encounter an error.
 */
class DownloadFileService: NSObject, DownloadFileServiceProtocol {
    
    private let fileUrlString: String
    private var downloadTask: URLSessionDownloadTask? = nil
    private lazy var urlSession = URLSession(configuration: .default,
                                             delegate: self,
                                             delegateQueue: nil)
    weak var delegate: DownloadFileServiceDelegate?
    
    init(_ fileUrlString: String) {
        self.fileUrlString = fileUrlString
        super.init()
    }
    
    ///Will start the download request base from the valid `fileUrlString` else will return an error if url is invalid
    func startDownload() {
        if let url = URL(string: fileUrlString) {
            delegate?.didReceiveProgress(0.0)
            downloadTask = self.urlSession.downloadTask(with: url)
            downloadTask?.resume()
        } else {
            delegate?.didReceiveError(.invalidRequest)
        }
    }
}

extension DownloadFileService: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        ///Validate response status code
        guard
            let httpResponse = downloadTask.response as? HTTPURLResponse,
            httpResponse.isSuccessStatusCode
        else {
            delegate?.didReceiveError(.serverError(nil))
            return
        }
        
        do {
            ///Saving downloaded file to documents directory before notifying the delegate for completed download
            let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileName = location.lastPathComponent
            let savedURL = documentsURL.appendingPathComponent(location.lastPathComponent)
            try FileManager.default.moveItem(at: location, to: savedURL)
            
            delegate?.didFinishedDownload(fileName, savedURL: savedURL)
        } catch {
            delegate?.didReceiveError(.downloadError("File system error"))
        }
    }

    ///Delegate method that receives the progress of the download request and notifies the delegate to display progress on the screen
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if downloadTask == self.downloadTask {
            let calculatedProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            delegate?.didReceiveProgress(calculatedProgress)
        }
    }
}


///Convenience computed property extension for identifying valid http status code
fileprivate extension HTTPURLResponse {
    var isSuccessStatusCode: Bool {
        return statusCode >= 200 && statusCode <= 299
    }
}
