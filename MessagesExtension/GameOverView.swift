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
  
  @IBAction func sendResults(sender: UIButton!) {
    // need a new flag in model for when you're just sending a game that's finished
    // so the other player can see the results and start a new game
    composeDelegate.compose(fromGame: game)
  }
  
  func configureView(withGame game: Game) {
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
  }
  
}
