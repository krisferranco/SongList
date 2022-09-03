//
//  AudioPlayerProtocol.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/3/22.
//

import Foundation

/**
 Service that handles the playing and pausing the audio file
 The audio file should be located in FileManager.default documents directory with a file name matching the provided `fileName`
 */
protocol AudioPlayerProtocol {
    /// Play the audio file located in FileManager.default documents directory with a file name matching the provided `fileName`
    func play()
    
    /// Pause the currently playing audioPlayer
    func pause()
}
