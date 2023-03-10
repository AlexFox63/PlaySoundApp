//
//  PlayerController.swift
//  Runner
//
//  Created by Aleksandr Fokin on 3/9/23.
//

import AVFoundation

var player: AVAudioPlayer?

func playSoundFromUrl(url: String) {
    do {
        if (player != nil) {
            player?.play()
        } else {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let soundUrl = URL(string: url)
            
            player = try AVAudioPlayer(contentsOf: soundUrl!)
            
            guard let player = player else { return }
            
            player.play()
        }
        
    } catch let error {
        print(error.localizedDescription)
    }
}

func pauseSound() {
    do {
        player?.pause()
    } catch let error {
        print(error.localizedDescription)
    }
}

func stopSound() {
    do {
        player?.stop()
        player = nil
    } catch let error {
        print(error.localizedDescription)
    }
}

func setVolume(volume: Float) {
    do {
        player?.setVolume(volume, fadeDuration: 0)
    } catch let error {
        print(error.localizedDescription)
    }
}

