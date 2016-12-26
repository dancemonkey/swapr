//
//  ExpandedVC.swift
//  Swapr
//
//  Created by Drew Lanning on 12/2/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import Messages

enum AddLetter: Int {
  case left = 0, right
}

enum MoveType: String {
  case bomb
  case lock
  case swap
  case pass
}

class ExpandedVC: UIViewController {
  
  @IBOutlet weak var endTurn: UIButton!
  @IBOutlet weak var bomb: HelperButton!
  @IBOutlet weak var lock: HelperButton!
  @IBOutlet weak var pass: UIButton!
  @IBOutlet weak var swap: HelperButton!
  @IBOutlet weak var definition: UITextView!
  @IBOutlet var addLetter: [UIButton]!
  @IBOutlet var letters: [LetterButton]!
  @IBOutlet var playerHand: [LetterButton]!
  @IBOutlet weak var currentPlayerScore: UILabel!
  @IBOutlet weak var oppPlayerScore: UILabel!
  @IBOutlet weak var chainScore: UILabel!
  @IBOutlet weak var strikeCount: UILabel!
  
  var message: MSMessage? = nil
  var composeDelegate: ComposeMessageDelegate!
  var game: Game? = nil
  
  var bombing: Bool = false
  var swapping: Bool = false
  var firstLetter: LetterButton? = nil
  var locking: Bool = false
  var playingLetter: Bool = false {
    didSet {
      if playingLetter == false {
        removeAllLetterHighlights()
      }
    }
  }
  var letterToPlay: String = ""
  var addingLetter: Bool = false
  var addLetterTarget: LetterButton!
  
  var basePlayMessage: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    endTurn.isEnabled = false
    
    if message == nil {
      setupNewGame()
    } else {
      setupExistingGame(fromMessage: message!)
    }
    
