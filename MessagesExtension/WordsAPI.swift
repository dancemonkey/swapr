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
  
  func fetchWordData(forWord word: String) {
    let endpoint = baseURL + word
    let wordsURL = URL(string: endpoint)!
    var request = URLRequest(url: wordsURL)
    print(wordsURL)
    request.allHTTPHeaderFields = header
    request.httpMethod = "GET"
    let task = URLSession.shared.dataTask(with: request, completionHandler: {data , response, error in
      guard error == nil else {
        return
      }
      if let data = data, let response = response as? HTTPURLResponse {
        if response.statusCode == 200 {
          self.process(data: data)
        } else {
          // handle error here
        }
      }
      
    })
    task.resume()
  }
  
  private func process(data: Data) {
    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as Any {
      print(json)
    }
  }
  
  // functions below should take the payload from the fetch,
  // then parse it for whatever is being sought: 
  // - definition
  // - synonyms
  // - part of speech, etc.
  // The API may already offer this in a simple way, in which case great, these functions become wrappers
  // for the API requests
  
  // What else would we need? Maybe add a bunch and if we don't use then we don't use?
  
}
