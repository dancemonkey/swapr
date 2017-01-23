//
//  Sound.swift
//  Swapr
//
//  Created by Drew Lanning on 1/2/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import AVFoundation

enum SoundFile: String {
  case explosion, lock, strike, select, swap, validWord
}

class Sound {
  
  static let shared = Sound()
  
  var player: AVAudioPlayer!
  
  func playSound(for type: SoundFile) {
    let random = arc4random_uniform(6)
    let sound = random != 0 ? random : 1
    DispatchQueue.global(qos: .background).async {
      do {
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryPlayback, with: .duckOthers)
        if let path = Bundle.main.path(forResource: type.rawValue + "\(sound).wav", ofType: nil) {
          let url = URL(fileURLWithPath: path)
          self.player = try AVAudioPlayer(contentsOf: url)
          self.player.prepareToPlay()
          self.player.play()
        }
      } catch {
        print("error \(error)")
      }
    }
  }
  
}
