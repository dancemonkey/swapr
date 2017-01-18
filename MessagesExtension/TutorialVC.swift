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
  
  override func viewDidLoad() {
    
    // this VC should only be initialized if the player requests it (via switch on compact view?)

    super.viewDidLoad()
    tutorial = Tutorial()
    currentSection = .launch
  }
  
  func startTutorial() {
    removeOverlays()
    currentSection = nextSection(fromSection: currentSection)
    showOverlay(forSection: currentSection)
  }
  
  func removeOverlays() {
    // remove all existing overlays
  }
  
  func nextSection(fromSection section: TutorialSection) -> TutorialSection {
    // return the next section that should be displayed here
    return .letter // temp, obv
  }
  
  func showOverlay(forSection section: TutorialSection) {
    // initialize and show a view here that has verbiage from the tutorial model
    // also dim main view and highlight the element being explained?  }
}
