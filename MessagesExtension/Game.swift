//
//  Game.swift
//  Swapr
//
//  Created by Drew Lanning on 12/8/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Foundation

enum PlayerTurn: Int {
  case playerOne = 0
  case playerTwo = 1
  case playerThree = 2
  case playerFour = 3
}

class Game {
  
//  private var _players: [Player]
//  var players: [Player] {
//    return _players
//  }
  
//  private var _turn: PlayerTurn
//  var turn: PlayerTurn {
//    return _turn
//  }
  
  private var _currentWord: Word
  var currentWord: Word {
    return _currentWord
  }
  
  private var _wordSize: Int {
    return _currentWord.size
  }
  
  init() {
    let wordList = WordsAPI()
    self._currentWord = Word(word: (wordList.fetchRandomWord()?.name)!)
  }
  
}
