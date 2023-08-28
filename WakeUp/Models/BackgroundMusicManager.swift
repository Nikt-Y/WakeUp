//
//  BackgroundMusicManager.swift
//  WakeUp
//
//  Created by Nik Y on 28.08.2023.
//

import SpriteKit
import AVFoundation

class BackgroundMusicManager: NSObject, AVAudioPlayerDelegate {
    
    static let shared = BackgroundMusicManager()
    
    private var audioPlayer: AVAudioPlayer?
    private var currentMusicFiles: [String] = []
    private var currentIndex: Int = 0
    private var shouldRepeatForever: Bool = false
    private var currentMusicName: String = ""
    
    func setupBackgroundMusic(forScene scene: SKScene, withFiles musicFiles: [String], repeatForever: Bool = false, playRandomly: Bool = false) {
        scene.removeAllActions()
        currentMusicFiles = playRandomly ? musicFiles.shuffled() : musicFiles
        currentIndex = 0
        shouldRepeatForever = repeatForever
        playNext()
    }
    
    private func playNext() {
        guard !currentMusicFiles.isEmpty else { return }
        
        let nextFile = currentMusicFiles[currentIndex]
        if audioPlayer?.isPlaying ?? false, currentMusicName == nextFile {
            return
        }
        currentMusicName = nextFile
        if let soundURL = Bundle.main.url(forResource: nextFile, withExtension: "mp3") {
            do {
                audioPlayer?.stop()
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.delegate = self
                audioPlayer?.play()
            } catch {
                print("Failed to initialize AVAudioPlayer: \(error)")
            }
        }
        
        currentIndex += 1
        
        if currentIndex >= currentMusicFiles.count {
            if shouldRepeatForever {
                currentIndex = 0
            } else {
                currentMusicFiles = []
            }
        }
    }
    
    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playNext()
    }
    
    func stop() {
        audioPlayer?.stop()
    }
}
