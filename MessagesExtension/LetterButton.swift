//
//  LetterButton.swift
//  Swapr
//
//  Created by Drew Lanning on 12/14/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class LetterButton: UIButton, Lockable {
  
  var locked: Bool = false {
    didSet {
      if locked == true {
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 2.0
      }
    }
  }
  
  private var tapped: Bool = false {
    didSet {
      if tapped == true {
        layer.borderColor = UIColor.green.cgColor
        layer.borderWidth = 2.0
      } else {
        layer.borderColor = UIColor.clear.cgColor
      }
    }
  }
  
  private var _identity: String = ""
  var identity: String {
    return _identity
  }
  
  func tap() {
    if tapped {
      self.tapped = false
    } else {
      self.tapped = true
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.borderColor = UIColor.clear.cgColor
    layer.borderWidth = 2.0
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    self.tap()
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
  
}
