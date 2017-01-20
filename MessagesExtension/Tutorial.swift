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
    TutorialSection.launch: "Welcome to the tutorial! Let's learn how to play the game (it's really pretty easy). \n\nNavigate this walk-through like you would your photo album: swipe left to go the next step, swipe right to go the previous step (and you can swipe down at any time to get out of this tutorial and back to the game). \n\nNow let's go... swipe left!",
    TutorialSection.letter: "See down there? You have a hand of five letters. \n\nThe basic premise of the game is to tap on one of those letters in your hand, and then...",
    TutorialSection.bomb: "...use this Bomb to blow up one of the letters in the word. Again, you're hopefully leaving behind a valid word so you can score.\n\nNext to the bomb we have the...",
    TutorialSection.lock: "...Lock! This freezes one of the letters in the word, so it can never be changed or even blown up with the bomb.",
    TutorialSection.swap: "The Swap is a special one: after tapping this you can choose TWO letters in the word, and they will switch places. \n\nIf this makes a valid word then you get a bonus point on top of your word score, for using the Swap.",
    TutorialSection.score: "Scoring is simple: 1 point per letter in the word (plus a bonus point if you used the Swap). \n\nThere's another aspect to scoring, and that is the...",
    TutorialSection.chain: "Chain! For every turn that you manage to score a new word, your chain GROWS. \n\nThe  chain gives you bonus points each time you form a word, the longer the chain the more points you get. \n\nSo your score can get pretty big pretty fast if you keep making valid words.\n\nOh and if you make a word that isn't, you know, a real word? Your chain breaks and drops back to zero.",
    TutorialSection.word: "... you tap on a letter in this word, replacing the letter in the word with the letter in your hand. Create a new word, and you score points!\n\nSee the buttons with the '+' signs on them beside the word? Tapping one of those lets you add a blank letter to the front or back of the word, so you can make the word longer.\n\nInstead of playing a letter from your hand to form a new word, you can also...",
    TutorialSection.done: "That's it! Now swipe left or down to get rid of this tutorial, and go play!"
  ]
  
//  let testFrame = CGRect(x: 0, y: 0, width: 250, height: 50)
//  var locations: [TutorialSection: CGRect]!
  
  func getPhrase(forSection section: TutorialSection) -> String {
    return phrases[section]!
  }
  
}
