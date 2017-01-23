//
//  TutorialView.swift
//  Swapr
//
//  Created by Drew Lanning on 1/18/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class TutorialView: UIView {
  
  var section: TutorialSection!
  var tutorial: Tutorial!
  var backgroundGradient: ColorGradient! = nil
  
  let tutorialImage: [TutorialSection: UIImage] = [
    .launch: UIImage(named: "tutLaunch")!,
    .letter: UIImage(named: "tutLetters")!,
    .word: UIImage(named: "tutWord")!,
    .bomb: UIImage(named: "tutBomb")!,
    .lock: UIImage(named: "tutLock")!,
    .swap: UIImage(named: "tutSwap")!,
    .score: UIImage(named: "tutScore")!,
    .chain: UIImage(named: "tutChain")!,
    .done: UIImage(named: "tutDone")!,
    .addLetter: UIImage(named: "tutAddLetter")!
  ]
  
  @IBOutlet weak var gameImage: UIImageView!
  @IBOutlet weak var landscapeMessage: UITextView!
  
  func initView(forSection section: TutorialSection, forTutorial tutorial: Tutorial, forSize size: CGRect) {
    self.section = section
    self.tutorial = tutorial
    self.bounds = size
    showTutorialImage()
    if backgroundGradient == nil {
      backgroundGradient = ColorGradient(withView: self)
    }
  }
  
  private func showTutorialImage() {
    gameImage.image = tutorialImage[section!]!
  }
  
  private func showLandscapeMessage() {
    landscapeMessage.isHidden = false
  }
  
  private func hideLandscapeMessage() {
    landscapeMessage.isHidden = true
  }
  
  func rotated(toOrientation orientation: UIInterfaceOrientation) {
    let device = UIDevice.current.model
    let iPad = "iPad"
    if orientation == .portrait {
      gameImage.isHidden = false
      hideLandscapeMessage()
    } else if orientation == .landscapeLeft || orientation == .landscapeRight && device != iPad {
      showLandscapeMessage()
      if let gradient = backgroundGradient {
        gradient.gl.frame = self.bounds
        gameImage.isHidden = true
      } else {
        backgroundGradient = ColorGradient(withView: self)
          gameImage.isHidden = true
      }
    }
  }
  
}
