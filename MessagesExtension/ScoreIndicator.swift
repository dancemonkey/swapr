//
//  ScoreIndicator.swift
//  Swapr
//
//  Created by Drew Lanning on 1/11/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class ScoreIndicator: UILabel {

  func setIndicatorText(forPlayerScore pScore: Int, andOpponentScore oScore: Int) -> String {
    if pScore == oScore {
      self.textColor = UIColor.black
      return ""
    } else if pScore > oScore {
      self.textColor = UIColor.green
      return " +"
    } else {
      self.textColor = UIColor.red
      return " -"
    }
  }

}
