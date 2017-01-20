//
//  Tutorial.swift
//  Swapr
//
//  Created by Drew Lanning on 1/18/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

enum TutorialSection: String {
  case launch, letter, bomb, lock, swap, score, chain, word, done
}

class Tutorial {
  
  let phrases = [
    TutorialSection.launch: "launch phrase",
    TutorialSection.letter: "letter phrase",
    TutorialSection.bomb: "bomb phrase",
    TutorialSection.lock: "lock phrase",
    TutorialSection.swap: "swap phrase",
    TutorialSection.score: "score phrase",
    TutorialSection.chain: "chain phrase",
    TutorialSection.word: "word phrase",
    TutorialSection.done: "done phrase"
  ]
  
  // TODO: CGRects for placement of different messages
  let testFrame = CGRect(x: 0, y: 0, width: 250, height: 50)
  var locations: [TutorialSection: CGRect]!
  
  func getPhrase(forSection section: TutorialSection) -> String {
    return phrases[section]!
  }
  
}
