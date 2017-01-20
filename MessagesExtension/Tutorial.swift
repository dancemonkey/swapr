//
//  Tutorial.swift
//  Swapr
//
//  Created by Drew Lanning on 1/18/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

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
  
  // TODO: CGRects for placement of different messages
  let locations = [
    TutorialSection.launch: CGRect.zero,
    TutorialSection.letter: CGRect.zero,
    TutorialSection.bomb: CGRect.zero,
    TutorialSection.lock: CGRect.zero,
    TutorialSection.swap: CGRect.zero,
    TutorialSection.score: CGRect.zero,
    TutorialSection.chain: CGRect.zero,
    TutorialSection.word: CGRect.zero
  ]
  
  func getPhrase(forSection section: TutorialSection) -> String {
    return phrases[section]!
  }
  
  func getLocation(forSection section: TutorialSection) -> CGRect {
    return locations[section]!
  }
  
}
