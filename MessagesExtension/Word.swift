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
  }
  
  mutating func replaceLetter(at index: Int, with letter: String) {
    var chars = name.characters
    let oldLetterIndex = chars.index(chars.startIndex, offsetBy: index)
    chars.remove(at: oldLetterIndex)
    chars.insert(Character(letter), at: oldLetterIndex)
    name = String(chars)
    self._size = name.characters.count
  }
  
}
