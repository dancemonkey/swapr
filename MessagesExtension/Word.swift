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
  private var _size: Int
  var size: Int {
    return _size
  }
  
  init(fromText word: String) {
    self.name = word
    self._size = word.characters.count
    //self._definition = WordsAPI().fetchDefinition(forWord: word)
  }
  
}
