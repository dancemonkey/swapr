//
//  Tutorial.swift
//  Swapr
//
//  Created by Drew Lanning on 1/18/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import Foundation

enum TutorialSection: String {
  case launch, letter, bomb, lock, swap, score, chain, word
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
    TutorialSection.word: "word phrase"
  ]
  
  func getPhrase(forSection section: TutorialSection) -> String {
    return phrases[section]!
  }
  
}
