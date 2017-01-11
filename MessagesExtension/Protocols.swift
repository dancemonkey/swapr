//
//  Protocols.swift
//  Swapr
//
//  Created by Drew Lanning on 12/7/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Messages
import Foundation

protocol ExpandViewDelegate {
  func expand(toPresentationStyle presentationStyle: MSMessagesAppPresentationStyle)
  func getPresentationStyle() -> MSMessagesAppPresentationStyle
}

protocol ComposeMessageDelegate {
  func compose(fromGame game: Game)
}

protocol Lockable {
  var locked: Bool { get set }
}

protocol StartNewGame {
  func startNewGame(withWord word: Word)
}

extension UIButton {
  func glowOn(locked: Bool) {
    if locked {
      layer.shadowColor = UIColor.red.cgColor
    } else {
      layer.shadowColor = UIColor.green.cgColor
    }
    layer.shadowRadius = 4.0
    layer.shadowOpacity = 0.9
    layer.shadowOffset = CGSize.zero
    layer.masksToBounds = false
  }
  
  func whiteGlowOn() {
    glowOn(locked: false)
    layer.shadowColor = UIColor.white.cgColor
  }
  
  func glowOff() {
    layer.shadowColor = UIColor.clear.cgColor
  }
}

extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
  
  func outAnimation(up: Bool) {
    var frame = CGRect()
    let size = self.frame.size
    
    if up {
      frame = CGRect(x: self.superview!.bounds.width/2-self.bounds.width/2, y: 0 - self.bounds.height, width: size.width, height: size.height)
    } else {
      frame = CGRect(x: self.superview!.bounds.width/2-self.bounds.width/2, y: self.superview!.bounds.height*2, width: size.width, height: size.height)
    }
    
    UIView.animate(withDuration: 0.5, animations: {
      self.frame = frame
    }) { (complete) in
      self.removeFromSuperview()
    }
  }
  
}

