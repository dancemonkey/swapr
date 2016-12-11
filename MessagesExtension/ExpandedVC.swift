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
    // zero out any player scores
    game = Game(withMessage: message) // this will eventually be passed in from CompactVC based on player selection from starter words
    setupWordView(forWord: (game?.currentWord)!)
    // re-set helper buttons to active state
  }
  
  func setupExistingGame(fromMessage message: MSMessage) {
    // set scrores from message
    // setup word from message
    // setup current player helper button statuses
  }
  
//  func setupPlayerHand(forPlayer player: Player) {
//    
//  }
  
  func setupWordView(forWord word: Word) {
    setupLetterView(forSize: word.size)
    setLettersInLetterView(forWord: word.name)
    definition.text = word.name // temp for testing
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
    resizeLetters(toSize: size)
    setLetterViewOrder()
  }
  
  func resizeLetters(toSize size: Int) {
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
  
  func setLetterViewOrder() {
    var tempLetters: [UIButton] = letters
    for button in letters {
      tempLetters[button.tag] = button
    }
    letters = tempLetters
  }
  
  func setLettersInLetterView(forWord word: String) {
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
  }
  
  @IBAction func lockPressed(sender:UIButton) {
    // tap this to lock a letter forever in the word
  }
  
  @IBAction func passPressed(sender:UIButton) {
    // end turn, chain resets to 0
  }
  
  @IBAction func swapPressed(sender:UIButton) {
    // tap this then tap two letters in the word to swap them
  }
  
  @IBAction func addLetterPressed(sender:UIButton) {
    // this should only work if the word is shorter than the max letter count prop in game
  }
  
  @IBAction func letterPressed(sender: UIButton) {
    print(sender.tag)
    print(sender.titleLabel?.text)
  }
  
  @IBAction func playerHandLetterPressed(sender: UIButton) {
    // tap this, then tap a letter in the word to replace it with this one
  }
  
}
