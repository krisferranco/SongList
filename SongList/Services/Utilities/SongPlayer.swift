//
//  SongPlayer.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/3/22.
//

import Foundation
import AVFoundation

class SongPlayer: AudioPlayerProtocol {
    
    private let fileName: String
    private var audioPlayer: AVAudioPlayer?
    
    init(_ fileName: String) {
        self.fileName = fileName
    }
    
    func play() {
        guard let documentsURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            return
        }
        do {
            let audioURL = documentsURL.appendingPathComponent(fileName)
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            if let player = audioPlayer {
                player.play()
            }
        } catch {
            print("Failed to play audio: \(error.localizedDescription) ")
        }
    }
    
    func pause() {
        guard let audioPlayer = audioPlayer else {
            return
        }
        audioPlayer.pause()
    }
}
