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

struct TempPlayer {
  var hand: String
  var score: Int
  var helpers: String
  var chainScore: Int
}

class Game {
  
  let MAX_WORD_LENGTH = 6
  let wordList = WordsAPI()
  
  private var _priorPlayerPassed: Bool = false
  var priorPlayerPassed: Bool {
    return _priorPlayerPassed
  }
  
  private var _currentPlayerPassed: Bool = false
  var currentPlayerPassed: Bool {
    return _currentPlayerPassed
  }
  
  private var _currentPlayer: Player
  var currentPlayer: Player {
    return _currentPlayer
  }
  
  private var _oppPlayer: Player
  var oppPlayer: Player {
    return _oppPlayer
  }
  
  private var _currentWord: Word? = nil
  var currentWord: Word? {
    return _currentWord
  }
  
  private var _wordSize: Int {
    return _currentWord != nil ? _currentWord!.size : 0
  }
  
  init(withMessage message: MSMessage?) {
    if let msg = message, let url = msg.url {
      print("-------PARSED MESSAGE--------")
      print(url.dataRepresentation)
      print(url.absoluteString)
      
      var oppPlayer = TempPlayer(hand: "", score: 0, helpers: "", chainScore: 0)
      var currentPlayer = TempPlayer(hand: "", score: 0, helpers: "", chainScore: 0)
      
      if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false) {
        if let queryItems = components.queryItems {
          print("got into query items")
          for item in queryItems {
            if item.name == "currentWord" {
              self._currentWord = Word(fromText: item.value!)
            }
            if item.name == "oppPlayerHand" {
              oppPlayer.hand = item.value!
            }
            if item.name == "currentPlayerHand" {
              currentPlayer.hand = item.value!
            }
            if item.name == "oppPlayerScore" {
              oppPlayer.score = Int(item.value!)!
            }
            if item.name == "currentPlayerScore" {
              currentPlayer.score = Int(item.value!)!
            }
            if item.name == "oppPlayerHelpers" {
              oppPlayer.helpers = item.value!
            }
            if item.name == "currentPlayerHelpers" {
              currentPlayer.helpers = item.value!
            }
            if item.name == "priorPlayerPassed" {
              self._priorPlayerPassed = NSString(string: item.value!).boolValue
            }
            if item.name == "oppChainScore" {
              oppPlayer.chainScore = Int(item.value!)!
            }
            if item.name == "currentChainScore" {
              currentPlayer.chainScore = Int(item.value!)!
            }
          }
          print("got out of query items")
        }
      }
      self._currentPlayer = Player(hand: currentPlayer.hand, score: currentPlayer.score, helpers: currentPlayer.helpers, chainScore: currentPlayer.chainScore)
      self._oppPlayer = Player(hand: oppPlayer.hand, score: oppPlayer.score, helpers: oppPlayer.helpers, chainScore: oppPlayer.chainScore)
      print("created both players from message")
    } else {
      _oppPlayer = Player(hand: nil, score: 0, helpers: nil, chainScore: 1)
      _currentPlayer = Player(hand: nil, score: 0, helpers: nil, chainScore: 1)
      print("created new players for new game")
    }
  }
  
  func setCurrentWord(to word: String) {
    self._currentWord = Word(fromText: word)
  }
  
  func getNewWord() -> Word {
    return wordList.fetchRandomWord()!
  }
  
  func getNewLetter(forPlayer player: Player) {
    player.drawNewLetter(fromList: wordList)
  }
  
  func isValid(word: String) -> Bool {
    return wordList.validate(word: word)
  }
  
  func gameIsOver() -> Bool {
    return _currentPlayerPassed == true && _priorPlayerPassed == true
  }
  
  func winningPlayer() -> Player? {
    return currentPlayer.score > oppPlayer.score ? currentPlayer : oppPlayer
  }
  
  private func scoreRound(forPlayer player: Player) {
    player.increaseScore()
  }
  
  func endRound() {
    scoreRound(forPlayer: _currentPlayer)
  }
  
  func replaceLetter(atIndex index: Int, withPlayerLetter letter: String) {
    _currentPlayer.playFromHand(letter: letter)
    _currentWord?.replaceLetter(at: index, with: letter)
    getNewLetter(forPlayer: _currentPlayer)
  }
  
  func playHelper(helper: Helper, forPlayer player: Player) {
    player.playHelper(ofType: helper)
  }
  
  func rewriteWord(as newWord: String) {
    _currentWord?.name = newWord
  }
  
  func swapLetters(first: String, at index: Int, with second: String, at secondIndex: Int) {
    _currentWord?.replaceLetter(at: index, with: second)
    _currentWord?.replaceLetter(at: secondIndex, with: first)
  }
  
  func addNewLetterSpace(to: AddLetter) {
    let oldWord = _currentWord
    if to == .left {
      _currentWord = Word(fromText: "_\(oldWord!.name)")
    } else {
      _currentWord = Word(fromText: "\(oldWord!.name)_")
    }
  }
  
  func playerPlayedTurn() -> Bool {
    return _currentPlayer.didPlayTurn
  }
  
  func pass() {
    _currentPlayerPassed = true
  }
  
}
