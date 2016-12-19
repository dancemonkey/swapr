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
  
  private var _hand: String!
  var hand: String! {
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
  
  private var _playedTurn: Bool = false
  var didPlayTurn: Bool {
    return _playedTurn
  }
  
  init(hand: String?, score: Int, helpers: String?, chainScore: Int) {
    self._hand = hand
    self._score = score
    if helpers != nil {
      self._helpers = Player.parseHelper(text: helpers!)
    } else {
      self._helpers = Player.parseHelper(text: "bsl")
    }
    self._chainScore = chainScore
    if _hand == nil {
      _hand = getStartingHand()
    }
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
  
  func getHelperTextString() -> String {
    var helperString = ""
    if helpers.contains(.bomb) {
      helperString = helperString + "b"
    }
    if helpers.contains(.lock) {
      helperString = helperString + "l"
    }
    if helpers.contains(.swap) {
      helperString = helperString + "s"
    }
    return helperString
  }
  
  func getStartingHand() -> String {
    let HAND_SIZE = 5
    var hand = ""
    let wordList = WordsAPI()
    for _ in 0..<HAND_SIZE {
      hand = hand + wordList.fetchRandomLetter()
    }
    print("returned starting hand from player function")
    return hand
  }
  
  func playFromHand(letter: String) {
    if let range = _hand.range(of: letter) {
      print("removing letter \(letter) from hand")
      _hand.remove(at: range.lowerBound)
      self._playedTurn = true
    }
  }
  
  func playHelper(ofType helper: Helper) {
    let index = self._helpers.index(of: helper)
    self._helpers.remove(at: index!)
    self._playedTurn = true
  }
  
  func drawNewLetter(fromList list: WordsAPI) {
    self._hand.append(list.fetchRandomLetter())
    self._playedTurn = true
  }
  
  func increaseScore() {
    self._score = self._score + self._chainScore
    incrementChainScore()
  }
  
  func resetChainToZero() {
    self._chainScore = 0
  }
  
  func incrementChainScore() {
    self._chainScore = self._chainScore + 1
  }
  
}
