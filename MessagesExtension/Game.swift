//
//  Game.swift
//  Swapr
//
//  Created by Drew Lanning on 12/8/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Foundation
import Messages

enum PlayerTurn: Int {
  case playerOne = 0
  case playerTwo = 1
  case playerThree = 2
  case playerFour = 3
}

class Game {
  
  private var _priorPlayerPassed: Bool
  var priorPlayerPassed: Bool {
    return _priorPlayerPassed
  }
  
  private var _currentPlayerPassed: Bool = false
  
  private var _players: [Player]
  var players: [Player] {
    return _players
  }
  
  private var _currentPlayer: Player
  var currentPlayer: Player {
    return _currentPlayer
  }
  
  let MAX_WORD_LENGTH = 6
  
  private var _currentWord: Word
  var currentWord: Word {
    return _currentWord
  }
  
  private var _wordSize: Int {
    return _currentWord.size
  }
  
  let wordList = WordsAPI()
  
  init(withMessage message: MSMessage?) {
    if let msg = message, let url = msg.url {
      if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false) {
        if let queryItems = components.queryItems {
          for item in queryItems {
            if item.name == "currentWord" {
              self._currentWord = Word(word: item.name)
            }
            if item.name == "oppPlayerIndex" {
              
            }
            if item.name == "currentPlayerIndex" {
              
            }
            if item.name == "oppPlayerHand" {
              
            }
            if item.name == "currentPlayerHand" {
              
            }
            if item.name == "oppPlayerScore" {
              
            }
            if item.name == "currentPlayerScore" {
              
            }
            if item.name == "oppPlayerHelpers" {
              
            }
            if item.name == "currentPlayerHelpers" {
              
            }
            if item.name == "priorPlayerPassed" {
              
            }
            if item.name == "oppChainScore" {
              
            }
            if item.name == "currentChainScore" {
              
            }
          }
        }
      }
    } else {
      // init game with new values, it's a brand new game
    }
  }
  
  func setupRound(forPlayer player: Player) {
    // move most of the garbage from init function into here
  }
  
  func getNewWord() -> Word {
    return wordList.fetchRandomWord()!
  }
  
  func getNewLetter(forPlayer player: Player) {
    player.addToHand(letter: wordList.fetchRandomLetter())
  }
  
  func isValid(word: String) -> Bool {
    return wordList.validate(word: word)
  }
  
  func gameIsOver() -> Bool {
    return _currentPlayerPassed == true && _priorPlayerPassed == true
  }
  
  func winningPlayer() -> Player? {
    var winningScore = 0
    var winningPlayer: Player? = nil
    _players.forEach { (player) in
      if player.score > winningScore {
        winningScore = player.score
        winningPlayer = player
      }
    }
    return winningPlayer
  }
  
  private func scoreRound(forPlayer player: Player) {
    player.increaseScore(by: player.chainScore)
  }
  
  func endRound(forPlayer player: Player) -> MSMessage {
    scoreRound(forPlayer: player)
    // parse all game data into MSMessage URL shits
    // be sure to encode currentPlayer as nextPlayer in url
    
    return MSMessage()
  }
  
}
