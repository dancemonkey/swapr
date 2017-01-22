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
  
  @IBOutlet weak var tutorialMessage: UITextView!
  @IBOutlet weak var gameImage: UIImageView!
  // TODO: change background image to highlight tutorial message
  
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
      .bomb: CGPoint(x: self.center.x-10, y: 335.0),
      .lock: CGPoint(x: self.center.x+20, y: 335.0),
      .swap: CGPoint(x: self.center.x+40, y: 335.0),
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
  }

}
