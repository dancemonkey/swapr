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
  var nextButtonAction: (() -> ())!
  
  @IBOutlet weak var tutorialMessage: UILabel!
  @IBOutlet weak var nextButton: UIButton!
  
  func initView(forSection section: TutorialSection, forTutorial tutorial: Tutorial, action: @escaping () -> ()) {
    self.section = section
    self.tutorial = tutorial
    self.tutorialMessage.text = tutorial.getPhrase(forSection: section)
    nextButtonAction = action
    placeView()
  }
  
  private func placeView() {
    self.frame = tutorial.getLocation(forSection: section)
    self.isHidden = false
  }
  
  override func awakeFromNib() {
    // TODO: create NIB
  }
  
  @IBAction func nextButtonPressed(sender: UIButton!) {
    nextButtonAction()
  }

}
