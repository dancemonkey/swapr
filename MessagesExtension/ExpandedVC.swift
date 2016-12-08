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
    game = Game() // this will eventually be passed in from CompactVC based on player selection from starter words
    setupWordView(forWord: (game?.currentWord)!)
    // re-set helper buttons to active state
  }
  
  func setupExistingGame(fromMessage message: MSMessage) {
    // set scrores from message
    // setup word from message
    // setup current player helper button statuses
  }
  
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
    
  }
  
  @IBAction func lockPressed(sender:UIButton) {
    
  }
  
  @IBAction func passPressed(sender:UIButton) {
    
  }
  
  @IBAction func swapPressed(sender:UIButton) {
    
  }
  
  @IBAction func addLetterPressed(sender:UIButton) {
    
  }
  
  @IBAction func letterPressed(sender: UIButton) {
    
  }
  
}
