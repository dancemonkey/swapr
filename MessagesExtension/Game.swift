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
  let MAX_TILES_TO_DRAW = 10
  let wordList = WordsAPI()
    
  private var _gameOver: Bool = false
  var gameOver: Bool {
    return _gameOver
  }
  
  private var _tilesDrawn: Int = 0
  var tilesDrawn: Int {
    return _tilesDrawn
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
  
  private var _playMessage: String = ""
  var playMessage: String {
    return _playMessage
  }
  
  private var _lastUserToOpen: String? = nil
  var lastUserToOpen: String? {
    return _lastUserToOpen
  }
  
  init(withMessage message: MSMessage?) {
    if let msg = message, let url = msg.url {
      
      var oppPlayer = TempPlayer(hand: "", score: 0, helpers: "", chainScore: 0)
      var currentPlayer = TempPlayer(hand: "", score: 0, helpers: "", chainScore: 0)
      
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
            if item.name == "gameOver" {
              self._gameOver = Bool("\(item.value!)")!
            }
            if item.name == "drawnTiles" {
              self._tilesDrawn = Int(item.value!)!
            }
            if item.name == "lastUserToOpen" {
              self._lastUserToOpen = item.value!
            }
          }
        }
      }
      self._currentPlayer = Player(hand: currentPlayer.hand, score: currentPlayer.score, helpers: currentPlayer.helpers, chainScore: currentPlayer.chainScore)
      self._oppPlayer = Player(hand: oppPlayer.hand, score: oppPlayer.score, helpers: oppPlayer.helpers, chainScore: oppPlayer.chainScore)
    } else {
      _oppPlayer = Player(hand: nil, score: 0, helpers: nil, chainScore: 0)
      _currentPlayer = Player(hand: nil, score: 0, helpers: nil, chainScore: 0)
    }
  }
  
  func setCurrentWord(to word: Word) {
    self._currentWord = word
  }
  
  func getNewWord() -> Word {
    return wordList.fetchRandomWord()!
  }
  
  func getNewLetter(forPlayer player: Player) {
    _tilesDrawn = _tilesDrawn + 1
    player.drawNewLetter(fromList: wordList)
  }
  
  func testIfValid(word: Word, completion: @escaping (Bool)->()) {
    wordList.isRealWord(word: word, completion: completion)
  }
  
  func gameIsOver() -> Bool {
    if tilesDrawn >= MAX_TILES_TO_DRAW {
      _gameOver = true
      return true
    }
    return false
  }
  
  func winningPlayer() -> Player? {
    return currentPlayer.score > oppPlayer.score ? currentPlayer : oppPlayer
  }
  
  func scoreRound() {
    _currentPlayer.increaseScore(by: _currentWord!.name.characters.count)
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
    _currentPlayer.increaseTurnBonus(by: 1)
  }
  
  func addNewLetterSpace(to: AddLetter) {
    let oldWord = _currentWord
    var lockMod = 0
    if to == .left {
      _currentWord = Word(fromText: "_\(oldWord!.name)")
      lockMod = 1
    } else {
      _currentWord = Word(fromText: "\(oldWord!.name)_")
    }
    if let lock1 = oldWord?.locked1 {
      _currentWord?.lockLetter(at: lock1 + lockMod)
    }
    if let lock2 = oldWord?.locked2 {
      _currentWord?.lockLetter(at: lock2 + lockMod)
    }
    _currentPlayer.increaseTurnBonus(by: 1)
  }
  
  func playerPlayedTurn() -> Bool {
    return _currentPlayer.didPlayTurn
  }
  
  func pass() {
    _currentPlayer.resetChainToZero()
    _currentPlayer.setStartingHand()
  }
  
  func invalidPlay() {
    _currentPlayer.resetChainToZero()
  }
  
  func lockLetterInWord(at index: Int) {
    _currentWord?.lockLetter(at: index)
  }
  
  func resetForNewGame() {
    self._currentWord = wordList.fetchRandomWord()
    _oppPlayer = Player(hand: nil, score: 0, helpers: nil, chainScore: 0)
    _currentPlayer = Player(hand: nil, score: 0, helpers: nil, chainScore: 0)
    self._gameOver = false
    initNewGame()
  }
  
  func wordIsMaxSize() -> Bool {
    return _currentWord!.size >= MAX_WORD_LENGTH
  }
  
  func setPlayMessage(forHelper helper: Helper) {
    var playMessage = " used their " + helper.rawValue
    if helper == .pass {
      playMessage = " got a fresh hand of new letters."
    }
    if helper == .bomb || helper == .swap {
      playMessage.append(", and they")
      playMessage.append(setPlayMessage(forWord: (self.currentWord)!))
    }
    self._playMessage = playMessage
  }
  
  func setPlayMessage(forWord word: Word) -> String {
    self._playMessage = " played \(word.name.uppercased())"
    return " played \(word.name.uppercased())"
  }
  
  func initNewGame() {
    _currentWord?.unlockAll()
    _tilesDrawn = 0
  }
  
  func isCheating(player: String) -> Bool {
    if let last = lastUserToOpen {
      return last == player
    } else {
      return false
    }
  }
  
}
