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
  
//  func outAnimation(up: Bool) {
//    var frame = CGRect()
//    let size = self.frame.size
//    
//    if up {
//      frame = CGRect(x: self.superview!.bounds.width/2-self.bounds.width/2, y: 0 - self.bounds.height, width: size.width, height: size.height)
//    } else {
//      frame = CGRect(x: self.superview!.bounds.width/2-self.bounds.width/2, y: self.superview!.bounds.height*2, width: size.width, height: size.height)
//    }
//    
//    UIView.animate(withDuration: 0.5, animations: {
//      self.frame = frame
//    }) { (complete) in
//      self.removeFromSuperview()
//    }
//  }
  
}
