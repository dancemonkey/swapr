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
  @IBOutlet var playerHand: [LetterButton]!
  @IBOutlet weak var currentPlayerScore: UILabel!
  @IBOutlet weak var oppPlayerScore: UILabel!
  @IBOutlet var strikes: [UILabel]!
  @IBOutlet weak var chainStack: UIStackView!
  
  var message: MSMessage? = nil
  var composeDelegate: ComposeMessageDelegate!
  var game: Game? = nil
  var soundPlayer: Sound!
  
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
      if playingLetter == false {
        removeAllLetterHighlights()
      } else if playingLetter == true {
        letterGlowOn()
      }
    }
  }
  var letterToPlay: LetterButton!
  var addingLetter: Bool = false
  var addLetterTarget: LetterButton!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    let _ = ColorGradient(withView: self.view)
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
    setupWordView()                       // consolidate this into a function, used again in below
    setupPlayerHand()                     //
    setupHelperViews()                    //
    setupScoreViews()                     //
    removeAllLetterHighlights()           //
    for strike in strikes {
      strike.textColor = UIColor.lightGray
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
      setupWordView()
      setupPlayerHand()
      setupHelperViews()
      setupScoreViews()
      if game!.wordIsMaxSize() {
        hideAddLetterButtons()
      }
    }
  }
  
  func setupScoreViews() {
    currentPlayerScore.text = String(describing: game!.currentPlayer.score)
    oppPlayerScore.text = String(describing: game!.oppPlayer.score)
    addChainsToStack()
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
  
  // create playerHand as a player function and let it do this itself?
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
    letterGlowOff()
    for letter in letters {
      letter.isEnabled = false
    }
    for letter in playerHand {
      letter.isEnabled = false
      letter.glowOff()
    }
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

  @IBAction func helperPressed(sender: UIButton) {
    
    let helper = HelperAsInt(rawValue: sender.tag)!
    
    Utils.animateButton(sender, withTiming: Utils.buttonTiming) { [unowned self] in
      
      if helper != .pass {
        self.soundPlayer.playSound(for: .select)
      } else {
        self.soundPlayer.playSound(for: .strike)
      }
      
      if let helper = self.helperFromInt(int: helper.rawValue) {
        self.switchState(to: helper)
        print(helper)
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
    UIView.animate(withDuration: 0.05) {
      let blurEffect = UIBlurEffect(style: .light)
      let blurEffectView = UIVisualEffectView(effect: blurEffect)
      blurEffectView.frame = self.view.bounds
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.view.addSubview(blurEffectView)
    }
    
    let gameOverView = Bundle.main.loadNibNamed("GameOver", owner: self, options: nil)?.last as! GameOverView
    gameOverView.configureView(withGame: game!, allowNewGame: allowNewGame)
    gameOverView.composeDelegate = self.composeDelegate!
    gameOverView.completionClosure = completion
    self.view.addSubview(gameOverView)
    gameOverView.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.height*2)
    Utils.animateEndWithSpring(gameOverView, withTiming: 1.0, completionClosure: nil)
  }
  
  // subclass player hand and move into there?
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
      soundPlayer.playSound(for: .select)
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
      setLettersInLetterView(forWord: (game?.currentWord?.name)!)
      if direction == .right {
        addLetterTarget = letters[getVisibleLetterCount()-1]
      } else {
        addLetterTarget = letters[0]
      }
    }
  }
  
  // consolidate redundant into functions
  // move any into helper subclass?
  @IBAction func letterPressed(sender: LetterButton) {
    
    if game?.playerPlayedTurn() == false {
      if addingLetter && playingLetter && sender == addLetterTarget {
        game?.replaceLetter(atIndex: sender.tag, withPlayerLetter: letterToPlay.identity)
        playingLetter = false
        setLettersInLetterView(forWord: (game?.currentWord?.name)!)
        setupPlayerHand()
        testIfValidWord()
        game!.setPlayMessage(forWord: (game!.currentWord)!)
        disableAllButtons()
      }
      if bombing && sender.locked == false {
        soundPlayer.playSound(for: .explosion)
        sender.isHidden = true
        bombing = false
        bomb.isEnabled = false
        game?.playHelper(helper: .bomb, forPlayer: (game?.currentPlayer)!)
        game?.rewriteWord(as: visibleWord())
        testIfValidWord()
        game!.setPlayMessage(forHelper: .bomb)
        disableAllButtons()
      } else if locking && sender.locked == false {
        soundPlayer.playSound(for: .lock)
        sender.locked = true
        locking = false
        lock.isEnabled = false
        game?.playHelper(helper: .lock, forPlayer: (game?.currentPlayer)!)
        game?.lockLetterInWord(at: sender.tag)
        testIfValidWord()
        game!.setPlayMessage(forHelper: .lock)
        disableAllButtons()
      } else if swapping && sender.locked == false {
        if firstLetter != nil {
          soundPlayer.playSound(for: .swap)
          swapping = false
          swap.isEnabled = false
          swapLetters(first: firstLetter!, with: sender)
          game?.playHelper(helper: .swap, forPlayer: (game?.currentPlayer)!)
          testIfValidWord()
          game!.setPlayMessage(forHelper: .swap)
          disableAllButtons()
        }
        if firstLetter == nil {
          soundPlayer.playSound(for: .swap)
          firstLetter = sender
        }
      } else if playingLetter && sender.locked == false && !addingLetter {
        soundPlayer.playSound(for: .select)
        game?.replaceLetter(atIndex: sender.tag, withPlayerLetter: letterToPlay.identity)
        playingLetter = false
        setLettersInLetterView(forWord: (game?.currentWord?.name)!)
        setupPlayerHand()
        testIfValidWord()
        game!.setPlayMessage(forWord: game!.currentWord!)
        disableAllButtons()
      } else {
        soundPlayer.playSound(for: .select)
      }
    }
  }
  
  // move most of this into game?
  // will still need closure, but this is being passed almost directly into game anyway
  func testIfValidWord() {
    disableAllButtons()
    Utils.delay(1.5) { 
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
            self.setDefinitionView()
          }
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
    soundPlayer.playSound(for: .select)
    
    Utils.animateButton(sender, withTiming: Utils.buttonTiming) { [unowned self] in
      if let currentLetter = self.letterToPlay {
        if currentLetter == sender {
          currentLetter.glowOff()
          self.playingLetter = false
        } else {
          currentLetter.glowOff()
          self.letterToPlay = sender
          self.playingLetter = true
        }
      } else {
        self.letterToPlay = sender
        self.playingLetter = true
      }
    }
  }
  
  func removeAllLetterHighlights() {
    for letter in playerHand {
      letter.layer.borderColor = UIColor.clear.cgColor
    }
    letterGlowOff()
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
  
  // subclass entire chain as a UIView with UIImage subview?
  // let it handle this shit
  func addChainsToStack() {
    for chain in chainStack.subviews {
      chain.removeFromSuperview()
    }
    let totalChainsToFit = (Double(view.bounds.width)/16).rounded()
    for index in 0 ..< Int(totalChainsToFit) {
      let chain: UIImageView
      if game!.currentPlayer.chainScore > index {
        chain = UIImageView(image: #imageLiteral(resourceName: "Chain"))
      } else {
        chain = UIImageView(image: #imageLiteral(resourceName: "GrayChain"))
      }
      chain.tag = index
      chainStack.addArrangedSubview(chain)
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
  
  func helperFromInt(int: Int) -> Helper? {
    switch int {
    case 0:
      return .bomb
    case 1:
      return .lock
    case 2:
      return .swap
    case 3:
      return .pass
    default:
      return nil
    }
  }
  
}
