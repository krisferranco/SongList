//
//  SongState.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/2/22.
//

import Foundation

/// State of the `Song` model
enum SongState {
    /// download not initialized
    case initial
    /// ongoing download process
    case downloading(Float)
    /// completed download, available for playing
    case available
    /// currently playing
    case playing
    /// error encounter
    case failed(APIError)
    
    /// name of the image from resources that corresponds the `state`
    var buttonImageName: String {
        switch self {
        case .initial: return "download-icon"
        case .available: return "play-icon"
        case .playing: return "pause-icon"
        default: return ""
        }
    }
}
