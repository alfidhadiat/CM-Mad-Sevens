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
    
//    @IBOutlet weak var rankField: UITextField!
//    @IBOutlet weak var suitField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let playerCards = game.getPlayerHand()
        let modelCards = game.getModelHand()
        let discardCard = game.getTopDiscardCard()
        print("This is a dicard card \(discardCard)")
        
        for i in 0 ..< playerCards.count {
            playerCardView[i].isFaceUp = true
            playerCardView[i].setRank(newRank: playerCards[i].getRank())
            playerCardView[i].setSuit(newSuit: playerCards[i].getSuit())
        }
        
        for i in 0 ..< modelCards.count {
            modelCardView[i].isFaceUp = false
            modelCardView[i].setRank(newRank: modelCards[i].getRank())
            modelCardView[i].setSuit(newSuit: modelCards[i].getSuit())
        }
        
        discardCardView.isFaceUp = true
        discardCardView.setRank(newRank: discardCard.getRank())
        discardCardView.setSuit(newSuit: discardCard.getSuit())
        
        ColorLabel.isHidden = true
        ColorChoiceStack.isHidden = true
        if discardCard.getRank() == Rank.VII{
            ColorChoiceStack.isHidden = false
        }
        
        let currentPlayer = game.getCurrentPlayer()
        if currentPlayer == Player.model{
            if discardCardView.rank == Rank.VII {
                ColorLabel.isHidden = false
            } else {
                ColorLabel.isHidden = true
            }
        }
        
        if discardCard.getRank() == Rank.VII{
            ColorChoiceStack.isHidden = true
            ColorLabel.isHidden = false
            ColorLabel.text = SuitToString(suitString: game.getCurrentSuit())
        }
        
        PlayerWinsLabel.isHidden = true
        ModelWinsLabel.isHidden = true
        DrawCardButton.backgroundColor = UIColor.darkGray
        DrawCardButton.layer.cornerRadius = DrawCardButton.frame.width / 2
        DrawCardButton.setTitleColor(UIColor.white, for: .normal)
        DrawCardButton.layer.shadowColor = UIColor.darkGray.cgColor
        DrawCardButton.layer.shadowRadius = 4
        DrawCardButton.layer.shadowOpacity = 0.5
        DrawCardButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        EndTurnButton.backgroundColor = UIColor.lightGray
        EndTurnButton.layer.cornerRadius = EndTurnButton.frame.height / 2
        EndTurnButton.setTitleColor(UIColor.white, for: .normal)
        EndTurnButton.layer.shadowColor = UIColor.darkGray.cgColor
        EndTurnButton.layer.shadowRadius = 4
        EndTurnButton.layer.shadowOpacity = 0.5
        EndTurnButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        EndTurnButton.isHidden = true
        
        ColorLabel.backgroundColor = UIColor.systemBlue
        ColorLabel.layer.cornerRadius = EndTurnButton.frame.height / 2
        ColorLabel.layer.shadowColor = UIColor.darkGray.cgColor
        ColorLabel.layer.shadowRadius = 4
        ColorLabel.layer.shadowOpacity = 0.5
        ColorLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        for cardview in playerCardView {
            let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
            if game.legalMove(card: currentCard) {
                cardview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveCard(_ :))))
            }
        }
    }
    
    @IBAction func SwitchToAcorn(_ sender: UIButton) {
        ColorChoiceStack.isHidden = true
        game.setNewSuit(newsuit: Suit.Acorn)
        let count = game.getModelHand().count
        game.passTurn()
        game.modelTurn()
        checkpoint()
        DrawCardButton.isHidden = false
        ColorLabel.isHidden = true
        let newcount = game.getModelHand().count
        
        if count > newcount{
            for cardview in modelCardView {
                let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
                if currentCard.getRank() == game.getTopDiscardCard().getRank() {
                    if currentCard.getSuit() == game.getTopDiscardCard().getSuit() {
                        modelStack.removeArrangedSubview(cardview)
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
        
        if self.game.getModelHand().count > 4 {
            self.modelStack.distribution = UIStackView.Distribution.fillEqually
        } else {
            self.modelStack.distribution = UIStackView.Distribution.equalSpacing
        }
        
        discardCardView.rank = game.getTopDiscardCard().getRank()
        discardCardView.suit = game.getTopDiscardCard().getSuit()
        
        for cardview in self.playerCardView {
            let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
            if self.game.legalMove(card: currentCard) {
                cardview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.moveCard(_ :))))
            }
            if !game.legalMove(card: currentCard) {
                for recognizer in cardview.gestureRecognizers ?? [] {
                    cardview.removeGestureRecognizer(recognizer)
                }
            }
        }
        
        if count > game.getModelHand().count {
            if discardCardView.rank == Rank.VII {
                ColorLabel.isHidden = false
                ColorLabel.text = SuitToString(suitString: game.getCurrentSuit())
                ColorChoiceStack.isHidden = true
            } else {
                ColorLabel.isHidden = true
            }
        }
        
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
    }
    
    @IBAction func SwitchToHearts(_ sender: UIButton) {
        ColorChoiceStack.isHidden = true
        game.setNewSuit(newsuit: Suit.Hearts)
        let count = game.getModelHand().count
        game.passTurn()
        game.modelTurn()
        checkpoint()
        DrawCardButton.isHidden = false
        ColorLabel.isHidden = true
        let newcount = game.getModelHand().count
        
        if count > newcount{
            for cardview in modelCardView {
                let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
                if currentCard.getRank() == game.getTopDiscardCard().getRank() {
                    if currentCard.getSuit() == game.getTopDiscardCard().getSuit() {
                        modelStack.removeArrangedSubview(cardview)
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
        
        if self.game.getModelHand().count > 4 {
            self.modelStack.distribution = UIStackView.Distribution.fillEqually
        } else {
            self.modelStack.distribution = UIStackView.Distribution.equalSpacing
        }
        
        discardCardView.rank = game.getTopDiscardCard().getRank()
        discardCardView.suit = game.getTopDiscardCard().getSuit()
            
        for cardview in self.playerCardView {
            let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
            if self.game.legalMove(card: currentCard) {
                cardview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.moveCard(_ :))))
            }
            if !game.legalMove(card: currentCard) {
                for recognizer in cardview.gestureRecognizers ?? [] {
                    cardview.removeGestureRecognizer(recognizer)
                }
            }
        }
        
        if count > game.getModelHand().count {
            if discardCardView.rank == Rank.VII {
                ColorLabel.isHidden = false
                ColorLabel.text = SuitToString(suitString: game.getCurrentSuit())
                ColorChoiceStack.isHidden = true
            } else {
                ColorLabel.isHidden = true
            }
        }
        
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
    }
    
    @IBAction func SwitchToLeaves(_ sender: UIButton) {
        ColorChoiceStack.isHidden = true
        game.setNewSuit(newsuit: Suit.Leaves)
        let count = game.getModelHand().count
        game.passTurn()
        game.modelTurn()
        checkpoint()
        DrawCardButton.isHidden = false
        ColorLabel.isHidden = true
        let newcount = game.getModelHand().count
        
        if count > newcount{
            for cardview in modelCardView {
                let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
                if currentCard.getRank() == game.getTopDiscardCard().getRank() {
                    if currentCard.getSuit() == game.getTopDiscardCard().getSuit() {
                        modelStack.removeArrangedSubview(cardview)
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
        
        if self.game.getModelHand().count > 4 {
            self.modelStack.distribution = UIStackView.Distribution.fillEqually
        } else {
            self.modelStack.distribution = UIStackView.Distribution.equalSpacing
        }
        
        discardCardView.rank = game.getTopDiscardCard().getRank()
        discardCardView.suit = game.getTopDiscardCard().getSuit()
        
        
        for cardview in self.playerCardView {
            let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
            if self.game.legalMove(card: currentCard) {
                cardview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.moveCard(_ :))))
            }
            if !game.legalMove(card: currentCard) {
                for recognizer in cardview.gestureRecognizers ?? [] {
                    cardview.removeGestureRecognizer(recognizer)
                }
            }
        }
        
        if count > game.getModelHand().count {
            if discardCardView.rank == Rank.VII {
                ColorLabel.isHidden = false
                ColorLabel.text = SuitToString(suitString: game.getCurrentSuit())
                ColorChoiceStack.isHidden = true
            } else {
                ColorLabel.isHidden = true
            }
        }
        
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
    }
    
    @IBAction func SwitchToPumpkins(_ sender: UIButton) {
        ColorChoiceStack.isHidden = true
        game.setNewSuit(newsuit: Suit.Pumpkins)
        let count = game.getModelHand().count
        game.passTurn()
        game.modelTurn()
        checkpoint()
        DrawCardButton.isHidden = false
        ColorLabel.isHidden = true
        let newcount = game.getModelHand().count
        
        if count > newcount{
            for cardview in modelCardView {
                let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
                if currentCard.getRank() == game.getTopDiscardCard().getRank() {
                    if currentCard.getSuit() == game.getTopDiscardCard().getSuit() {
                        modelStack.removeArrangedSubview(cardview)
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
        
        if self.game.getModelHand().count > 4 {
            self.modelStack.distribution = UIStackView.Distribution.fillEqually
        } else {
            self.modelStack.distribution = UIStackView.Distribution.equalSpacing
        }
        
        discardCardView.rank = game.getTopDiscardCard().getRank()
        discardCardView.suit = game.getTopDiscardCard().getSuit()
        
        for cardview in self.playerCardView {
            let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
            if self.game.legalMove(card: currentCard) {
                cardview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.moveCard(_ :))))
            }
            if !game.legalMove(card: currentCard) {
                for recognizer in cardview.gestureRecognizers ?? [] {
                    cardview.removeGestureRecognizer(recognizer)
                }
            }
        }
        
        if count > game.getModelHand().count {
            if discardCardView.rank == Rank.VII {
                ColorLabel.isHidden = false
                ColorLabel.text = SuitToString(suitString: game.getCurrentSuit())
                ColorChoiceStack.isHidden = true
            } else {
                ColorLabel.isHidden = true
            }
        }
        
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
    }
    
    
    @IBAction func PassTurn(_ sender: UIButton) {
        sender.isHidden = true
        let count = game.getModelHand().count
        game.passTurn()
        game.modelTurn()
        checkpoint()
        DrawCardButton.isHidden = false
        let newcount = game.getModelHand().count
        
        
        if count > newcount{
            for cardview in modelCardView {
                let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
                if currentCard.getRank() == game.getTopDiscardCard().getRank() {
                    if currentCard.getSuit() == game.getTopDiscardCard().getSuit() {
                        modelStack.removeArrangedSubview(cardview)
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
 
        
        if self.game.getModelHand().count > 4 {
            self.modelStack.distribution = UIStackView.Distribution.fillEqually
        } else {
            self.modelStack.distribution = UIStackView.Distribution.equalSpacing
        }
        
        discardCardView.rank = game.getTopDiscardCard().getRank()
        discardCardView.suit = game.getTopDiscardCard().getSuit()
        
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
        
        if discardCardView.rank == Rank.VII {
            ColorLabel.isHidden = false
            ColorLabel.text = SuitToString(suitString: game.getCurrentSuit())
        }
        
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
    }
    
    
    /**
    Draws a card for the current player, gives the turn to its opponent.
     TODO: Do we want to enable/disable this button whenever its the models turn?
     */
    @IBAction func drawCard(_ sender: UIButton) {
        // draw card, add it to hand
        // give turn to next player
        //TODO: since button is pressed, it's always the player calling this function
        print("Current player: \(game.getCurrentPlayer()), drawing a card right now!")
        let playerHandCount = game.getPlayerHand().count
        game.drawCard()
        game.rememberSuitRank()
        
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
        
        
        if self.game.getPlayerHand().count > 4 {
            self.playerStack.distribution = UIStackView.Distribution.fillEqually
        } else {
            self.playerStack.distribution = UIStackView.Distribution.equalSpacing
        }
        
        let count = game.getModelHand().count
        game.printGame()
        game.passTurn()
        game.modelTurn()
        checkpoint()
        sender.isHidden = false
        let newCount = game.getModelHand().count

        if count > newCount {
            for cardview in modelCardView {
                let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
                if currentCard.getRank() == game.getTopDiscardCard().getRank() {
                    if currentCard.getSuit() == game.getTopDiscardCard().getSuit() {
                        modelStack.removeArrangedSubview(cardview)
                    }
                }
            }
        }
                
        if count < newCount {
            let newCardView = ModelCardView()
            modelCardView.append(newCardView)
            newCardView.setSuit(newSuit: game.getModelHand()[game.getModelHand().endIndex-1].getSuit())
            newCardView.setRank(newRank: game.getModelHand()[game.getModelHand().endIndex-1].getRank())
            newCardView.widthAnchor.constraint(lessThanOrEqualToConstant: 74).isActive = true
            newCardView.backgroundColor = UIColor.clear
            modelStack.addArrangedSubview(newCardView)
        }
        
        if self.game.getModelHand().count > 4 {
            self.modelStack.distribution = UIStackView.Distribution.fillEqually
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
        
        if discardCardView.rank == Rank.VII {
            ColorLabel.isHidden = false
            ColorLabel.text = SuitToString(suitString: game.getCurrentSuit())
            ColorChoiceStack.isHidden = true
        } else {
            ColorLabel.isHidden = true
        }
        
        if discardCardView.rank == Rank.II  {
            if count > newCount {
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
        
    }
    
    
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
                                                        
                                                        if self.game.getPlayerHand().count == 4 {
                                                            self.playerStack.distribution = UIStackView.Distribution.equalSpacing
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
//                                                            let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
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
                if !game.playCard2(card: chosenCard, newSuit: nil) {
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
     The selected card (TODO: multiple cards yet to be implemented) will be taken from the player's hand and added to the
     discard pile. The turn is now given to the model.
     */
//    @IBAction func doMove(_ sender: UIButton) {
//        //TODO figure out how to find a selected card
//
//        // do the move
//        let inputRank = rankField!
//        let inputSuit = suitField!
//        print("inputRank: \(inputRank.text!), inputSuit: \(inputSuit.text!)")
//        let card = Card(suit: suitStringToSuit(suitString: inputSuit.text!), rank: rankStringToRank(rankString: inputRank.text!))
//        print("Playing this card: \(card)")
////        TODO if a new suit is chosen (in case its a 7 for example), pass that value when playing the card
//        if !game.playCard(card: card, newSuit: nil) {
//            print("Invalid move, a card is drawn for you!")
//    }
//        game.passTurn()
//        checkpoint()
//        game.modelTurn()
//        checkpoint()
//    }
//
    func checkpoint() {
        //TODO: Convert print statements to popups
        let checkpoint = game.checkpoint()
        switch checkpoint {
        case "Player":
            print("Player won the game!")
            EndTurnButton.isHidden = true
            DrawCardButton.isHidden = true
            PlayerWinsLabel.isHidden = false
//            game.newGame()
//            TODO: go back to the main menu?
        case "Model":
            print("Model won the game!")
            EndTurnButton.isHidden = true
            DrawCardButton.isHidden = true
            ModelWinsLabel.isHidden = false
//            game.newGame()
//            TODO: go back to the main menu?
        default:
            break
        }
    }
    
    
    
    //    /**
    //     Just a test function
    //     */
    //    @IBAction func topDiscardCard(_ sender: UIButton) {
    //        print("topcard: \(game.getTopDiscardCard())")
    //    }
    //
        
        
        //    func getHand(player: Player) -> [Card] {
        //        if player == Player.model {
        //            return game.getModelHand()
        //        } else {
        //            return game.getPlayerHand()
        //        }
        //    }
        
        
    //    @IBAction func PlayFirstCard(_ sender: UIButton) {
    //        game.deck.playFirstCard(player: game.currentPlayer)
    //        print("A card has been added to the discard pile")
    //        print("Playerhand: \n \(game.deck.playerHand))")
    //        print("Modelhand: \n \(game.deck.modelHand))")
    //        print("Discardpile: \n \(game.deck.discard)")
    //    }
    }
