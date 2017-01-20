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
  
  // TODO: image for each section, highlighted what's being talked about
  // TODO: switch image in imageView
  
  func initView(forSection section: TutorialSection, forTutorial tutorial: Tutorial, forSize size: CGRect) {
    self.section = section
    self.tutorial = tutorial
    self.tutorialMessage.text = tutorial.getPhrase(forSection: section)
    self.bounds = size
    placeTextView()
  }
  
  private func placeTextView() {
    // TODO: CGRects for placement of different messages
    // TODO: place view at locations based on section
    
    let superWidth = superview!.bounds.width
    let superHeight = superview!.bounds.height
    switch section! {
    case .launch:
      tutorialMessage.frame = CGRect(x: 0.0, y: 0.0, width: superWidth - 50.0, height: superHeight - 250.0)
      tutorialMessage.center = self.center
    case.bomb:
      tutorialMessage.center = self.center
    case.chain:
      tutorialMessage.center = self.center
    case .letter:
      tutorialMessage.center = self.center
    case .lock:
      tutorialMessage.center = self.center
    case .swap:
      tutorialMessage.center = self.center
    case .score:
      tutorialMessage.center = self.center
    case .done:
      tutorialMessage.center = self.center
    case .word:
      tutorialMessage.center = self.center
    }
    
  }

}
