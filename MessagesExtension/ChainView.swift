//
//  ChainView.swift
//  Swapr
//
//  Created by Drew Lanning on 1/7/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class ChainView: UIView {
  
  @IBOutlet weak var chainStack: UIStackView!
  
  func addChainsToStack(forScore score: Int) {
    for chain in chainStack.subviews {
      chain.removeFromSuperview()
    }
    let totalChainsToFit = (Double(superview!.bounds.width)/16).rounded()
    for index in 0 ..< Int(totalChainsToFit) {
      let chain: UIImageView
      if score > index {
        chain = UIImageView(image: #imageLiteral(resourceName: "Chain"))
      } else {
        chain = UIImageView(image: nil)
      }
      chain.tag = index
      chainStack.addArrangedSubview(chain)
    }
  }

}
