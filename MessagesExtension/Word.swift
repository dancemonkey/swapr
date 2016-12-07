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
  private var _definition: String? = nil
  var definition: String? {
    return self._definition
  }
  
  init(word: String) {
    self.name = word
    self.setDefinition(forWord: word)
  }
  
  private mutating func setDefinition(forWord word: String) {
    self._definition = WordsAPI().fetchDefinition(forWord: word)!
  }
}
