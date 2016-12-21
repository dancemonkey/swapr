//
//  WordsAPI.swift
//  Swapr
//
//  Created by Drew Lanning on 12/4/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Foundation

class WordsAPI {
  
  let baseURL = "https://wordsapiv1.p.mashape.com/words/"
  let header = ["X-Mashape-Key": "p8jiu8dllpmshOya3mO11qIH01dfp1ZitJLjsnHu4q9CflQbWY", "Accept": "application/json"]
  let STARTER_WORDS = "starterWords"
  
  var word: String? = nil
  
  func fetchDefinition(forWord word: Word, completion: @escaping () -> ()) {
    let endpoint = baseURL + word.name
    let wordsURL = URL(string: endpoint)!
    var request = URLRequest(url: wordsURL)
    request.allHTTPHeaderFields = header
    request.httpMethod = "GET"
    NetworkRequest.get(withRequest: request, completion: { data in
      if let definition = self.getDefinition(fromData: data) {
        word.setDefinition(to: definition)
      }
      completion()
    })
  }
  
  private func getDefinition(fromData data: Data) -> String? {
    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any] {
      if let results = json["results"] {
        if let definitions = results as? [AnyObject] {
          let random = Int(arc4random_uniform(UInt32(definitions.count)))
          let member = random != 0 ? definitions[random-1] : definitions[0]
          return member["definition"] as? String
        }
      }
    }
    return nil
  }
  
  func fetchRandomWord() -> Word? {
    if let path = Bundle.main.path(forResource: STARTER_WORDS, ofType: "txt") {
      do {
        let data = try String(contentsOfFile: path, encoding: .utf8)
        let allWords = data.components(separatedBy: .newlines)
        let random = Int(arc4random_uniform(UInt32(allWords.count)))
        return random != 0 ? Word(fromText: allWords[random-1]) : Word(fromText: allWords[0])
      } catch {
        print(error)
      }
    }
    return nil
  }
  
  func validate(word: String) -> Bool {
    return false
  }
  
  func fetchRandomLetter() -> String {
    let letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    let random = Int(arc4random_uniform(25))
    return letters[random]
  }
  
}
