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
  var definition: String? {
    return WordsAPI().fetchDefinition(forWord: self.name)
  }
  
  init(word: String) {
    self.name = word
  }
}
