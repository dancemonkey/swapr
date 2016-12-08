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
  
  var message: MSMessage!
  var composeDelegate: ComposeMessageDelegate!
  var game: Game? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNewGame()
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
  
  func setupWordView(forWord word: Word) {
    setupLetterView(forSize: word.size)
    setLettersInLetterView(forWord: word.name)
  }
  
  func setupLetterView(forSize size: Int) {
    print(size, letters.count)
    if size < letters.count {
      makeLettersSmaller(by: letters.count - size)
    } else if size > letters.count {
      makeLettersBigger(by: size - letters.count)
    }
    setLetterViewOrder()
  }
  
  func makeLettersSmaller(by diff: Int) {
    for _ in 0...diff {
      letters[letters.count-1].isHidden = true
    }
  }
  
  func makeLettersBigger(by diff: Int) {
    for _ in 0...diff {
      letters[letters.count-1].isHidden = false
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
  }
  
}
