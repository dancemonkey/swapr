//
//  PlayerHand.swift
//  Swapr
//
//  Created by Drew Lanning on 1/7/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class PlayerHand: UIView {

  @IBOutlet weak var tileStack: UIStackView!
  @IBOutlet var playerHand: [LetterButton]!
  
  weak var player: Player?
  
  func setupPlayerHand() {
    
    if player!.hand == nil {
      player?.getStartingHand()
    }

    for (index, letter) in player!.hand.characters.enumerated() {
      playerHand[index].setImage(UIImage(named: "\(String(letter).uppercased())"), for: .normal)
      playerHand[index].setidentity(to: String(letter))
    }
    
    Utils.delay(1.0) {
      for (index, letter) in self.playerHand.enumerated() {
        let delay = Double(index) * 0.25
        UIView.animate(withDuration: 0.5, delay: delay, options: [], animations: {
          letter.rotate()
          letter.glowOn(locked: false)
          letter.isHidden = false
        }, completion: nil)
      }
    }
  }
  
  func disableAndGlowOff() {
    for letter in playerHand {
      letter.isEnabled = false
      letter.glowOff()
    }
  }
  
  func enableAll() {
    for letter in playerHand {
      letter.isEnabled = true
    }
  }
  
  func glow(all: Bool, letterToHighlight: LetterButton?) {
    if all {
      for letter in playerHand {
        letter.glowOn(locked: false)
      }
    } else {
      for letter in playerHand {
        letter.glowOff()
        letterToHighlight?.glowOn(locked: false)
      }
    }
  }

}
