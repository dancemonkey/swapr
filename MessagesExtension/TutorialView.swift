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
  
  @IBOutlet weak var tutorialMessage: UILabel!
  
  func initView(forSection section: TutorialSection, forTutorial tutorial: Tutorial) {
    self.section = section
    self.tutorial = tutorial
    self.tutorialMessage.text = tutorial.getPhrase(forSection: section)
    placeView()
  }
  
  private func placeView() {
    // TODO: place view at locations based on message
    self.frame.origin = (superview?.center)!
  }
  
  override func awakeFromNib() {
    // TODO: create NIB
  }

}
