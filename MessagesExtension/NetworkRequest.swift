//
//  NetworkRequest.swift
//  Swapr
//
//  Created by Drew Lanning on 12/6/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Foundation

class NetworkRequest {
  
  static func get(withRequest request: URLRequest, completion: @escaping (Data)->(String)) {
    let task = URLSession.shared.dataTask(with: request, completionHandler: {data , response, error in
      guard error == nil else {
        return
      }
      if let data = data, let response = response as? HTTPURLResponse {
        if response.statusCode == 200 {
          _ = completion(data)
        } else {
          // handle error here
        }
      }
      
    })
    task.resume()
  }
  
}
