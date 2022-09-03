//
//  DownloadFileServiceProtocol.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/3/22.
//

import Foundation

protocol DownloadFileServiceProtocol {
    
    ///Set this value to be notified for the download progress and when download is finished or encountered an error
    var delegate: DownloadFileServiceDelegate? { get set }
    
    ///Will start download request base from the audio URL of Song model
    func startDownload()
}
