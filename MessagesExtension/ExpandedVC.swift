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

class ExpandedVC: UIViewController {
  
  @IBOutlet weak var endTurn: UIButton!
  @IBOutlet weak var bomb: HelperButton!
  @IBOutlet weak var lock: HelperButton!
  @IBOutlet weak var pass: UIButton!
  @IBOutlet weak var swap: HelperButton!
  @IBOutlet weak var definition: UITextView!
  @IBOutlet var addLetter: [UIButton]!
  @IBOutlet var letters: [LetterButton]!
  @IBOutlet var playerHand: PlayerHand!
  @IBOutlet weak var currentPlayerScore: ScoreIndicator!
  @IBOutlet var strikes: [UILabel]!
  @IBOutlet weak var chainView: ChainView!
  
  var message: MSMessage? = nil
  var composeDelegate: ComposeMessageDelegate!
  var game: Game? = nil
  weak var soundPlayer: Sound!
  
  var bombing: Bool = false {
    didSet {
      if bombing {
        self.swapping = false
        self.locking = false
        bomb.glowOn(locked: false)
        letterGlowOn()
      } else {
        bomb.glowOff()
        letterGlowOff()
      }
    }
  }
  var swapping: Bool = false {
    didSet {
      if swapping {
        self.bombing = false
        self.locking = false
        swap.glowOn(locked: false)
        letterGlowOn()
      } else {
        swap.glowOff()
        letterGlowOff()
        firstLetter = nil
      }
    }
  }
  var locking: Bool = false {
    didSet {
      if locking {
        self.bombing = false
        self.swapping = false
        lock.glowOn(locked: false)
        letterGlowOn()
      } else {
        lock.glowOff()
        letterGlowOff()
      }
    }
  }
  var firstLetter: LetterButton? = nil
  var playingLetter: Bool = false {
    didSet {
      if playingLetter == false && !addingLetter {
        letterGlowOff()
      } else if playingLetter == true && !addingLetter {
        letterGlowOn()
      }
    }
  }
  var letterToPlay: LetterButton!
  var addingLetter: Bool = false
  var addLetterTarget: LetterButton!
  var backgroundGradient: ColorGradient!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    backgroundGradient = ColorGradient(withView: self.view)
    endTurn.isEnabled = false
    
    if message == nil {
      setupNewGame()
    } else {
      setupExistingGame(fromMessage: message!)
    }
    
    game!.testIfValid(word: game!.currentWord!) { (valid) in
      if valid {
        self.setDefinitionView()
      }
    }
    
