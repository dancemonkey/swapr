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
  @IBOutlet weak var skipButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  
  var tutorialSections: [TutorialSection]!
  
  override func viewDidLoad() {
    
    // use static image of game as background for each view (and just fill the screen?)
    
    super.viewDidLoad()
    
    // TODO: decide order of messages
    tutorialSections = [.launch, .letter, .bomb, .lock, .swap, .score, .chain, .word, .done]
    tutorial = Tutorial()
    currentSection = .launch
    initTutorial()
  }
  
  func showTutorialMessage() {
    if let section = currentSection {
      showOverlay(forSection: section)
    } else {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  func nextSection(fromSection section: TutorialSection) -> TutorialSection? {
    let nextIndex = tutorialSections.index(after: tutorialSections.index(of: section)!)
    return nextIndex != 9 ? tutorialSections[nextIndex] : nil
  }
  
  func showOverlay(forSection section: TutorialSection) {
    tutorialView.initView(forSection: section, forTutorial: tutorial)
  }
  
  func initTutorial() {
    tutorialView = Bundle.main.loadNibNamed("TutorialView", owner: self, options: nil)?.last as! TutorialView
    self.view.addSubview(tutorialView)
    tutorialView.initView(forSection: .launch, forTutorial: tutorial)
    tutorialView.center = view.center
    Utils.animateEndWithSpring(tutorialView, withTiming: 1.0, completionClosure: nil)
  }
  
  @IBAction func skipPressed(sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func nextPressed(sender: UIButton!) {
    currentSection = nextSection(fromSection: currentSection)
    self.showTutorialMessage()
  }
  
}
