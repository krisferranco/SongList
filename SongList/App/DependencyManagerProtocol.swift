//
//  DependencyManagerProtocol.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/4/22.
//

import Foundation

/// Manages the dependencies used by the app
protocol DependencyManagerProtocol {
    /// Dependency for making any API requests
    var apiSession: APISessionProtocol { get }
    
    /// Dependency for making managing the persistent store
    var coreDataManager: CoreDataManagerProtocol { get }
    
    /// Generate a new instance of `DownloadFileService` that handles the downloading file request
    func generateDownloadFileService(_ fileURL: String) -> DownloadFileServiceProtocol
    
    /// Generate a new instance of `SongPlayer` that handles the playing and pausing of an audio file
    func generateAudioPlayerService(_ fileName: String) -> AudioPlayerProtocol
}
