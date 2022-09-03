//
//  SongPlayer.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/3/22.
//

import Foundation
import AVFoundation

protocol SongPlayerDelegate: AnyObject {
    func didChangeState(_ state: SongState)
}

class SongPlayer {
    
    var song: Song
    private var audioPlayer: AVAudioPlayer?
    
    weak var delegate: SongPlayerDelegate?
    
    init(_ song: Song) {
        self.song = song
    }
    
    func play() {
        guard
            let fileName = song.fileName,
            let documentsURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        else {
            return
        }
        do {
            let audioURL = documentsURL.appendingPathComponent(fileName)
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            if let player = audioPlayer {
                self.delegate?.didChangeState(.playing)
                player.play()
            }
        } catch {
            self.delegate?.didChangeState(.failed(.downloadError("AVAudioSession error")))
        }
    }
    
    func pause() {
        guard let audioPlayer = audioPlayer else {
            return
        }
        self.delegate?.didChangeState(.available)
        audioPlayer.pause()
    }
}
