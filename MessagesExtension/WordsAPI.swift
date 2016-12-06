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
  //static let MAX_WORD_LENGTH = 6
  let STARTER_WORDS = "starterWords"
  
  var word: String? = nil
  var definition: String? = nil
  
  func fetchDefinition(forWord word: String) -> String? {
    let endpoint = baseURL + word
    let wordsURL = URL(string: endpoint)!
    var request = URLRequest(url: wordsURL)
    request.allHTTPHeaderFields = header
    request.httpMethod = "GET"
    NetworkRequest.get(withRequest: request, completion: { data -> String in
      self.process(data: data)
      return self.definition!
    })
    return "Still fetching definition..."
  }
  
  private func process(data: Data) {
    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any] {
      let results = json["results"] as! [AnyObject]
      for member in results {
        let definition = member["definition"] as? String
        self.definition = definition
      }
    }
  }
  
  func fetchRandomWord() -> String? {
    // FETCH FROM LIST OF CURATED STARTER WORDS
    if let path = Bundle.main.path(forResource: STARTER_WORDS, ofType: "txt") {
      do {
        let data = try String(contentsOfFile: path, encoding: .utf8)
        let allWords = data.components(separatedBy: .newlines)
        let random = Int(arc4random_uniform(UInt32(allWords.count)))
        return allWords[random-1]
      } catch {
        print(error)
        return nil
      }
    }
    print("returning nil")
    return nil
  }
  
  func validate(word: String) -> Bool {
    return false
  }
  
}
