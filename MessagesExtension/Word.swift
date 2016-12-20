//
//  Word.swift
//  Swapr
//
//  Created by Drew Lanning on 12/5/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Foundation

class Word {
  
  var name: String
  private var _definition: String? = nil
  var definition: String? {
    return self._definition
  }
  
  var size: Int {
    return name.characters.count
  }
  
  private var _locked1: Int? = nil
  var locked1: Int? {
    return _locked1
  }
  private var _locked2: Int? = nil
  var locked2: Int? {
    return _locked2
  }
  
  init(fromText word: String) {
    self.name = word
  }
  
  func replaceLetter(at index: Int, with letter: String) {
    var chars = name.characters
    let oldLetterIndex = chars.index(chars.startIndex, offsetBy: index)
    chars.remove(at: oldLetterIndex)
    chars.insert(Character(letter), at: oldLetterIndex)
    name = String(chars)
  }
  
  func removeLetter(at index: Int) {
    var chars = name.characters
    let removeIndex = chars.index(chars.startIndex, offsetBy: index)
    chars.remove(at: removeIndex)
    name = String(chars)
  }
  
  func lockLetter(at index: Int) {
    if _locked1 != nil {
      _locked2 = index
    } else {
      _locked1 = index
    }
  }
  
  func setDefinition(to definition: String) {
    self._definition = definition
  }
  
}
