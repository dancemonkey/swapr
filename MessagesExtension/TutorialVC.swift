//
//  TutorialVC.swift
//  Swapr
//
//  Created by Drew Lanning on 1/18/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class TutorialVC: UIViewController {
  
  var tutorial: Tutorial!
  var currentSection: TutorialSection!
  
  @IBOutlet weak var tutorialView: TutorialView!
  
  var tutorialSections: [TutorialSection]!
  
  override func viewDidLoad() {
    
    // TODO: initialize this VC from main screen if requested
    // use static image of game as background for each view (and just fill the screen?)
    
    super.viewDidLoad()
    
    // TODO: decide order of messages
    tutorialSections = [.launch, .letter, .bomb, .lock, .swap, .score, .chain, .word]
    tutorial = Tutorial()
    currentSection = .launch
    showTutorialMessage()
  }
  
  func showTutorialMessage() {
    showOverlay(forSection: currentSection)
  }
  
  func removeOverlays() {
    // remove all existing overlays
    // maybe not needed, using only one
  }
  
  func nextSection(fromSection section: TutorialSection) -> TutorialSection {
    let nextIndex = tutorialSections.index(after: tutorialSections.index(of: section)!)
    return tutorialSections[nextIndex]
  }
  
  func showOverlay(forSection section: TutorialSection) {
    tutorialView.initView(forSection: section, forTutorial: tutorial, action: {
      self.currentSection = self.nextSection(fromSection: section)
      self.showTutorialMessage()
    })
  }
}
