//
//  HelperButton.swift
//  Swapr
//
//  Created by Drew Lanning on 12/21/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class HelperButton: UIButton {

  private var tapped: Bool = false {
    didSet {
      if tapped == true {
        glowOn(locked: false)
      } else {
        glowOff()
      }
    }
  }
  
  var identity: Helper? {
    switch self.tag {
    case 0:
      return .bomb
    case 1:
      return .lock
    case 2:
      return .swap
    case 3:
      return .pass
    default:
      return nil
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
    layer.borderColor = UIColor.clear.cgColor
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    self.tap()
  }

}
