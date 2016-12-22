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
  var strikes: Int
}

class Game {
  
  let MAX_WORD_LENGTH = 6
  let MAX_STRIKES = 3
  let wordList = WordsAPI()
  
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
      
      var oppPlayer = TempPlayer(hand: "", score: 0, helpers: "", chainScore: 0, strikes: 0)
      var currentPlayer = TempPlayer(hand: "", score: 0, helpers: "", chainScore: 0, strikes: 0)
      
      if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false) {
        if let queryItems = components.queryItems {
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
            if item.name == "oppChainScore" {
              oppPlayer.chainScore = Int(item.value!)!
            }
            if item.name == "currentChainScore" {
              currentPlayer.chainScore = Int(item.value!)!
            }
            if item.name == "lockedLetterPos1" {
              self._currentWord?.lockLetter(at: Int(item.value!)!)
            }
            if item.name == "lockedLetterPos2" {
              self._currentWord?.lockLetter(at: Int(item.value!)!)
            }
            if item.name == "currentPlayerStrikes" {
              currentPlayer.strikes = Int(item.value!)!
            }
            if item.name == "oppPlayerStrikes" {
              oppPlayer.strikes = Int(item.value!)!
            }
          }
        }
      }
      self._currentPlayer = Player(hand: currentPlayer.hand, score: currentPlayer.score, helpers: currentPlayer.helpers, chainScore: currentPlayer.chainScore, strikes: currentPlayer.strikes)
      self._oppPlayer = Player(hand: oppPlayer.hand, score: oppPlayer.score, helpers: oppPlayer.helpers, chainScore: oppPlayer.chainScore, strikes: oppPlayer.strikes)
    } else {
      _oppPlayer = Player(hand: nil, score: 0, helpers: nil, chainScore: 0, strikes: 0)
      _currentPlayer = Player(hand: nil, score: 0, helpers: nil, chainScore: 0, strikes: 0)
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
  
  func testIfValid(word: Word, completion: @escaping (Bool)->()) {
    wordList.isRealWord(word: word, completion: completion)
  }
  
  func gameIsOver() -> Bool {
    return _currentPlayer.strikes >= MAX_STRIKES
  }
  
  func winningPlayer() -> Player? {
    return currentPlayer.score > oppPlayer.score ? currentPlayer : oppPlayer
  }
  
  func scoreRound() {
    _currentPlayer.increaseScore()
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
    _currentPlayer.incrementChainScore()
  }
  
  func playerPlayedTurn() -> Bool {
    return _currentPlayer.didPlayTurn
  }
  
  func pass() {
    _currentPlayer.resetChainToZero()
    _currentPlayer.addStrike()
  }
  
  func lockLetterInWord(at index: Int) {
    _currentWord?.lockLetter(at: index)
  }
}
