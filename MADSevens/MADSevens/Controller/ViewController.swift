//
//  ViewController.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import UIKit

class MADSevensViewController: UIViewController {
    
    public var game = MADSevens()
    
    @IBOutlet private var playerCardView: [PlayingCardView]!
    @IBOutlet private var modelCardView: [ModelCardView]!
    @IBOutlet private var discardCardView: CardInPlayView!
    @IBOutlet private var DeckView: [DeckView]!
    @IBOutlet weak var playerStack: UIStackView!
    @IBOutlet weak var modelStack: UIStackView!
    @IBOutlet weak var ColorLabel: UILabel!
    @IBOutlet weak var ColorChoiceStack: UIStackView!
    @IBOutlet weak var DrawCardButton: UIButton!
    @IBOutlet weak var EndTurnButton: UIButton!
    @IBOutlet weak var ChangeColorPumpkins: UIButton!
    @IBOutlet weak var ChangeColorLeaves: UIButton!
    @IBOutlet weak var ChangeColorHearts: UIButton!
    @IBOutlet weak var ChangeColorAcorn: UIButton!
    @IBOutlet weak var PlayerWinsLabel: UILabel!
    @IBOutlet weak var ModelWinsLabel: UILabel!
    @IBOutlet weak var LeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var TrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var ModelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var ModelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var BackModelWins: UIButton!
    @IBOutlet weak var BackPlayerWins: UIButton!
    @IBOutlet weak var LandscapePlayerConstraint: NSLayoutConstraint!
    @IBOutlet weak var LandscapeModelConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let playerCards = game.getPlayerHand()
        let modelCards = game.getModelHand()
        let discardCard = game.getTopDiscardCard()
        print("This is a dicard card \(discardCard)")
        
        // display the dealt cards for the player
        for i in 0 ..< playerCards.count {
            playerCardView[i].isFaceUp = true
            playerCardView[i].setRank(newRank: playerCards[i].getRank())
            playerCardView[i].setSuit(newSuit: playerCards[i].getSuit())
        }
        // display the dealt cards for the model
        for i in 0 ..< modelCards.count {
            modelCardView[i].isFaceUp = false
            modelCardView[i].setRank(newRank: modelCards[i].getRank())
            modelCardView[i].setSuit(newSuit: modelCards[i].getSuit())
        }
        
        // set constraints
        LeadingConstraint.constant = 8
        TrailingConstraint.constant = 8
        ModelTrailingConstraint.constant = 8
        ModelLeadingConstraint.constant = 8
        LandscapePlayerConstraint.constant = 8
        LandscapeModelConstraint.constant = 8
        
        // diplay the card on top of the discard pile
        discardCardView.isFaceUp = true
        discardCardView.setRank(newRank: discardCard.getRank())
        discardCardView.setSuit(newSuit: discardCard.getSuit())
        
        // setting up the color label; initially show the labe displaying the starting suit
        ColorLabel.isHidden = false
        ColorLabel.text = SuitToString(suitString: game.getCurrentSuit())
        ColorChoiceStack.isHidden = true
        
        // setting up both the player and model card stacks
        playerStack.distribution = UIStackView.Distribution.equalSpacing
        modelStack.distribution = UIStackView.Distribution.equalSpacing
        // setting up the final labels which only get displayed when one of the players win
        PlayerWinsLabel.isHidden = true
        ModelWinsLabel.isHidden = true
        // setting up and customizing the draw card button
        DrawCardButton.backgroundColor = UIColor.darkGray
        DrawCardButton.layer.cornerRadius = DrawCardButton.frame.width / 2
        DrawCardButton.setTitleColor(UIColor.white, for: .normal)
        DrawCardButton.layer.shadowColor = UIColor.darkGray.cgColor
        DrawCardButton.layer.shadowRadius = 4
        DrawCardButton.layer.shadowOpacity = 0.5
        DrawCardButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        // setting up and customizing the back button
        BackModelWins.backgroundColor = UIColor.lightGray
        BackModelWins.layer.cornerRadius = EndTurnButton.frame.height / 2
        BackModelWins.setTitleColor(UIColor.white, for: .normal)
        BackModelWins.layer.shadowColor = UIColor.darkGray.cgColor
        BackModelWins.layer.shadowRadius = 4
        BackModelWins.layer.shadowOpacity = 0.5
        BackModelWins.layer.shadowOffset = CGSize(width: 0, height: 0)
        BackModelWins.isHidden = true
        
