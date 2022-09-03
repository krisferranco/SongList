//
//  DependencyManager.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/3/22.
//

import Foundation

///Handles the single instance of API and CoreData services
///Responsible for generating downloadFile and audioPlayer services as needed
///Expose service protocols only, to abstract the concrete implementation, also to be easily mock for testing
class DependencyManager: DependencyManagerProtocol {
    
    let apiSession: APISessionProtocol
    let coreDataManager: CoreDataManagerProtocol
    
    init() {
        apiSession = APISession()
        coreDataManager = CoreDataManager()
    }
    
    func generateDownloadFileService(_ fileURL: String) -> DownloadFileServiceProtocol {
        return DownloadFileService(fileURL)
    }
    
    func generateAudioPlayerService(_ fileName: String) -> AudioPlayerProtocol {
        return SongPlayer(fileName)
    }
}
