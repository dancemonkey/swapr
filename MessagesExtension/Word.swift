//
//  Word.swift
//  Swapr
//
//  Created by Drew Lanning on 12/5/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Foundation

struct Word {
  var name: String
  var definition: [String: String]
  
  init(withJSON json: [String: AnyObject]) {
    // parse json passed in and populate the name and definition of word?
    // I feel like instead this word should make a network call via a network class
    // and then parse the results
  }
}
