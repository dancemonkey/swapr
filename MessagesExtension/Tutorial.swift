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
    TutorialSection.launch: "Welcome to the tutorial! Let's learn how to play the game (it's really pretty easy). \n\nSwipe left to go to the next step, swipe right to go back (and you can swipe down at any time to get out of this tutorial and back to the game). \n\nNow let's go... swipe left!",
    TutorialSection.letter: "You have a hand of five letters. \n\nOn your turn you can tap a letter, and...",
    TutorialSection.bomb: "Tap this bomb and a letter in the word to blow it up. Next to the bomb we have the...",
    TutorialSection.lock: "... lock. This freezes one of the letters in the word, so it can never be changed or even blown up with the bomb.",
    TutorialSection.swap: "The Swap lets you tap two letters in the word, and they will switch places. \n\nIf this makes a valid word then you get an extra bonus point on top of your word score, for using the Swap.",
    TutorialSection.score: "Scoring is 1 point per letter in the word (plus a bonus point if you used the Swap). \n\nThere's another aspect to scoring, and that is the...",
    TutorialSection.chain: "... chain. For every turn that you score, your chain grows. \n\nThe chain gives you bonus points each time you form a word, the longer the chain the more points you get. \n\nIf you form an invalid word you chain breaks and drops back to zero.",
    TutorialSection.word: "... you tap on a letter in this word, replacing the letter in the word with the letter in your hand, creating a new word and scoring points!\n\nThe '+' buttons beside the word let you add a blank letter to the front or back of the word, so you can make the word longer.",
    TutorialSection.done: "That's it! At the end of each turn the 'Send' button activates so you can send your move to your opponent.\n\nNow swipe left or down to get rid of this tutorial, and go play!"
  ]
  
  func getPhrase(forSection section: TutorialSection) -> String {
    return phrases[section]!
  }
  
}
