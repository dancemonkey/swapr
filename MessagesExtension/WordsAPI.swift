//
//  WordsAPI.swift
//  Swapr
//
//  Created by Drew Lanning on 12/4/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Foundation

class WordsAPI {
  static let sharedInstance = WordsAPI()
  
  private func fetch(word: String) -> Bool? {
    // this will eventually return the JSON dict from the WordsAPI
    return false
  }
  
  // functions below should take the payload from the fetch,
  // then parse it for whatever is being sought: 
  // - definition
  // - synonyms
  // - part of speech, etc.
  // The API may already offer this in a simple way, in which case great, these functions become wrappers
  // for the API requests
  
  func definition(ofWord word: String) -> String? {
    var def: String? = nil
    // network request for the passed word
    return def
  }
  
  // What else would we need? Maybe add a bunch and if we don't use then we don't use?
  
}
