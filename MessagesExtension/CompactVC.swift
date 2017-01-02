//
//  CompactVC.swift
//  Swapr
//
//  Created by Drew Lanning on 12/7/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import AVFoundation

class CompactVC: UIViewController {
  
  var newGameDelegate: StartNewGame!
  
  @IBOutlet var wordBtns: [UIButton]!
  @IBOutlet var letters: [UIImageView]!
  
  var words = [Word]()
  let STARTING_WORDS = 3
  
  var player: AVAudioPlayer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getWords()
    configureViews()
    let _ = ColorGradient(withView: self.view)
    
    DispatchQueue.global(qos: .background).async {
      do {
        if let path = Bundle.main.path(forResource: "Explosion1.wav", ofType: nil) {
          print("Found explosion1.wav")
          let url = URL(fileURLWithPath: path)
          print(url)
          self.player = try AVAudioPlayer(contentsOf: url)
          self.player.prepareToPlay()
          self.player.play()
          print("playing?")
        }
      } catch {
        print("error \(error)")
      }
    }
    
  }
  
  func configureViews() {
    for button in wordBtns {
      button.setTitle(words[button.tag].name, for: .normal)
      button.whiteGlowOn()
    }
    for letter in letters {
      let random = Float(arc4random_uniform(16))
      let radians = random * 0.017
      let negative = arc4random_uniform(2) == 1 ? true : false
      if negative {
        rotate(imageView: letter, byAngle: -radians)
      } else {
        rotate(imageView: letter, byAngle: radians)
      }
    }
  }
  
  func getWords() {
    let wordList = WordsAPI()
    for _ in 0 ..< STARTING_WORDS {
      words.append(wordList.fetchRandomWord()!)
    }
  }
  
  @IBAction func wordButtonPressed(sender: UIButton) {
    Utils.animateButton(sender, withTiming: Utils.buttonTiming) { [unowned self] in
      self.newGameDelegate.startNewGame(withWord: self.words[sender.tag])
    }
  }
  
  func rotate(imageView: UIImageView, byAngle angle: Float) {
    imageView.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
  }
  
}
