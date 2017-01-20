//
//  TutorialVC.swift
//  Swapr
//
//  Created by Drew Lanning on 1/18/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class TutorialVC: UIViewController {
  
  // TODO: landscape image telling you to rotate to portrait
  
  var tutorial: Tutorial!
  var currentSection: TutorialSection!
  
  @IBOutlet weak var tutorialView: TutorialView!
  
  var tutorialSections: [TutorialSection]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tutorialSections = [.launch, .letter, .word, .bomb, .lock, .swap, .score, .chain, .done]
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
  
  func previousSection(fromSection section: TutorialSection) -> TutorialSection? {
    let previousIndex = tutorialSections.index(before: tutorialSections.index(of: section)!)
    return tutorialSections.index(of: section)! != 0 ? tutorialSections[previousIndex] : nil
  }
  
  func showOverlay(forSection section: TutorialSection) {
    tutorialView.initView(forSection: section, forTutorial: tutorial, forSize: view.bounds)
  }
  
  func initTutorial() {
    tutorialView = Bundle.main.loadNibNamed("TutorialView", owner: self, options: nil)?.last as! TutorialView
    self.view.addSubview(tutorialView)
    tutorialView.center = view.center
    tutorialView.initView(forSection: .launch, forTutorial: tutorial, forSize: view.bounds)
    Utils.animateEndWithSpring(tutorialView, withTiming: 1.0, completionClosure: nil)
    addSwipes()
  }
  
  private func previousScreen() {
    currentSection = previousSection(fromSection: currentSection)
    self.showTutorialMessage()
  }
  
  private func nextScreen() {
    currentSection = nextSection(fromSection: currentSection)
    self.showTutorialMessage()
  }
  
  private func dismissTutorial() {
    self.dismiss(animated: true, completion: nil)
  }
  
  func addSwipes() {
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipe(gesture:)))
    swipeRight.direction = .right
    self.view.addGestureRecognizer(swipeRight)
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipe(gesture:)))
    swipeLeft.direction = .left
    self.view.addGestureRecognizer(swipeLeft)
    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipe(gesture:)))
    swipeDown.direction = .down
    self.view.addGestureRecognizer(swipeDown)
  }
  
  func respondToSwipe(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      switch swipeGesture.direction {
      case UISwipeGestureRecognizerDirection.left:
        nextScreen()
      case UISwipeGestureRecognizerDirection.right:
        previousScreen()
      case UISwipeGestureRecognizerDirection.down:
        dismissTutorial()
      default:
        break
      }
    }
  }
  
}
