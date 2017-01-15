//
//  ColorGradient.swift
//  Swapr
//
//  Created by Drew Lanning on 12/28/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Foundation
import UIKit

class ColorGradient {
  
  let colorTop = UIColor.white.cgColor
  let colorBottom = UIColor(red: 113.0/255.0, green: 192.0/255.0, blue: 240.0/255.0, alpha: 1.0).cgColor
  
  var gl: CAGradientLayer!
  
  init(withView view: UIView) {
    setGradient(withView: view)
  }
  
  func setGradient(withView view: UIView) {
    gl = CAGradientLayer()
    gl.colors = [colorBottom, colorTop]
    gl.locations = [0.0, 1.0]
    view.backgroundColor = UIColor.clear
    gl.frame = view.frame
    view.layer.insertSublayer(gl, at: 0)
  }
  
  func setBottomLocation(forValue value: Float) {
    self.gl.locations![1] = NSNumber(value: value)
  }
  
  func setTopLocation(forValue value: Float) {
    self.gl.locations![0] = NSNumber(value: value)
  }
  
  func setColor(top: UIColor?, bottom: UIColor?) {
    if let color = top {
      gl.colors![0] = color.cgColor
    }
    if let color = bottom {
      gl.colors![1] = color.cgColor
    }
  }
  
  func drain(bottomValue value: Float) {
    self.gl.locations![1] = NSNumber(value: value)
  }
  
}
