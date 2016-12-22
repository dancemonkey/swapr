//
//  GameOverView.swift
//  Swapr
//
//  Created by Drew Lanning on 12/22/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class GameOverView: UIView {

  @IBOutlet weak var winOrLose: UILabel!
  @IBOutlet weak var winnerScore: UILabel!
  @IBOutlet weak var loserScore: UILabel!
  @IBOutlet weak var sendResults: UIButton!
  
  var composeDelegate: ComposeMessageDelegate!
  private var game: Game!
  var completionClosure: (()->())?
  
  @IBAction func sendResults(sender: UIButton!) {
    if let closure = completionClosure {
      closure()
      removeFromSuperview()
    } else {
      composeDelegate.compose(fromGame: game)
    }
  }
  
  @IBAction func startNewGame(sender: UIButton) {
    if let completion = completionClosure {
      completion()
    }
    self.removeFromSuperview()
  }
  
  func configureView(withGame game: Game, allowNewGame: Bool) {
    self.game = game
    let winner = game.currentPlayer.score > game.oppPlayer.score ? game.currentPlayer : game.oppPlayer
    let loser = game.currentPlayer.score > game.oppPlayer.score ? game.oppPlayer : game.currentPlayer
    let winnerVerbiage = (winner === game.currentPlayer) ? "You " : "They "
    
    if winner.score == loser.score {
      winOrLose.text = "We have a tie!"
    }
    
    winOrLose.text = winnerVerbiage + "won!"
    winnerScore.text = "Winner - \(winner.score) points"
    loserScore.text = "Loser - \(loser.score) points"
    
    if allowNewGame {
      sendResults.setTitle("Start new game", for: .normal)
    } else {
      sendResults.setTitle("Send results", for: .normal)
    }
    
  }
  
}
