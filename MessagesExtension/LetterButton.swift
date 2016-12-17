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
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2.0
      }
    }
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
    layer.borderColor = UIColor.black.cgColor
    layer.borderWidth = 2.0
  }
  
}
