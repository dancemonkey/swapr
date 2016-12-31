//
//  utils.swift
//  Swapr
//
//  Created by Drew Lanning on 12/29/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class Utils {
  
  static let buttonTiming = 0.03
  
  static func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
      deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
      execute: closure
    )
  }
  
  static func animateButton(_ view: UIView, withTiming timing: Double, completionClosure: (() -> ())?) {
    UIView.animate(withDuration: timing  ,
                   animations: {
                    view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    },
                   completion: { finish in
                    UIView.animate(withDuration: timing/2){
                      view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }
                    if let closure = completionClosure {
                      closure()
                    }
    })
  }
  
  static func animateEndWithSpring(_ view: UIView, withTiming timing: Double, completionClosure: (() -> ())?) {
    UIView.animate(withDuration: timing, delay: 0.0, usingSpringWithDamping: 3.5, initialSpringVelocity: 10, options: [], animations: {
      view.center = (view.superview?.center)!
    }) { (finished) in
      if let closure = completionClosure {
        closure()
      }
    }
  }
  
}
