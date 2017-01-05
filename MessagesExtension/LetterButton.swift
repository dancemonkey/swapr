//
//  LetterButton.swift
//  Swapr
//
//  Created by Drew Lanning on 12/14/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreGraphics

class LetterButton: UIButton, Lockable {
  
  var locked: Bool = false {
    didSet {
      if locked == true {
        glowOn(locked: true)
      }
    }
  }
  
  private var _tapDisabled: Bool = false
  var tapDisabled: Bool {
    return _tapDisabled
  }
  
  private var tapped: Bool = false {
    didSet {
      if tapped == true {
        glowOn(locked: false)
      } else {
        glowOff()
      }
    }
  }
  
  private var _identity: String = ""
  var identity: String {
    return _identity
  }
  
  func tap() {
    if !tapDisabled {
      if tapped {
        self.tapped = false
      } else {
        self.tapped = true
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    glowOff()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    if !locked && tapDisabled == false {
      self.tap()
    }
  }
  
  func disableTap() {
    _tapDisabled = true
  }
  
  func enableTap() {
    _tapDisabled = false
  }
  
  func rotate() {
    let random = Float(arc4random_uniform(16))
    let radians = random * 0.017
    let negative = arc4random_uniform(2) == 1 ? true : false
    if negative {
      self.transform = CGAffineTransform(rotationAngle: CGFloat(-radians))
    } else {
      self.transform = CGAffineTransform(rotationAngle: CGFloat(radians))
    }
  }
  
  func setidentity(to letter: String) {
    _identity = letter
  }
  
  func isTapped() -> Bool {
    return tapped
  }
}
