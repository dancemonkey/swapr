//
//  ExpandedVC.swift
//  Swapr
//
//  Created by Drew Lanning on 12/2/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import Messages

enum AddLetter: Int {
  case left = 0, right
}

class ExpandedVC: UIViewController {
  
  @IBOutlet weak var endTurn: UIButton!
  @IBOutlet weak var bomb: UIButton!
  @IBOutlet weak var lock: UIButton!
  @IBOutlet weak var pass: UIButton!
  @IBOutlet weak var swap: UIButton!
  @IBOutlet weak var definition: UITextView!
  @IBOutlet var addLetter: [UIButton]!
  @IBOutlet var letters: [LetterButton]!
  @IBOutlet var playerHand: [UIButton]!
  
  var message: MSMessage? = nil
  var composeDelegate: ComposeMessageDelegate!
  var game: Game? = nil
  
  var bombing: Bool = false
  var swapping: Bool = false
  var firstLetter: LetterButton? = nil
  var locking: Bool = false
  var playingLetter: Bool = false
  var letterToPlay: String = ""
  var addingLetter: Bool = false
  var addLetterTarget: LetterButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if message == nil {
      setupNewGame()
    } else {
      setupExistingGame(fromMessage: message!)
    }
  }
  
  func setupNewGame() {
    game = Game(withMessage: nil) // this will eventually be passed in from CompactVC based on player selection from starter words
    game?.setCurrentWord(to: (WordsAPI().fetchRandomWord()?.name)!) // this is a patch, will go away once CompactVC is set up properly
    setupWordView(forWord: (game?.currentWord)!)
    setupPlayerHand(withLetters: game?.currentPlayer.hand)
    setupHelperViews(with: (game?.currentPlayer.helpers)!)
  }
  
  func setupExistingGame(fromMessage message: MSMessage) {
    game = Game(withMessage: message)
    setupWordView(forWord: (game?.currentWord)!)
    setupPlayerHand(withLetters: game?.currentPlayer.hand)
    setupHelperViews(with: (game?.currentPlayer.helpers)!)
    // set scores from message i.e. setupScores()
  }
  
  func setupWordView(forWord word: Word) {
    setupLetterView(forSize: word.size)
    setLettersInLetterView(forWord: word.name)
  }
  
  func setupPlayerHand(withLetters letters: String?) {
    var hand: String
    if let text = letters {
      hand = text
    } else {
      hand = (game?.currentPlayer.getStartingHand())!
    }
    for (index, letter) in hand.characters.enumerated() {
      playerHand[index].setTitle(String(letter), for: .normal)
    }
  }
  
  func getVisibleLetterCount() -> Int {
    return letters.reduce(0, { (total, button) -> Int in
      if button.isHidden == false {
        return 1 + total
      } else {
        return total
      }
    })
  }
  
  func setupLetterView(forSize size: Int) {
    for letter in letters {
      letter.isHidden = false
    }
    resizeLetters(toSize: size)
  }
  
  func resizeLetters(toSize size: Int) { // WHY PASS IN VALUE, JUST CALL SIZE DIRECTLY?
    if size < getVisibleLetterCount() {
      for index in size..<getVisibleLetterCount() {
        letters[index].isHidden = true
      }
    } else if size > getVisibleLetterCount() {
      for index in getVisibleLetterCount()..<size {
        letters[index].isHidden = false
      }
    }
  }
  
  func setupHelperViews(with helpers: [Helper]) {
    if helpers.contains(.bomb) {
      bomb.isEnabled = true
    }
    if helpers.contains(.lock) {
      lock.isEnabled = true
    }
    if helpers.contains(.swap) {
      swap.isEnabled = true
    }
    addingLetter = false
    swapping = false
    bombing = false
    locking = false
  }
  
  func setLettersInLetterView(forWord word: String) { //  WHY PASS IN VALUE, JUST CALL WORD DIRECTLY?
    print(word)
    for (index, letter) in word.characters.enumerated() {
      letters[index].setTitle(String(letter), for: .normal)
    }
    for letter in letters where letter.isHidden == false {
      print(letter.tag)
    }
  }
  
  func swapLetters(first: LetterButton, with second: LetterButton) {
    var firstIndex = 0
    var secondIndex = 0
    for (index, letter) in letters.enumerated() {
      if letter == first {
        firstIndex = index
      }
      if letter == second {
        secondIndex = index
      }
    }
    game?.swapLetters(first: first.currentTitle!, at: firstIndex, with: second.currentTitle!, at: secondIndex)
    setLettersInLetterView(forWord: (game?.currentWord?.name)!)
  }
  
  // IBACTIONS
  
  @IBAction func endTurnPressed(sender: UIButton) {
    setupNewGame() // temp for testing
  }
  
  @IBAction func bombPressed(sender:UIButton) {
    // tap this to remove a letter from the word
    // doing so must still leave you with a valid word
    bombing = true
  }
  
  @IBAction func lockPressed(sender:UIButton) {
    // tap this to lock a letter forever in the word
    locking = true
  }
  
  @IBAction func passPressed(sender:UIButton) {
    // end turn, chain resets to 0
  }
  
  @IBAction func swapPressed(sender:UIButton) {
    swapping = true
  }
  
  @IBAction func addLetterPressed(sender:UIButton) {
    if addingLetter == false {
      addingLetter = true
      if getVisibleLetterCount() == (game?.currentWord?.size)! {
        switch sender.tag {
        case AddLetter.left.rawValue:
          extendLetterView(direction: .left)
        case AddLetter.right.rawValue:
          extendLetterView(direction: .right)
        default: break
        }
      }
    }
  }
  
  func extendLetterView(direction: AddLetter) {
    game?.addNewLetterSpace(to: direction)
    setupLetterView(forSize: (game?.currentWord?.size)!)
    setLettersInLetterView(forWord: (game?.currentWord?.name)!)
    if direction == .right {
      addLetterTarget = letters[getVisibleLetterCount()-1]
    } else {
      addLetterTarget = letters[0]
    }
  }
  
  @IBAction func letterPressed(sender: LetterButton) {
    if addingLetter && playingLetter && sender == addLetterTarget {
      game?.replaceLetter(atIndex: sender.tag, withPlayerLetter: letterToPlay)
      playingLetter = false
      setLettersInLetterView(forWord: (game?.currentWord?.name)!)
      setupPlayerHand(withLetters: game?.currentPlayer.hand)
    }
    if bombing && sender.locked == false {
      sender.isHidden = true
      bombing = false
      bomb.isEnabled = false
      game?.playHelper(helper: .bomb, forPlayer: (game?.currentPlayer)!)
    } else if locking && sender.locked == false {
      sender.locked = true
      locking = false
      lock.isEnabled = false
      game?.playHelper(helper: .lock, forPlayer: (game?.currentPlayer)!)
    } else if swapping && sender.locked == false {
      if firstLetter != nil {
        swapping = false
        swap.isEnabled = false
        swapLetters(first: firstLetter!, with: sender)
        game?.playHelper(helper: .swap, forPlayer: (game?.currentPlayer)!)
      }
      if firstLetter == nil {
        firstLetter = sender
      }
    } else if playingLetter && sender.locked == false && !addingLetter {
      game?.replaceLetter(atIndex: sender.tag, withPlayerLetter: letterToPlay)
      playingLetter = false
      setLettersInLetterView(forWord: (game?.currentWord?.name)!)
      setupPlayerHand(withLetters: game?.currentPlayer.hand)
    }
  }
  
  @IBAction func playerHandLetterPressed(sender: UIButton) {
    letterToPlay = (sender.titleLabel?.text)!
    playingLetter = true
  }
  
}
