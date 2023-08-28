//
//  MusicPlayer.swift
//  WakeUp
//
//  Created by Nik Y on 28.08.2023.
//

//import AVFoundation
//
//class MusicPlayer {
//    static let shared = MusicPlayer()
//    var audioPlayer: AVAudioPlayer?
//
//    func startBackgroundMusic() {
//        if audioPlayer?.isPlaying ?? false {
//                return
//            }
//
//        if let bundle = Bundle.main.path(forResource: "startBackgroundMusic", ofType: "mp3") {
//            let backgroundMusic = NSURL(fileURLWithPath: bundle)
//            do {
//                audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusic as URL)
//                guard let audioPlayer = audioPlayer else { return }
//                audioPlayer.numberOfLoops = -1 // Infinite loop
//                audioPlayer.prepareToPlay()
//                audioPlayer.play()
//            } catch {
//                print(error)
//            }
//        }
//    }
//
//    func stopBackgroundMusic() {
//        guard let audioPlayer = audioPlayer else { return }
//        audioPlayer.stop()
//    }
//}

//import SpriteKit
//
//class AudioManager {
//    static let shared = AudioManager()
//    var backgroundMusic: SKAudioNode?
//
//    private init() {
//        // Initialize your background music SKAudioNode here
//        if let backgroundMusic = SKAudioNode(fileNamed: "backgroundMusic.mp3") {
//            self.backgroundMusic = backgroundMusic
//            self.backgroundMusic?.autoplayLooped = true
//        }
//    }
//
//    func addBackgroundMusic(to scene: SKScene) {
//        // Remove the audio node from its current parent if needed
//        backgroundMusic?.removeFromParent()
//
//        // Add it to the new scene
//        if let backgroundMusic = backgroundMusic {
//            scene.addChild(backgroundMusic)
//        }
//    }
//}

//import AVFoundation
//
//public class SKTAudio {
//  public var backgroundMusicPlayer: AVAudioPlayer?
//  public var soundEffectPlayer: AVAudioPlayer?
//
//  public class func sharedInstance() -> SKTAudio {
//    return SKTAudioInstance
//  }
//
//  public func playBackgroundMusic(_ filename: String) {
//    let url = Bundle.main.url(forResource: filename, withExtension: nil)
//    if (url == nil) {
//      print("Could not find file: \(filename)")
//      return
//    }
//
//    var error: NSError? = nil
//    do {
//      backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url!)
//    } catch let error1 as NSError {
//      error = error1
//      backgroundMusicPlayer = nil
//    }
//    if let player = backgroundMusicPlayer {
//      player.numberOfLoops = -1
//      player.prepareToPlay()
//      player.play()
//    } else {
//      print("Could not create audio player: \(error!)")
//    }
//  }
//
//  public func pauseBackgroundMusic() {
//    if let player = backgroundMusicPlayer {
//      if player.isPlaying {
//        player.pause()
//      }
//    }
//  }
//
//  public func resumeBackgroundMusic() {
//    if let player = backgroundMusicPlayer {
//      if !player.isPlaying {
//        player.play()
//      }
//    }
//  }
//
//  public func playSoundEffect(_ filename: String) {
//    let url = Bundle.main.url(forResource: filename, withExtension: nil)
//    if (url == nil) {
//      print("Could not find file: \(filename)")
//      return
//    }
//
//    var error: NSError? = nil
//    do {
//      soundEffectPlayer = try AVAudioPlayer(contentsOf: url!)
//    } catch let error1 as NSError {
//      error = error1
//      soundEffectPlayer = nil
//    }
//    if let player = soundEffectPlayer {
//      player.numberOfLoops = 0
//      player.prepareToPlay()
//      player.play()
//    } else {
//      print("Could not create audio player: \(error!)")
//    }
//  }
//}
//
//private let SKTAudioInstance = SKTAudio()

import AVFoundation

class MusicPlayer {
    static let shared = MusicPlayer()
    var audioPlayer: AVAudioPlayer?
//
//    private init() {
//        setupAudioSession()
//    }
//
//    private func setupAudioSession() {
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.ambient)
//            try AVAudioSession.sharedInstance().setActive(true)
//            NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
//        } catch {
//            print("Error setting up audio session: \(error)")
//        }
//    }
//
//    @objc private func handleInterruption(_ notification: Notification) {
//        guard let userInfo = notification.userInfo,
//              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
//              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
//            return
//        }
//
//        if type == .began {
//            // Audio session was interrupted, for example, by an incoming call
//        } else if type == .ended {
//            // Interruption ended, resume playback if needed
//            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
//                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
//                if options.contains(.shouldResume) {
//                    audioPlayer?.play()
//                }
//            }
//        }
//    }

    func startBackgroundMusic() {
        // Check if music is already playing
        if audioPlayer?.isPlaying ?? false {
            return
        }

        if let bundle = Bundle.main.path(forResource: "startBackgroundMusic", ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1 // Infinite loop
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }

    func stopBackgroundMusic() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
    }
}
