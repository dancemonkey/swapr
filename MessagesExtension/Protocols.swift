//
//  Protocols.swift
//  Swapr
//
//  Created by Drew Lanning on 12/7/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Messages
import Foundation

protocol ExpandViewDelegate {
  func expand(toPresentationStyle presentationStyle: MSMessagesAppPresentationStyle)
  func getPresentationStyle() -> MSMessagesAppPresentationStyle
}

protocol ComposeMessageDelegate {
  func compose(fromGame game: Game)
}

protocol Lockable {
  var locked: Bool { get set }
}

protocol StartNewGame {
  func startNewGame(withWord word: Word)
}


