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
  var size: Int {
    return name.characters.count
  }
  
  init(fromText word: String) {
    self.name = word
  }
  
  mutating func replaceLetter(at index: Int, with letter: String) {
    var chars = name.characters
    let oldLetterIndex = chars.index(chars.startIndex, offsetBy: index)
    chars.remove(at: oldLetterIndex)
    chars.insert(Character(letter), at: oldLetterIndex)
    name = String(chars)
  }
  
  mutating func removeLetter(at index: Int) {
    var chars = name.characters
    let removeIndex = chars.index(chars.startIndex, offsetBy: index)
    chars.remove(at: removeIndex)
    name = String(chars)
  }
  
}
