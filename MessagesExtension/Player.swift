//
//  Player.swift
//  Swapr
//
//  Created by Drew Lanning on 12/11/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Foundation

enum Helper: String {
  case Bomb, Lock, Swap
}

class Player {
  
  private var _score: Int
  var score: Int {
    return _score
  }
  
  private var _hand: String
  var hand: String {
    return _hand
  }
  
  private var _helpers: [Helper]
  var helpers: [Helper] {
    return _helpers
  }
  
  private var _chainScore: Int
  var chainScore: Int {
    return _chainScore
  }
  
  init(hand: String, score: Int, helpers: [Helper], chainScore: Int) {
    self._hand = hand
    self._score = score
    self._helpers = helpers
    self._chainScore = chainScore
  }
  
  func playFromHand(letter: String) -> Character {
    let index = _hand.characters.index(of: Character(letter))
    return _hand.remove(at: index!)
  }
  
  func playHelper(ofType helper: Helper) -> Helper? {
    guard self._helpers.contains(helper) else {
      return nil
    }
    let index = self._helpers.index(of: helper)
    return self._helpers.remove(at: index!)
  }
  
  func addToHand(letter: String) {
    self._hand.append(Character(letter))
  }
  
  func increaseScore(by score: Int) {
    self._score = self._score + score
    self._chainScore = self._chainScore + 1
  }
  
}
