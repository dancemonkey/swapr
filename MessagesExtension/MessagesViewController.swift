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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
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
      print("found message in convo and url in message")
      if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false) {
        print("found components in url")
        if let queryItems = components.queryItems {
          if queryItems[0].name.contains("currentWord") {
            print("assigning message to expandedVC")
            vc.message = message
          }
        }
      }
    }
    
    vc.composeDelegate = self
    
    return vc
  }
  
  private func instantiateCompactVC() -> UIViewController {
    guard let compactVC = storyboard?.instantiateViewController(withIdentifier: "CompactVC") as? CompactVC else {
      fatalError("Can't make a CompactVC")
    }
    
    compactVC.expandViewDelegate = self
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
    // Called after the extension transitions to a new presentation style.
    
    // Use this method to finalize any behaviors associated with the change in presentation style.
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
    layout.caption = "$\(convo.localParticipantIdentifier) played \((game.currentWord!.name))"
    // layout.image = UIImage(named: "msgBackground")
    
    let message = MSMessage(session: session)
    message.layout = layout
    
    var components = URLComponents()
    let currentWord = URLQueryItem(name: "currentWord", value: "\(game.currentWord!.name)")
    let oppPlayerHand = URLQueryItem(name: "oppPlayerHand", value: "\(game.currentPlayer.hand!)")
    let currentPlayerHand = URLQueryItem(name: "currentPlayerHand", value: "\(game.oppPlayer.hand!)")
    let oppPlayerScore = URLQueryItem(name: "oppPlayerScore", value: "\(game.currentPlayer.score)")
    let currentPlayerScore = URLQueryItem(name: "currentPlayerScore", value: "\(game.oppPlayer.score)")
    let oppPlayerHelpers = URLQueryItem(name: "oppPlayerHelpers", value: "\(game.currentPlayer.helpers)")
    let currentPlayerHelpers = URLQueryItem(name: "currentPlayerHelpers", value: "\(game.oppPlayer.helpers)")
    let priorPlayerPassed = URLQueryItem(name: "priorPlayerPassed", value: "\(game.currentPlayerPassed.description)")
    let oppChainScore = URLQueryItem(name: "oppChainScore", value: "\(game.currentPlayer.chainScore)")
    let currentChainScore = URLQueryItem(name: "currentChainScore", value: "\(game.oppPlayer.chainScore)")

    components.queryItems = [currentWord, oppPlayerHand, currentPlayerHand, oppPlayerScore, currentPlayerScore, oppPlayerHelpers, currentPlayerHelpers, priorPlayerPassed, oppChainScore, currentChainScore]
    
    message.summaryText = "Your opponent played \((game.currentWord!.name))."
    
    message.url = components.url
    print("-------BUILT MESSAGE--------")
    print(message.url?.dataRepresentation)
    print(message.url?.absoluteString)
    
    convo.insert(message) { (error) in
      guard error == nil else {
        print(error.debugDescription)
        print(error?.localizedDescription)
        fatalError()
      }
    }
    
    dismiss()
  }
}
