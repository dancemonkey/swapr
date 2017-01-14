//
//  ExplodeView.swift
//  Swapr
//
//  Created by Drew Lanning on 1/14/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class ExplodeView: UIView {

  private var emitter: CAEmitterLayer!
  
  override class var layerClass: AnyClass {
    return CAEmitterLayer.self
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    emitter = self.layer as! CAEmitterLayer
    emitter.emitterPosition = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
    emitter.emitterSize = self.bounds.size
    emitter.emitterMode = kCAEmitterLayerAdditive
    emitter.emitterShape = kCAEmitterLayerRectangle
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    if self.superview == nil {
      return
    }
    
    let texture: UIImage? = UIImage(named: "particle")
    assert(texture != nil, "particle image not found")
    let emitterCell = CAEmitterCell()
    emitterCell.contents = texture!.cgImage
    emitterCell.name = "cell"
    emitterCell.birthRate = 1000
    emitterCell.lifetime = 0.75
    emitterCell.blueRange = 0.33
    emitterCell.blueSpeed = -0.33
    emitterCell.velocity = 160
    emitterCell.velocityRange = 40
    emitterCell.scaleRange = 0.5
    emitterCell.scaleSpeed = -0.2
    emitterCell.emissionRange = CGFloat(M_PI*2)
    emitter.emitterCells = [emitterCell]
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.disableEmitterCell()
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      self.removeFromSuperview()
    }
    
  }
  
  func disableEmitterCell() {
    emitter.setValue(0, forKeyPath: "emitterCells.cell.birthRate")
  }

}