        // setting up and customizing the back button
        BackPlayerWins.backgroundColor = UIColor.lightGray
        BackPlayerWins.layer.cornerRadius = EndTurnButton.frame.height / 2
        BackPlayerWins.setTitleColor(UIColor.white, for: .normal)
        BackPlayerWins.layer.shadowColor = UIColor.darkGray.cgColor
        BackPlayerWins.layer.shadowRadius = 4
        BackPlayerWins.layer.shadowOpacity = 0.5
        BackPlayerWins.layer.shadowOffset = CGSize(width: 0, height: 0)
        BackPlayerWins.isHidden = true
        
        // setting up and customizing the end turn button
        EndTurnButton.backgroundColor = UIColor.lightGray
        EndTurnButton.layer.cornerRadius = EndTurnButton.frame.height / 2
        EndTurnButton.setTitleColor(UIColor.white, for: .normal)
        EndTurnButton.layer.shadowColor = UIColor.darkGray.cgColor
        EndTurnButton.layer.shadowRadius = 4
        EndTurnButton.layer.shadowOpacity = 0.5
        EndTurnButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        EndTurnButton.isHidden = true
        
        // customizing the color label
        ColorLabel.backgroundColor = UIColor.systemBlue
        ColorLabel.layer.cornerRadius = EndTurnButton.frame.height / 2
        ColorLabel.layer.shadowColor = UIColor.darkGray.cgColor
        ColorLabel.layer.shadowRadius = 4
        ColorLabel.layer.shadowOpacity = 0.5
        ColorLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        // adding gesture recognizer to cards that are legal to play
        for cardview in playerCardView {
            let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
            if game.legalMove(card: currentCard) {
                cardview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveCard(_ :))))
            }
        }
    }
    
    /**
     Setting up the color switching buttons. When one of the color switches is pressed the suit is set to the chosen suit a function updates the UI. To do this it passes the turn to the model after the model plays its turn the buttons and possibly labels relevant for the player get displayed again and gesture recognizers get added to the legal cards and removed from not legal ones. The same mechanism gets triggered by each color switching button
     */
    @IBAction func SwitchToAcorn(_ sender: UIButton) {
        ColorChoiceStack.isHidden = true
        game.setNewSuit(newsuit: Suit.Acorn)
        UpdateViewAfterModelTurn()
    }
    
    @IBAction func SwitchToHearts(_ sender: UIButton) {
        ColorChoiceStack.isHidden = true
        game.setNewSuit(newsuit: Suit.Hearts)
        UpdateViewAfterModelTurn()
    }
    
    @IBAction func SwitchToLeaves(_ sender: UIButton) {
        ColorChoiceStack.isHidden = true
        game.setNewSuit(newsuit: Suit.Leaves)
        UpdateViewAfterModelTurn()
    }
    
    @IBAction func SwitchToPumpkins(_ sender: UIButton) {
        ColorChoiceStack.isHidden = true
        game.setNewSuit(newsuit: Suit.Pumpkins)
        UpdateViewAfterModelTurn()
    }
    
    /**
     When the end turn button is pressed the following takes place: the model's turn starts the player relevant buttons and labels get hidden then displayed accordingly. Depending on the model's move a card is removed from or added to the model's hand the player's hand get "refreshed" based on the action of the model, meaning that gesture recognizers get added to legal cards and removed from not legal ones.
     */
    @IBAction func PassTurn(_ sender: UIButton) {
        sender.isHidden = true
        UpdateViewAfterModelTurn()
    }
    
    /**
     When the draw card button is pressed the following events take place: player gets dealt the right amount of cards (fx if a 2 is played by the model and the player has no response two cards get drawn). After this the turn gets passed to the model, and the model's hand and the top of the discard pile are also updated based on the card played by the model.
     */
    @IBAction func drawCard(_ sender: UIButton) {
        // draw card, add it to hand
        // give turn to next player
        drawCardforPlayerHand()
        sender.isHidden = false
        UpdateViewAfterModelTurn()
    }
    
    /**
     Called whenever the player decides to draw a card
     */
    func drawCardforPlayerHand() {
        print("Current player: \(game.getCurrentPlayer()), drawing a card right now!")
        ColorLabel.isHidden = true
        let playerHandCount = game.getPlayerHand().count
        game.drawCard()
        game.rememberSuitRank()
        LeadingConstraint.constant = 8
        TrailingConstraint.constant = 8
        ModelTrailingConstraint.constant = 8
        ModelLeadingConstraint.constant = 8
        LandscapePlayerConstraint.constant = 8

        let playerHandCount2 = game.getPlayerHand().count
        
        for i in 1...(playerHandCount2-playerHandCount) {
            let newCardView = PlayingCardView()
            playerCardView.append(newCardView)
            newCardView.backgroundColor = UIColor.clear
            newCardView.setSuit(newSuit: game.getPlayerHand()[game.getPlayerHand().endIndex-i].getSuit())
            newCardView.setRank(newRank: game.getPlayerHand()[game.getPlayerHand().endIndex-i].getRank())
            newCardView.widthAnchor.constraint(lessThanOrEqualToConstant: 74).isActive = true
            let newCard = Card(suit: newCardView.suit, rank: newCardView.rank)
            if game.legalMove(card: newCard) {
                for newCardView in playerCardView {
                    newCardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveCard(_ :))))
                }
            }
            playerStack.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            playerStack.autoresizesSubviews = true
            playerStack.spacing = 0
            playerStack.addArrangedSubview(newCardView)
        }
        
        
        if self.game.getPlayerHand().count > 5 {
            self.playerStack.distribution = UIStackView.Distribution.fillEqually
        } else {
            self.playerStack.distribution = UIStackView.Distribution.equalSpacing
        }
        
        if game.getTopDiscardCard().getRank() == Rank.VII {
            ColorLabel.isHidden = false
            ColorLabel.text = SuitToString(suitString: game.getCurrentSuit())
            ColorLabel.adjustsFontSizeToFitWidth = true
            ColorChoiceStack.isHidden = true
        }
    }
    
    /**
     Updates the view after turn
     */
    func UpdateViewAfterModelTurn() {
        let count = game.getModelHand().count
        game.printGame()
        game.passTurn()
        game.modelTurn()
        checkpoint()
        let newcount = game.getModelHand().count

        if count > newcount {
            for cardview in modelCardView {
                let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
                for i in 1...(count-newcount) {
                    if currentCard.getRank() == game.getAnyDiscardCard(index: i).getRank() {
                        if currentCard.getSuit() == game.getAnyDiscardCard(index: i).getSuit() {
                            modelStack.removeArrangedSubview(cardview)
                        }
                    }
                }
            }
        }
                
        if count < newcount {
            for i in 1...(newcount-count) {
                let newCardView = ModelCardView()
                modelCardView.append(newCardView)
                newCardView.backgroundColor = UIColor.clear
                newCardView.setSuit(newSuit: game.getModelHand()[game.getModelHand().endIndex-i].getSuit())
                newCardView.setRank(newRank: game.getModelHand()[game.getModelHand().endIndex-i].getRank())
                newCardView.widthAnchor.constraint(lessThanOrEqualToConstant: 74).isActive = true
                modelStack.autoresizingMask = [.flexibleHeight,.flexibleWidth]
                modelStack.autoresizesSubviews = true
                modelStack.spacing = 0
                modelStack.addArrangedSubview(newCardView)
            }
        }
        
        if game.getModelHand().count == 1 {
            ModelTrailingConstraint.constant = 140
            ModelLeadingConstraint.constant = 140
            LandscapeModelConstraint.constant = 250
        } else {
            ModelTrailingConstraint.constant = 8
            ModelLeadingConstraint.constant = 8
            LandscapeModelConstraint.constant = 8
        }
        
        if self.game.getModelHand().count > 4 {
            self.modelStack.distribution = UIStackView.Distribution.fillEqually
            self.modelStack.spacing = 0
        } else {
            self.modelStack.distribution = UIStackView.Distribution.equalSpacing
        }
        
        for cardview in playerCardView {
            let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
            if game.legalMove(card: currentCard) {
                cardview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.moveCard(_ :))))
            }
            if !game.legalMove(card: currentCard) {
                for recognizer in cardview.gestureRecognizers ?? [] {
                    cardview.removeGestureRecognizer(recognizer)
                }
            }
        }
        
        DeckView[0].state = game.getDeckState()
        discardCardView.rank = game.getTopDiscardCard().getRank()
        discardCardView.suit = game.getTopDiscardCard().getSuit()
        
        if discardCardView.rank == Rank.II  {
            if count > newcount {
                for cardview in playerCardView {
                    let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
                    if currentCard.getRank() != Rank.II {
                        for recognizer in cardview.gestureRecognizers ?? [] {
                            cardview.removeGestureRecognizer(recognizer)
                        }
                    }
                    if currentCard.getRank() == Rank.Ace {
                        if currentCard.getSuit() == game.getCurrentSuit() {
                            cardview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.moveCard(_ :))))

                        }
                    }
                }
            }
        }
        if game.getTopDiscardCard().getRank() == Rank.VII {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.ColorLabel.isHidden = false
                self.ColorLabel.text = SuitToString(suitString: self.game.getCurrentSuit())
                self.ColorLabel.adjustsFontSizeToFitWidth = true
                self.ColorChoiceStack.isHidden = true}
        } else {
            ColorLabel.isHidden = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.DrawCardButton.isHidden = false
        }
    }
    
    /**
     Function for animating card movement, called by the gesture recognizer added to the player's cards based on previous codes, the only cards tappable are legal moves. As a first step the tapped legal card view is transfered to the discard card view and gets displayed there. As soon as this animation finishes, hide the buttons and labels which are not relevant after a card has already been played. Based on the played card refresh the player's hand and add gesture recognizer to those cards that match the rank of the played card, enabling a possible sequence of cards.
     */
    @objc func moveCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView
            {
                let chosenCard = Card(suit: chosenCardView.suit, rank: chosenCardView.rank)
                print("Playing this card: \(chosenCard)")
                UIView.transition(from: chosenCardView,
                                  to: discardCardView,
                                  duration: 0,
                                  options: .showHideTransitionViews,
                                  completion: { finished in
                                    //let discardCard = self.game.getTopDiscardCard()
                                    UIView.transition(with: self.discardCardView,
                                                      duration: 0.9,
                                                      options: .transitionCurlDown,
                                                      animations:{
                                                        self.discardCardView.rank = chosenCardView.rank
                                                        self.discardCardView.suit = chosenCardView.suit
                                                        self.DrawCardButton.isHidden = true
                                                        self.EndTurnButton.isHidden = false
                                                        
                                                        if self.game.getPlayerHand().count == 5 {
                                                            self.playerStack.distribution = UIStackView.Distribution.equalSpacing
                                                        }
                                                        
                                                        if self.game.getPlayerHand().count == 1 {
                                                            self.LeadingConstraint.constant = 140
                                                            self.TrailingConstraint.constant = 140
                                                            self.LandscapePlayerConstraint.constant = 250
                                                        }

                                                        if self.discardCardView.rank == Rank.VII{
                                                            self.ColorChoiceStack.isHidden = false
                                                            self.EndTurnButton.isHidden = true
                                                        }
                                                        
                                                        if self.discardCardView.rank != Rank.VII{
                                                            self.ColorChoiceStack.isHidden = true
                                                            self.ColorLabel.isHidden = true
                                                            self.EndTurnButton.isHidden = false
                                                        }
                                  
                                                        for cardview in self.playerCardView {
                                                            if self.discardCardView.rank == cardview.rank {
                                                                cardview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.moveCard(_ :))))
                                                            }
                                                            if self.discardCardView.rank != cardview.rank {
                                                                for recognizer in cardview.gestureRecognizers ?? [] {
                                                                    cardview.removeGestureRecognizer(recognizer)
                                                                }
                                                            }
                                                        }
                                                      })
                                  })
                if !game.playCard(card: chosenCard, newSuit: nil) {
                    print("Invalid move, a card is drawn for you!")
                    game.drawCard()
                }
                checkpoint()
                game.printGame()
            }
        default:
            break
        }
    }
    
    /**
     Checkpoint which displays the winner in case someone emptied his hand.
     */
    func checkpoint() {
        let checkpoint = game.checkpoint()
        switch checkpoint {
        case "Player":
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15 ) {
                print("Player won the game!")
                self.EndTurnButton.isHidden = true
                self.DrawCardButton.isHidden = true
                self.ColorChoiceStack.isHidden = true
                self.PlayerWinsLabel.isHidden = false
                self.BackPlayerWins.isHidden = false
                
            }
        case "Model":
            print("Model won the game!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35 ) {
                self.EndTurnButton.isHidden = true
                self.DrawCardButton.isHidden = true
                self.ModelWinsLabel.isHidden = false
                self.BackModelWins.isHidden = false
                self.discardCardView.isHidden = true
                self.ColorLabel.isHidden = true
            }
        default:
            break
        }
    }
}
