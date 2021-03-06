//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Drew Lanning on 12/2/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
  
  var startingGame: Game?
  var soundPlayer = Sound()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  private func presentVC(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
    
    var controller: UIViewController
    
    if presentationStyle == .compact {
      controller = instantiateCompactVC()
    } else {
      controller = instantiateExpandedVC(forConversation: conversation)
    }
    
    for child in childViewControllers {
      child.willMove(toParentViewController: nil)
      child.view.removeFromSuperview()
      child.removeFromParentViewController()
    }
    
    addChildViewController(controller)
    
    controller.view.frame = view.bounds
    controller.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(controller.view)
    
    controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
    controller.didMove(toParentViewController: self)
  }
  
  private func instantiateExpandedVC(forConversation conversation: MSConversation) -> UIViewController {
    guard let vc = storyboard?.instantiateViewController(withIdentifier: "gameScreen") as? ExpandedVC else {
      fatalError("VC not found.")
    }
        
    if let message = conversation.selectedMessage, let url = message.url {
      if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false) {
        if let queryItems = components.queryItems {
          if queryItems[0].name.contains("currentWord") {
            vc.message = message
            vc.currentUser = conversation.localParticipantIdentifier.uuidString
          }
        }
      }
    }
    
    vc.composeDelegate = self
    
    if let game = startingGame {
      vc.game = game
    } else {
      let wordList = WordsAPI()
      self.startingGame = Game(withMessage: nil)
      startingGame?.setCurrentWord(to: wordList.fetchRandomWord()!)
      vc.game = startingGame!
    }
    vc.soundPlayer = soundPlayer
    
    return vc
  }
  
  private func instantiateCompactVC() -> UIViewController {
    guard let compactVC = storyboard?.instantiateViewController(withIdentifier: "CompactVC") as? CompactVC else {
      fatalError("Can't make a CompactVC")
    }
    
    compactVC.newGameDelegate = self
    compactVC.soundPlayer = soundPlayer
    return compactVC
  }
  
  // MARK: - Conversation Handling
  
  override func willBecomeActive(with conversation: MSConversation) {
    presentVC(for: conversation, with: presentationStyle)
  }
  
  override func didResignActive(with conversation: MSConversation) {
    // Called when the extension is about to move from the active to inactive state.
    // This will happen when the user dissmises the extension, changes to a different
    // conversation or quits Messages.
    
    // Use this method to release shared resources, save user data, invalidate timers,
    // and store enough state information to restore your extension to its current state
    // in case it is terminated later.
  }
  
  override func didReceive(_ message: MSMessage, conversation: MSConversation) {
    // Called when a message arrives that was generated by another instance of this
    // extension on a remote device.
    
    // Use this method to trigger UI updates in response to the message.
  }
  
  override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
    // Called when the user taps the send button.
  }
  
  override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
    // Called when the user deletes the message without sending it.
    
    // Use this to clean up state related to the deleted message.
  }
  
  override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
    guard let conversation = activeConversation else {
      fatalError("No active conversation or something")
    }
    presentVC(for: conversation, with: presentationStyle)
  }
  
  override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
    if startingGame != nil && presentationStyle == .compact {
      startingGame = nil
    }
  }
  
  override func didSelect(_ message: MSMessage, conversation: MSConversation) {
    guard let conversation = activeConversation else {
      fatalError("No active conversation or something")
    }
    presentVC(for: conversation, with: presentationStyle)
  }
  
}

extension MessagesViewController: ExpandViewDelegate {
  func expand(toPresentationStyle presentationStyle: MSMessagesAppPresentationStyle) {
    requestPresentationStyle(presentationStyle)
  }
  func getPresentationStyle() -> MSMessagesAppPresentationStyle {
    return self.presentationStyle
  }
}

extension MessagesViewController: ComposeMessageDelegate {
  
  func compose(fromGame game: Game) {
    
    let convo = activeConversation ?? MSConversation()
    let session = convo.selectedMessage?.session ?? MSSession()
    
    let layout = MSMessageTemplateLayout()
    layout.caption = "$\(convo.localParticipantIdentifier)" + game.playMessage
    layout.image = UIImage(named: "layoutImage")
    
    let message = MSMessage(session: session)
    message.layout = layout
    
    var components = URLComponents()
    let currentWord = URLQueryItem(name: "currentWord", value: "\(game.currentWord!.name)")
    let oppPlayerHand = URLQueryItem(name: "oppPlayerHand", value: "\(game.currentPlayer.hand!)")
    let currentPlayerHand = URLQueryItem(name: "currentPlayerHand", value: "\(game.oppPlayer.hand!)")
    let oppPlayerScore = URLQueryItem(name: "oppPlayerScore", value: "\(game.currentPlayer.score)")
    let currentPlayerScore = URLQueryItem(name: "currentPlayerScore", value: "\(game.oppPlayer.score)")
    let oppPlayerHelpers = URLQueryItem(name: "oppPlayerHelpers", value: "\(game.currentPlayer.getHelperTextString())")
    let currentPlayerHelpers = URLQueryItem(name: "currentPlayerHelpers", value: "\(game.oppPlayer.getHelperTextString())")
    let oppChainScore = URLQueryItem(name: "oppChainScore", value: "\(game.currentPlayer.chainScore)")
    let currentChainScore = URLQueryItem(name: "currentChainScore", value: "\(game.oppPlayer.chainScore)")
    let gameOver = URLQueryItem(name: "gameOver", value: "\(game.gameOver)")
    let drawnTiles = URLQueryItem(name: "drawnTiles", value: "\(game.tilesDrawn)")
    let lastUserToOpen = URLQueryItem(name: "lastUserToOpen", value: convo.localParticipantIdentifier.uuidString)

    components.queryItems = [currentWord, oppPlayerHand, currentPlayerHand, oppPlayerScore, currentPlayerScore, oppPlayerHelpers, currentPlayerHelpers, oppChainScore, currentChainScore, gameOver, drawnTiles, lastUserToOpen]
    
    if let lock1 = game.currentWord!.locked1 {
      print("writing lock letter 1")
      let lockedLetterPos1 = URLQueryItem(name: "lockedLetterPos1", value: "\(lock1)")
      components.queryItems?.append(lockedLetterPos1)
    }
    if let lock2 = game.currentWord!.locked2 {
      print("writing lock letter 2")
      let lockedLetterPos2 = URLQueryItem(name: "lockedLetterPos1", value: "\(lock2)")
      components.queryItems?.append(lockedLetterPos2)
    }
    
    message.summaryText = "$\(convo.localParticipantIdentifier)" + game.playMessage
    
    message.url = components.url
    
    convo.insert(message) { (error) in
      guard error == nil else {
        fatalError()
      }
    }
    
    dismiss()
  }
}

extension MessagesViewController: StartNewGame {
  func startNewGame(withWord word: Word) {
    self.startingGame = Game(withMessage: nil)
    startingGame?.setCurrentWord(to: word)
    requestPresentationStyle(.expanded)
  }
}
