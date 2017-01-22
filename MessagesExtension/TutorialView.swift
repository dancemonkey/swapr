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
    .launch: UIImage(named: "tutScreenie")!,
    .letter: UIImage(named: "tutLetters")!,
    .word: UIImage(named: "tutWord")!,
    .bomb: UIImage(named: "tutBomb")!,
    .lock: UIImage(named: "tutLock")!,
    .swap: UIImage(named: "tutSwap")!,
    .score: UIImage(named: "tutScore")!,
    .chain: UIImage(named: "tutChain")!,
    .done: UIImage(named: "tutScreenie")!
  ]
  
  @IBOutlet weak var tutorialMessage: UITextView!
  @IBOutlet weak var gameImage: UIImageView!
  @IBOutlet weak var landscapeMessage: UITextView!
  
  func initView(forSection section: TutorialSection, forTutorial tutorial: Tutorial, forSize size: CGRect) {
    self.section = section
    self.tutorial = tutorial
    self.tutorialMessage.text = tutorial.getPhrase(forSection: section)
    self.bounds = size
    placeTextView()
  }
  
  private func placeTextView() {
    let messagePosition: [TutorialSection: CGPoint] = [
      .launch: self.center,
      .letter: CGPoint(x: self.center.x, y: 400.0),
      .word: CGPoint(x: self.center.x, y: 230.0),
      .bomb: CGPoint(x: self.center.x-20, y: 335.0),
      .lock: CGPoint(x: self.center.x+50, y: 335.0),
      .swap: CGPoint(x: self.center.x+65, y: 335.0),
      .score: CGPoint(x: self.center.x, y: 175.0),
      .chain: CGPoint(x: self.center.x, y: 175.0),
      .done: self.center
    ]
    
    let messageSize: [TutorialSection: CGSize] = [
      .launch: CGSize(width: 220.0, height: 250.0),
      .letter: CGSize(width: 220.0, height: 110.0),
      .word: CGSize(width: 220.0, height: 250.0),
      .bomb: CGSize(width: 220.0, height: 93.0),
      .lock: CGSize(width: 220.0, height: 110.0),
      .swap: CGSize(width: 220.0, height: 160.0),
      .score: CGSize(width: 220.0, height: 160.0),
      .chain: CGSize(width: 220.0, height: 250.0),
      .done: CGSize(width: 220.0, height: 180.0)
    ]
    
    tutorialMessage.frame.size = messageSize[section!]!
    tutorialMessage.center.x = messagePosition[section!]!.x
    tutorialMessage.frame.origin.y = messagePosition[section!]!.y
    if section! == .launch || section! == .done {
      tutorialMessage.center.y = messagePosition[section!]!.y
    }
    gameImage.image = tutorialImage[section!]!
  }
  
  private func showLandscapeMessage() {
    landscapeMessage.isHidden = false
  }
  
  private func hideLandscapeMessage() {
    landscapeMessage.isHidden = true
  }
  
  func rotated(toOrientation orientation: UIInterfaceOrientation) {
    if orientation == .portrait {
      backgroundGradient = nil
      tutorialMessage.isHidden = false
      gameImage.isHidden = false
      hideLandscapeMessage()
    } else if orientation == .landscapeLeft || orientation == .landscapeRight { 
      showLandscapeMessage()
      if let gradient = backgroundGradient {
        gradient.gl.frame = self.bounds
        tutorialMessage.isHidden = true
        gameImage.isHidden = true
      } else {
        backgroundGradient = ColorGradient(withView: self)
        tutorialMessage.isHidden = true
        gameImage.isHidden = true
      }
    }
  }

}
