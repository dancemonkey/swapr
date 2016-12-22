//
//  CompactVC.swift
//  Swapr
//
//  Created by Drew Lanning on 12/7/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class CompactVC: UIViewController {
  
  var newGameDelegate: StartNewGame!
  
  @IBOutlet var wordBtns: [UIButton]!
  
  var words = [Word]()
  let STARTING_WORDS = 3
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getWords()
    configureViews()
  }
  
  func configureViews() {
    for button in wordBtns {
      button.setTitle(words[button.tag].name, for: .normal)
    }
  }
  
  func getWords() {
    let wordList = WordsAPI()
    for _ in 0 ..< STARTING_WORDS {
      words.append(wordList.fetchRandomWord()!)
    }
  }
  
  @IBAction func wordButtonPressed(sender: UIButton) {
    newGameDelegate.startNewGame(withWord: words[sender.tag])
  }
  
}
