//
//  Player.swift
//  Swapr
//
//  Created by Drew Lanning on 12/11/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Foundation

enum Helper: String {
  case bomb, lock, swap
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
  
  init(hand: String?, score: Int, helpers: String?, chainScore: Int) {
    self._hand = hand ?? Player.getStartingHand()
    self._score = score
    if helpers != nil {
      self._helpers = Player.parseHelper(text: helpers!)
    } else {
      self._helpers = Player.parseHelper(text: "bsl")
    }
    self._chainScore = chainScore
  }
  
  static func parseHelper(text: String) -> [Helper] {
    var helpers = [Helper]()
    for letter in text.characters {
      switch letter {
      case "b":
        helpers.append(.bomb)
      case "l":
        helpers.append(.lock)
      case "s":
        helpers.append(.swap)
      default:
        break
      }
    }
    return helpers
  }
  
  static func getStartingHand() -> String {
    let HAND_SIZE = 5
    var hand = ""
    let wordList = WordsAPI()
    for _ in 1...HAND_SIZE {
      hand = hand + wordList.fetchRandomLetter()
    }
    return hand
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