    showAddLetterButtons()
    
  }
  
  func setupNewGame() {
    setupWordAndScoreViews()
    for strike in strikes {
      strike.textColor = UIColor.clear
    }
    game!.currentWord?.unlockAll()
  }
  
  func setupExistingGame(fromMessage message: MSMessage) {
    game = Game(withMessage: message)
    if game!.gameOver {
      presentGameOver(allowNewGame: true, completion: {
        self.game!.resetForNewGame()
        self.setupNewGame()
        for view in self.view.subviews where view is UIVisualEffectView {
          UIView.animate(withDuration: 0.75, animations: {
            (view as! UIVisualEffectView).alpha = 0.0
          }, completion: { (complete) in
            view.removeFromSuperview()
          })
        }
      })
    } else {
      setupWordAndScoreViews()
      if game!.wordIsMaxSize() {
        hideAddLetterButtons()
      }
    }
  }
  
  func setupWordAndScoreViews() {
    setupWordView()
    setupPlayerHand()
    setupHelperViews()
    setupScoreViews()
  }
  
  func setupScoreViews() {
    currentPlayerScore.text = String(describing: game!.currentPlayer.score) + currentPlayerScore.setIndicatorText(forPlayerScore: game!.currentPlayer.score, andOpponentScore: game!.oppPlayer.score)
//    oppPlayerScore.setIndicatorText(forPlayerScore: game!.currentPlayer.score, andOpponentScore: game!.oppPlayer.score)
    chainView.addChainsToStack(forScore: game!.currentPlayer.chainScore)
    setupStrikeViews()
  }
  
  func setupStrikeViews() {
    for strike in strikes {
      if game!.currentPlayer.strikes > strike.tag {
        strike.textColor = UIColor.red
      }
    }
  }
  
  func setupWordView() {
    let word = game!.currentWord!
    setupLetterViewSize()
    setLettersInLetterView()
    if let lock1 = word.locked1 {
      lockLetterView(forTag: lock1)
    }
    if let lock2 = word.locked2 {
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
    playerHand.player = game!.currentPlayer
    playerHand.setupPlayerHand()
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
  
  // bad name, resize word display or resize letter display or something
  func resizeLetters(toSize size: Int) {
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
  
  func setLettersInLetterView() {
    let word = game!.currentWord!
    for (index, letter) in word.name.characters.enumerated() {
      letters[index].setImage(UIImage(named: "\(String(letter).uppercased())"), for: .normal)
      letters[index].setidentity(to: String(letter))
      letters[index].tag = index
      if let lock1 = word.locked1, lock1 == index {
        letters[index].locked = true
      }
      if let lock2 = word.locked2, lock2 == index {
        letters[index].locked = true
      }
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
    setLettersInLetterView()
    swapping = false
    swap.isEnabled = false
  }
  
  func disableAllButtons() {
    letterGlowOff()
    for letter in letters {
      letter.isEnabled = false
    }
    playerHand.disableAndGlowOff()
    bomb.isEnabled = false  // "disableHelpers" function
    lock.isEnabled = false
    swap.isEnabled = false
    endTurn.isEnabled = false
    pass.isEnabled = false
  }
  
  @IBAction func endTurnPressed(sender: UIButton) {
    Utils.animateButton(sender, withTiming: Utils.buttonTiming) { [unowned self] in
      self.composeDelegate.compose(fromGame: self.game!)
    }
  }

  @IBAction func helperPressed(sender: HelperButton) {
    
    let helper = HelperAsInt(rawValue: sender.tag)!
    
    Utils.animateButton(sender, withTiming: Utils.buttonTiming) { [unowned self] in
      
      if helper != .pass {
        self.soundPlayer.playSound(for: .select)
        if let helper = sender.identity {
          self.switchState(to: helper)
        }
      } else {
        self.presentPassConfirmation(withCompletion: { 
          self.soundPlayer.playSound(for: .strike)
          self.disableAllButtons()
          self.switchState(to: .pass)
          self.removeBlurEffect()
          
        }, cancellation: { 
          self.removeBlurEffect()
          self.pass.glowOff()
        })
      }
    }
    
  }
  
  func switchState(to state: Helper?) {
    if let state = state {
      disablePlayerHandLetters()
      switch state {
      case .bomb:
        if bombing {
          bombing = false
          enablePlayerHandLetters()
        } else {
          bombing = true
        }
      case .lock:
        if locking {
          locking = false
          enablePlayerHandLetters()
        } else {
          locking = true
        }
      case .swap:
        if swapping {
          swapping = false
          enablePlayerHandLetters()
        } else {
          swapping = true
        }
      case .pass:
        self.game?.pass()
        self.disableAllButtons()
        self.endTurn.isEnabled = true
        self.game!.setPlayMessage(forHelper: .pass)
        self.endIfGameOver()
      }
    } else {
      bombing = false
      locking = false
      swapping = false
      enablePlayerHandLetters()
      letterGlowOff()
    }
  }
  
  func endIfGameOver() {
    if game!.gameIsOver() {
      disableAllButtons()
      presentGameOver(allowNewGame: false, completion: nil)
    }
    setupScoreViews()
  }
  
  func presentGameOver(allowNewGame: Bool, completion: (()->())?) {
    self.addBlurEffect()
    let gameOverView = Bundle.main.loadNibNamed("GameOver", owner: self, options: nil)?.last as! GameOverView
    gameOverView.configureView(withGame: game!, allowNewGame: allowNewGame)
    gameOverView.composeDelegate = self.composeDelegate!
    gameOverView.completionClosure = completion
    self.view.addSubview(gameOverView)
    gameOverView.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.height*2)
    Utils.animateEndWithSpring(gameOverView, withTiming: 1.0, completionClosure: nil)
  }
  
  func presentPassConfirmation(withCompletion completion: @escaping () -> (), cancellation: @escaping () -> ()) {
    self.addBlurEffect()
    let passConfirmationView = Bundle.main.loadNibNamed("PassConfirmation", owner: self, options: nil)?.last as! PassConfirmation
    passConfirmationView.completionClosure = completion
    passConfirmationView.cancelClosure = cancellation
    self.view.addSubview(passConfirmationView)
    passConfirmationView.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.height*2)
    Utils.animateEndWithSpring(passConfirmationView, withTiming: 1.0, completionClosure: nil)
  }
  
  func addBlurEffect() {
    UIView.animate(withDuration: 0.05) {
      let blurEffect = UIBlurEffect(style: .light)
      let blurEffectView = UIVisualEffectView(effect: blurEffect)
      blurEffectView.frame = self.view.bounds
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.view.addSubview(blurEffectView)
    }
  }
  
  func removeBlurEffect() {
    for subview in view.subviews where subview is UIVisualEffectView {
      subview.removeFromSuperview()
    }
  }
  
  func disablePlayerHandLetters() {
    playerHand.disableAndGlowOff()
  }
  
  func enablePlayerHandLetters() {
    playerHand.enableAll()
  }
  
  @IBAction func addLetterPressed(sender:UIButton) {
    if addingLetter == false {
      soundPlayer.playSound(for: .select)
      letterGlowOff()
      setupScoreViews()
      disableHelpers()
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
    if game!.wordIsMaxSize() {
      hideAddLetterButtons()
    }
  }
  
  func disableHelpers() {
    bomb.isEnabled = false
    lock.isEnabled = false
    swap.isEnabled = false
    pass.isEnabled = false
  }
  
  func extendLetterView(direction: AddLetter) {
    if game?.playerPlayedTurn() == false {
      game?.addNewLetterSpace(to: direction)
      setupLetterViewSize()
      setLettersInLetterView()
      if direction == .right {
        addLetterTarget = letters[getVisibleLetterCount()-1]
      } else {
        addLetterTarget = letters[0]
      }
      addLetterTarget.whiteGlowOn()
      addLetterTarget.disableTap()
    }
  }
  
  func playLetter(letter: LetterButton, withLetter replacementLetter: LetterButton) {
    game?.replaceLetter(atIndex: letter.tag, withPlayerLetter: replacementLetter.identity)
    playingLetter = false
    cleanupDisplayAndTestForEnd()
    let _ = game!.setPlayMessage(forWord: (game!.currentWord)!)
  }
  
  @IBAction func letterPressed(sender: LetterButton) {
    if game?.playerPlayedTurn() == false {
      if addingLetter && playingLetter && sender == addLetterTarget {
        self.playLetter(letter: sender, withLetter: self.letterToPlay)
        setLettersInLetterView()
      }
      if sender.locked == false {
        if bombing {
          self.playhelper(helper: .bomb, onLetter: sender)
        } else if locking {
          self.playhelper(helper: .lock, onLetter: sender)
        } else if swapping {
          self.playhelper(helper: .swap, onLetter: sender)
        } else if playingLetter && !addingLetter {
          soundPlayer.playSound(for: .select)
          self.playLetter(letter: sender, withLetter: self.letterToPlay)
          setLettersInLetterView()
          let _ = game!.setPlayMessage(forWord: game!.currentWord!)
        } else {
          sender.tap()
          soundPlayer.playSound(for: .select)
        }
      }
    }
  }
  
  func cleanupDisplayAndTestForEnd() {
    setupPlayerHand()
    testIfValidWord()
  }
  
  func playhelper(helper: Helper, onLetter letter: LetterButton?) {
    switch helper {
    case .bomb:
      soundPlayer.playSound(for: .explosion)
      letter?.isHidden = true
      bombing = false
      bomb.isEnabled = false
      game?.rewriteWord(as: visibleWord())
      cleanupDisplayAndTestForEnd()
      game!.playHelper(helper: helper, forPlayer: game!.currentPlayer)
      game!.setPlayMessage(forHelper: helper)
    case .lock:
      soundPlayer.playSound(for: .lock)
      letter?.locked = true
      locking = false
      lock.isEnabled = false
      game?.lockLetterInWord(at: letter!.tag)
      cleanupDisplayAndTestForEnd()
      game!.playHelper(helper: helper, forPlayer: game!.currentPlayer)
      game!.setPlayMessage(forHelper: helper)
    case .swap:
      soundPlayer.playSound(for: .swap)
      if firstLetter == nil {
        letterGlowOff()
        firstLetter = letter
      } else {
        swapLetters(first: firstLetter!, with: letter!)
        cleanupDisplayAndTestForEnd()
        game!.playHelper(helper: helper, forPlayer: game!.currentPlayer)
        game!.setPlayMessage(forHelper: helper)
      }
    case .pass:
      break
    }
  }
  
  func testIfValidWord() {
    disableAllButtons()
    Utils.delay(1.0) {
      self.game!.testIfValid(word: self.game!.currentWord!) { (validWord) in
        if validWord {
          DispatchQueue.main.async { [unowned self] in
            self.game!.scoreRound()
            self.endTurn.isEnabled = true
            self.setupScoreViews()
            self.soundPlayer.playSound(for: .validWord)
            self.setDefinitionView()
          }
        } else if !validWord {
          DispatchQueue.main.async { [unowned self] in
            self.game!.pass()
            self.endTurn.isEnabled = true
            self.endIfGameOver()
            self.setupScoreViews()
            self.soundPlayer.playSound(for: .strike)
          }
        }
      }
    }
  }
  
  func visibleWord() -> String {
    var word = ""
    for (_, letter) in letters.enumerated() where letter.isHidden == false {
      word = word + letter.identity
    }
    return word
  }
  
  @IBAction func playerHandLetterPressed(sender: LetterButton) {
    soundPlayer.playSound(for: .select)
    Utils.animateButton(sender, withTiming: Utils.buttonTiming) { [unowned self] in
      if let currentLetter = self.letterToPlay {
        if currentLetter == sender {
          self.playerHand.glow(all: true, letterToHighlight: nil)
          self.playingLetter = false
          self.letterToPlay = nil
        } else {
          self.playerHand.glow(all: false, letterToHighlight: sender)
          self.letterToPlay = sender
          self.playingLetter = true
        }
      } else {
        self.playerHand.glow(all: false, letterToHighlight: sender)
        self.letterToPlay = sender
        self.playingLetter = true
      }
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
  
  func hideAddLetterButtons() {
    for button in addLetter {
      button.isHidden = true
    }
  }
  
  func showAddLetterButtons() {
    if game!.wordIsMaxSize() == false {
      for button in addLetter {
        button.isHidden = false
      }
    }
  }
  
  func letterGlowOn() {
    for letter in letters where letter.locked == false {
      letter.whiteGlowOn()
    }
  }
  
  func letterGlowOff() {
    for letter in letters where letter.locked == false {
      letter.glowOff()
    }
  }
  
  override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
    backgroundGradient.gl.frame = self.view.bounds
  }
  
}
