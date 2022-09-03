//
//  DependencyManagerProtocol.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/4/22.
//

import Foundation

protocol DependencyManagerProtocol {
    var apiSession: APISessionProtocol { get }
    var coreDataManager: CoreDataManagerProtocol { get }
    
    func generateDownloadFileService(_ fileURL: String) -> DownloadFileServiceProtocol
    func generateAudioPlayerService(_ fileName: String) -> AudioPlayerProtocol
}