    setDefinitionView()
    showAddLetterButtons()
  }
  
  func setupNewGame() {
    setupWordView()
    setupPlayerHand()
    setupHelperViews()
    setupScoreViews()
  }
  
  func setupExistingGame(fromMessage message: MSMessage) {
    game = Game(withMessage: message)
    if game!.gameOver {
      presentGameOver(allowNewGame: true, completion: {
        self.game!.resetForNewGame()
        self.setupNewGame()
      })
    }
    setupWordView()
    setupPlayerHand()
    setupHelperViews()
    setupScoreViews()
    if wordIsMaxSize() {
      hideAddLetterButtons()
    }
  }
  
  func setupScoreViews() {
    currentPlayerScore.text = String(describing: game!.currentPlayer.score)
    oppPlayerScore.text = String(describing: game!.oppPlayer.score)
    chainScore.text = String(describing: game!.currentPlayer.chainScore)
    strikeCount.text = "Strikes - \(game!.currentPlayer.strikes)"
  }
  
  func setupWordView() {
    let word = game?.currentWord
    setupLetterViewSize()
    setLettersInLetterView(forWord: (word?.name)!)
    if let lock1 = game!.currentWord?.locked1 {
      lockLetterView(forTag: lock1)
    }
    if let lock2 = game!.currentWord?.locked2 {
      lockLetterView(forTag: lock2)
    }
  }
  
  private func lockLetterView(forTag tag: Int) {
    for letter in letters {
      if letter.tag == tag {
        letter.locked = true
      }
    }
  }
  
  func setupPlayerHand() {
    var hand: String
    if let text = game?.currentPlayer.hand {
      hand = text
    } else {
      hand = (game?.currentPlayer.getStartingHand())!
    }
    for (index, letter) in hand.characters.enumerated() {
      playerHand[index].setImage(UIImage(named: "\(String(letter).uppercased())"), for: .normal)
      playerHand[index].setidentity(to: String(letter))
    }
    for letter in playerHand {
      letter.rotate()
    }
  }
  
  func getVisibleLetterCount() -> Int {
    return letters.reduce(0, { (total, button) -> Int in
      if button.isHidden == false {
        return 1 + total
      } else {
        return total
      }
    })
  }
  
  func setupLetterViewSize() {
    let size = game?.currentWord?.size
    for letter in letters {
      letter.isHidden = false
    }
    resizeLetters(toSize: size!)
  }
  
  func resizeLetters(toSize size: Int) { // WHY PASS IN VALUE, JUST CALL SIZE DIRECTLY?
    if size < getVisibleLetterCount() {
      for index in size..<getVisibleLetterCount() {
        letters[index].isHidden = true
      }
    } else if size > getVisibleLetterCount() {
      for index in getVisibleLetterCount()..<size {
        letters[index].isHidden = false
      }
    }
  }
  
  func setupHelperViews() {
    let helpers = game!.currentPlayer.helpers
    bomb.isEnabled = false
    lock.isEnabled = false
    swap.isEnabled = false
    if helpers.contains(.bomb) {
      bomb.isEnabled = true
    }
    if helpers.contains(.lock) {
      lock.isEnabled = true
    }
    if helpers.contains(.swap) {
      swap.isEnabled = true
    }
    addingLetter = false
    swapping = false
    bombing = false
    locking = false
  }
  
  func setLettersInLetterView(forWord word: String) {
    for (index, letter) in word.characters.enumerated() {
      letters[index].setImage(UIImage(named: "\(String(letter).uppercased())"), for: .normal)
      letters[index].setidentity(to: String(letter))
      letters[index].tag = index
    }
  }
  
  func swapLetters(first: LetterButton, with second: LetterButton) {
    var firstIndex = 0
    var secondIndex = 0
    for (index, letter) in letters.enumerated() {
      if letter == first {
        firstIndex = index
      }
      if letter == second {
        secondIndex = index
      }
    }
    game?.swapLetters(first: first.identity, at: firstIndex, with: second.identity, at: secondIndex)
    setLettersInLetterView(forWord: (game?.currentWord?.name)!)
  }
  
  func disableAllButtons() {
    for letter in letters {
      letter.isEnabled = false
    }
    for letter in playerHand {
      letter.isEnabled = false
    }
    bomb.isEnabled = false
    lock.isEnabled = false
    swap.isEnabled = false
    endTurn.isEnabled = false
    pass.isEnabled = false
  }
  
  @IBAction func endTurnPressed(sender: UIButton) {
    game!.setPlayMessage(to: basePlayMessage)
    composeDelegate.compose(fromGame: game!)
  }
  
  @IBAction func bombPressed(sender:UIButton) {
    if !bombing {
      bombing = true
      disablePlayerHandLetters()
    } else {
      bombing = false
      enablePlayerHandLetters()
    }
  }
  
  @IBAction func lockPressed(sender:UIButton) {
    // tap this to lock a letter forever in the word
    if !locking {
      locking = true
      disablePlayerHandLetters()
    } else {
      locking = false
      enablePlayerHandLetters()
    }
  }
  
  @IBAction func passPressed(sender:UIButton) {
    game?.pass()
    endTurn.isEnabled = true
    endIfGameOver()
  }
  
  func endIfGameOver() {
    if game!.gameIsOver() {
      disableAllButtons()
      presentGameOver(allowNewGame: false, completion: nil)
      // change "send" button to "new game" button for second player, once they see results of game
      // or add gameOver flag to model, and send RESULTS of old game along with the new game that's started
    }
    setupScoreViews()
  }
  
  func presentGameOver(allowNewGame: Bool, completion: (()->())?) {
    let gameOverView = Bundle.main.loadNibNamed("GameOver", owner: self, options: nil)?.last as! GameOverView
    gameOverView.configureView(withGame: game!, allowNewGame: allowNewGame)
    gameOverView.composeDelegate = self.composeDelegate!
    gameOverView.completionClosure = completion
    self.view.addSubview(gameOverView)
    gameOverView.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.height/2)
  }
  
  @IBAction func swapPressed(sender:UIButton) {
    if !swapping {
      swapping = true
      disablePlayerHandLetters()
    } else {
      swapping = false
      enablePlayerHandLetters()
    }
  }
  
  func disablePlayerHandLetters() {
    for letter in playerHand {
      letter.isEnabled = false
    }
  }
  
  func enablePlayerHandLetters() {
    for letter in playerHand {
      letter.isEnabled = true
    }
  }
  
  @IBAction func addLetterPressed(sender:UIButton) {
    if addingLetter == false {
      setupScoreViews()
      addingLetter = true
      if getVisibleLetterCount() == (game?.currentWord?.size)! {
        switch sender.tag {
        case AddLetter.left.rawValue:
          extendLetterView(direction: .left)
        case AddLetter.right.rawValue:
          extendLetterView(direction: .right)
        default: break
        }
      }
    }
    if wordIsMaxSize() {
      hideAddLetterButtons()
    }
  }
  
  func extendLetterView(direction: AddLetter) {
    if game?.playerPlayedTurn() == false {
      game?.addNewLetterSpace(to: direction)
      setupLetterViewSize()
      setLettersInLetterView(forWord: (game?.currentWord?.name)!)
      if direction == .right {
        addLetterTarget = letters[getVisibleLetterCount()-1]
      } else {
        addLetterTarget = letters[0]
      }
    }
  }
  
  func setPlayMessage(forHelper helper: Helper) -> String {
    var playMessage = " used their " + helper.rawValue
    if helper == .bomb || helper == .swap {
      playMessage.append(", and they")
      playMessage.append(setPlayMessage(forWord: (game!.currentWord)!))
    }
    return playMessage
  }
  
  func setPlayMessage(forWord word: Word) -> String {
    return " played \(word.name.uppercased())"
  }
  
  @IBAction func letterPressed(sender: LetterButton) {
    
    defer {
      setupScoreViews()
      setDefinitionView()
    }
    
    if game?.playerPlayedTurn() == false {
      if addingLetter && playingLetter && sender == addLetterTarget {
        game?.replaceLetter(atIndex: sender.tag, withPlayerLetter: letterToPlay)
        playingLetter = false
        setLettersInLetterView(forWord: (game?.currentWord?.name)!)
        setupPlayerHand()
        testIfValidWord()
        basePlayMessage = setPlayMessage(forWord: (game!.currentWord)!)
        disableAllButtons()
      }
      if bombing && sender.locked == false {
        sender.isHidden = true
        bombing = false
        bomb.isEnabled = false
        game?.playHelper(helper: .bomb, forPlayer: (game?.currentPlayer)!)
        game?.rewriteWord(as: visibleWord())
        testIfValidWord()
        basePlayMessage = setPlayMessage(forHelper: .bomb)
        disableAllButtons()
      } else if locking && sender.locked == false {
        sender.locked = true
        locking = false
        lock.isEnabled = false
        game?.playHelper(helper: .lock, forPlayer: (game?.currentPlayer)!)
        game?.lockLetterInWord(at: sender.tag)
        testIfValidWord()
        basePlayMessage = setPlayMessage(forHelper: .lock)
        disableAllButtons()
      } else if swapping && sender.locked == false {
        if firstLetter != nil {
          swapping = false
          swap.isEnabled = false
          swapLetters(first: firstLetter!, with: sender)
          game?.playHelper(helper: .swap, forPlayer: (game?.currentPlayer)!)
          testIfValidWord()
          basePlayMessage = setPlayMessage(forHelper: .swap)
          disableAllButtons()
        }
        if firstLetter == nil {
          firstLetter = sender
        }
      } else if playingLetter && sender.locked == false && !addingLetter {
        game?.replaceLetter(atIndex: sender.tag, withPlayerLetter: letterToPlay)
        playingLetter = false
        setLettersInLetterView(forWord: (game?.currentWord?.name)!)
        setupPlayerHand()
        testIfValidWord()
        basePlayMessage = setPlayMessage(forWord: game!.currentWord!)
        disableAllButtons()
      }
    }
  }
  
  func testIfValidWord() {
    disableAllButtons()
    game!.testIfValid(word: game!.currentWord!) { (validWord) in
      if validWord {
        DispatchQueue.main.async { [unowned self] in
          self.game!.scoreRound()
          self.endTurn.isEnabled = true
          self.setupScoreViews()
        }
      } else if !validWord {
        DispatchQueue.main.async { [unowned self] in
          self.game!.pass()
          self.endTurn.isEnabled = true
          self.endIfGameOver()
          self.setupScoreViews()
        }
      }
    }
  }
  
  func visibleWord() -> String {
    var word = ""
    for letter in letters where letter.isHidden == false {
      word = word + letter.identity
    }
    return word
  }
  
  @IBAction func playerHandLetterPressed(sender: LetterButton) {
    if game?.playerPlayedTurn() == false {
      letterToPlay = sender.identity
      playingLetter = true
    }
  }
  
  func removeAllLetterHighlights() {
    for letter in playerHand {
      letter.layer.borderColor = UIColor.clear.cgColor
    }
  }
  
  func setDefinitionView() {
    let wordList = WordsAPI()
    wordList.fetchDefinition(forWord: (game?.currentWord)!, completion: {
      DispatchQueue.main.async { [unowned self] in
        self.definition.text = self.game?.currentWord?.definition
      }
    })
  }
  
  func wordIsMaxSize() -> Bool {
    if (game?.currentWord?.size)! >= (game?.MAX_WORD_LENGTH)! {
      return true
    }
    return false
  }
  
  func hideAddLetterButtons() {
    for button in addLetter {
      button.isHidden = true
    }
  }
  
  func showAddLetterButtons() {
    for button in addLetter {
      button.isHidden = false
    }
  }
}
