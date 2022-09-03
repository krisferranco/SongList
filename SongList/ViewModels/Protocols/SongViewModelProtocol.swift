//
//  SongViewModelProtocol.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/2/22.
//

import Foundation

protocol SongViewModelProtocol {
    var state: SongState { get }
    var songName: String { get }
    
    func startDownload()
    func playAudio()
    func pauseAudio()
}
