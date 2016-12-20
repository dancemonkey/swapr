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
  @IBOutlet var playerHand: [LetterButton]!
  @IBOutlet weak var currentPlayerScore: UILabel!
  @IBOutlet weak var oppPlayerScore: UILabel!
  @IBOutlet weak var chainScore: UILabel!
  
  var message: MSMessage? = nil
  var composeDelegate: ComposeMessageDelegate!
  var game: Game? = nil
  
  var bombing: Bool = false
  var swapping: Bool = false
  var firstLetter: LetterButton? = nil
  var locking: Bool = false
  var playingLetter: Bool = false {
    didSet {
      if playingLetter == false {
        removeAllLetterHighlights()
      }
    }
  }
  var letterToPlay: String = ""
  var addingLetter: Bool = false
  var addLetterTarget: LetterButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let wordList = WordsAPI()
    endTurn.isEnabled = false
    if message == nil {
      setupNewGame()
    } else {
      setupExistingGame(fromMessage: message!)
    }
    wordList.fetchDefinition(forWord: (game?.currentWord?.name)!, completion: {
      
    })
  }
  
  func setupNewGame() {
    game = Game(withMessage: message)
    game?.setCurrentWord(to: (WordsAPI().fetchRandomWord()?.name)!) // this is a patch, will go away once CompactVC is set up properly
    setupWordView()
    setupPlayerHand()
    setupHelperViews()
    setupScoreViews()
  }
  
  func setupExistingGame(fromMessage message: MSMessage) {
    game = Game(withMessage: message)
    setupWordView()
    setupPlayerHand()
    setupHelperViews()
    setupScoreViews()
  }
  
  func setupScoreViews() {
    currentPlayerScore.text = String(describing: game!.currentPlayer.score)
    oppPlayerScore.text = String(describing: game!.oppPlayer.score)
    chainScore.text = String(describing: game!.currentPlayer.chainScore)
  }
  
  func setupWordView() {
    let word = game?.currentWord
    setupLetterViewSize()
    setLettersInLetterView(forWord: (word?.name)!)
    if let lock1 = game!.currentWord?.locked1 {
      lockLetterView(forTag: lock1)
    }
    if let lock2 = game!.currentWord?.locked2 {
      lockLetterView(forTag: lock2)
    }
  }
  
  private func lockLetterView(forTag tag: Int) {
    for letter in letters {
      if letter.tag == tag {
        letter.locked = true
      }
    }
  }
  
  func setupPlayerHand() {
    var hand: String
    if let text = game?.currentPlayer.hand {
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
  
  func setupLetterViewSize() {
    let size = game?.currentWord?.size
    for letter in letters {
      letter.isHidden = false
    }
    resizeLetters(toSize: size!)
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
  
  func setupHelperViews() {
    let helpers = game!.currentPlayer.helpers
    bomb.isEnabled = false
    lock.isEnabled = false
    swap.isEnabled = false
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
  
  func setLettersInLetterView(forWord word: String) {
    for (index, letter) in word.characters.enumerated() {
      letters[index].setTitle(String(letter), for: .normal)
      letters[index].tag = index
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
  
  @IBAction func endTurnPressed(sender: UIButton) {
    game?.endRound()
    composeDelegate.compose(fromGame: game!)
  }
  
  @IBAction func bombPressed(sender:UIButton) {
    // tap this to remove a letter from the word
    // doing so must still leave you with a valid word
    if !bombing {
      bombing = true
    } else {
      bombing = false
    }
  }
  
  @IBAction func lockPressed(sender:UIButton) {
    // tap this to lock a letter forever in the word
    if !locking {
      locking = true
    } else {
      locking = false
    }
  }
  
  @IBAction func passPressed(sender:UIButton) {
    // confirm player wants to pass and drop chain to 0
    // warn if this will end game
    // maybe they lose the current chain points instead of just getting nothing?
    game?.pass()
    endTurn.isEnabled = true
    setupScoreViews()
  }
  
  @IBAction func swapPressed(sender:UIButton) {
    if !swapping {
      swapping = true
    } else {
      swapping = false
    }
  }
  
  @IBAction func addLetterPressed(sender:UIButton) {
    if addingLetter == false {
      setupScoreViews()
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
    if game?.playerPlayedTurn() == false {
      game?.addNewLetterSpace(to: direction)
      setupLetterViewSize()
      setLettersInLetterView(forWord: (game?.currentWord?.name)!)
      if direction == .right {
        addLetterTarget = letters[getVisibleLetterCount()-1]
      } else {
        addLetterTarget = letters[0]
      }
    }
  }
  
  @IBAction func letterPressed(sender: LetterButton) {
    
    defer {
      setupScoreViews()
      endTurn.isEnabled = true
    }
    
    if game?.playerPlayedTurn() == false {
      if addingLetter && playingLetter && sender == addLetterTarget {
        game?.replaceLetter(atIndex: sender.tag, withPlayerLetter: letterToPlay)
        playingLetter = false
        setLettersInLetterView(forWord: (game?.currentWord?.name)!)
        setupPlayerHand()
      }
      if bombing && sender.locked == false {
        sender.isHidden = true
        bombing = false
        bomb.isEnabled = false
        game?.playHelper(helper: .bomb, forPlayer: (game?.currentPlayer)!)
        game?.rewriteWord(as: visibleWord())
      } else if locking && sender.locked == false {
        sender.locked = true
        locking = false
        lock.isEnabled = false
        game?.playHelper(helper: .lock, forPlayer: (game?.currentPlayer)!)
        game?.lockLetterInWord(at: sender.tag)
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
        setupPlayerHand()
      }
    }
  }
  
  func visibleWord() -> String {
    var word = ""
    for letter in letters where letter.isHidden == false {
      word = word + (letter.titleLabel?.text)!
    }
    return word
  }
  
  @IBAction func playerHandLetterPressed(sender: LetterButton) {
    if game?.playerPlayedTurn() == false {
      sender.tap()
      letterToPlay = (sender.titleLabel?.text)!
      playingLetter = true
    }
  }
  
  func removeAllLetterHighlights() {
    for letter in playerHand {
      letter.layer.borderColor = UIColor.black.cgColor
    }
  }
  
}
