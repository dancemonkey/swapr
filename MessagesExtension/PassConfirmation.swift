//
//  PassConfirmation.swift
//  Swapr
//
//  Created by Drew Lanning on 1/8/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class PassConfirmation: UIView {
  
  var completionClosure: (()->())?
  var cancelClosure: (()->())?
  
  @IBAction func cancelPressed(sender: UIButton) {
    if let closure = cancelClosure {
      closure()
    }
    outAnimation(up: false)
  }
  
  @IBAction func confirmPressed(sender: UIButton) {
    if let closure = completionClosure {
      closure()
      outAnimation(up: true)
    }
  }
  
}
