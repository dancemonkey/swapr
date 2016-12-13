//
//  ExpandedVC.swift
//  Swapr
//
//  Created by Drew Lanning on 12/2/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import Messages

class ExpandedVC: UIViewController {
  
  @IBOutlet weak var endTurn: UIButton!
  @IBOutlet weak var bomb: UIButton!
  @IBOutlet weak var lock: UIButton!
  @IBOutlet weak var pass: UIButton!
  @IBOutlet weak var swap: UIButton!
  @IBOutlet weak var definition: UITextView!
  @IBOutlet var addLetter: [UIButton]!
  @IBOutlet var letters: [UIButton]!
  @IBOutlet var playerHand: [UIButton]!
  
  var message: MSMessage? = nil
  var composeDelegate: ComposeMessageDelegate!
  var game: Game? = nil
  
  var bombing: Bool = false
  var swapping: Bool = false
  var locking: Bool = false
  var playingLetter: Bool = false
  var letterToPlay: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if message == nil {
      setupNewGame()
    } else {
      setupExistingGame(fromMessage: message!)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupNewGame() {
    game = Game(withMessage: nil) // this will eventually be passed in from CompactVC based on player selection from starter words
    game?.setCurrentWord(to: (WordsAPI().fetchRandomWord()?.name)!) // this is a patch, will go away once CompactVC is set up properly
    setupWordView(forWord: (game?.currentWord)!)
    setupPlayerHand(withLetters: game?.currentPlayer.hand)
    // re-set helper buttons to active state
  }
  
  func setupExistingGame(fromMessage message: MSMessage) {
    game = Game(withMessage: message)
    // set scrores from message
    // setup word from message
    // setup current player helper button statuses
  }
  
  func setupWordView(forWord word: Word) {
    setupLetterView(forSize: word.size)
    setLettersInLetterView(forWord: word.name)
  }
  
  func setupPlayerHand(withLetters letters: String?) {
    print("entered player hand setup")
    var hand: String
    if let text = letters {
      print("hand passed in, value \(letters)")
      hand = text
    } else {
      print("getting new starting hand")
      hand = (game?.currentPlayer.getStartingHand())!
    }
    print(hand)
    for (index, letter) in hand.characters.enumerated() {
      playerHand[index].setTitle(String(letter), for: .normal)
      print(index,letter)
    }
    print("made it out of player hand setup")
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
    //setLetterViewOrder()
    resizeLetters(toSize: size)
  }
  
  func resizeLetters(toSize size: Int) {
    if size < getVisibleLetterCount() {
      for index in size..<getVisibleLetterCount() {
        letters[index].isHidden = true
      }
    } else if size > getVisibleLetterCount() {
      print("resizing bigger")
      for index in getVisibleLetterCount()..<size {
        letters[index].isHidden = false
      }
    }
  }
  
  func setLetterViewOrder() {
    var tempLetters: [UIButton] = letters
    for button in letters {
      tempLetters[button.tag] = button
    }
    letters = tempLetters
  }
  
  func setLettersInLetterView(forWord word: String) {
    print(word)
    for (index, letter) in word.characters.enumerated() {
      letters[index].setTitle(String(letter), for: .normal)
    }
    for letter in letters where letter.isHidden == false {
      print(letter.tag)
    }
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
    // tap this then tap two letters in the word to swap them
    swapping = true
  }
  
  @IBAction func addLetterPressed(sender:UIButton) {
    // this should only work if the word is shorter than the max letter count prop in game
  }
  
  @IBAction func letterPressed(sender: UIButton) {
    if bombing {
      sender.isHidden = true
      // game should re-write currentWord to match visible letters in view
      // player should lose this helper
      bombing = false
      bomb.isEnabled = false
    } else if locking {
      // game should lock letter in place
      // player loses this helper
      locking = false
      lock.isEnabled = false
    } else if swapping {
      // game should let you tap two letters
      // then lighting up swap button again
      // then swap places 
      // player loses helper
      swapping = false
      swap.isEnabled = false
    } else if playingLetter {
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
