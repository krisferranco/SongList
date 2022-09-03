//
//  DownloadFileServiceProtocol.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/3/22.
//

import Foundation

protocol DownloadFileServiceProtocol {
    var delegate: DownloadFileServiceDelegate? { get set }
    func startDownload()
}
