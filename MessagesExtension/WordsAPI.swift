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
    let endpoint = baseURL + word.name + "/definitions"
    let wordsURL = URL(string: endpoint)!
    var request = URLRequest(url: wordsURL)
    request.allHTTPHeaderFields = header
    request.httpMethod = "GET"
    NetworkRequest.get(withRequest: request, completion: { data in
      if let definition = self.getDefinition(fromData: data) {
        word.setDefinition(to: definition)
      } else {
        word.setDefinition(to: "")
      }
      completion()
    })
  }
  
  private func getDefinition(fromData data: Data) -> String? {
    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any] {
      if let definitions = json["definitions"] as? [AnyObject] {
        if definitions.count > 0 {
          let random = Int(arc4random_uniform(UInt32(definitions.count-1)))
          let def = definitions[random]
          return def["definition"] as? String
        }
      }
//      if let results = json["results"] {
//        if let definitions = results as? [AnyObject] {
//          print(definitions)
//          let random = Int(arc4random_uniform(UInt32(definitions.count)))
//          let member = random != 0 ? definitions[random-1] : definitions[0]
//          return member["definition"] as? String
//        }
//      }
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
    let randomConsonant = Int(arc4random_uniform(20))
    let randomVowel = Int(arc4random_uniform(4))
    var pullVowel: Bool {
      return Int(arc4random_uniform(2)) < 1
    }
    
    let letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    let consonants = ["b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z"]
    let vowels = letters.filter { (letter) -> Bool in
      return !consonants.contains(letter)
    }
    if pullVowel {
      return vowels[randomVowel]
    } else {
      return consonants[randomConsonant]
    }
  }
  
}
