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
  
  func initView(forSection section: TutorialSection, forTutorial tutorial: Tutorial, forSize size: CGRect) {
    self.section = section
    self.tutorial = tutorial
    self.tutorialMessage.text = tutorial.getPhrase(forSection: section)
    self.bounds = size
    placeView()
  }
  
  private func placeView() {
    // TODO: place view at locations based on message
    self.center = (superview?.center)!
  }
  
  override func awakeFromNib() {
    // TODO: create NIB
  }

}
