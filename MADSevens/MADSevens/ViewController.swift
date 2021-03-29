//
//  ViewController.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import UIKit

class MADSevensViewController: UIViewController {
    
    public var game = MADSevens()
    
    private var deck = Deck()
    
    @IBOutlet private var playerCardView: [PlayingCardView]!
    @IBOutlet private var modelCardView: [ModelCardView]!
    @IBOutlet private var discardCardView: CardInPlayView!
    @IBOutlet private var DeckView: [DeckView]!
    @IBOutlet weak var playerStack: UIStackView!
    
    //@IBOutlet weak var rankField: UITextField!
    //@IBOutlet weak var suitField: UITextField!
    
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

        for cardview in playerCardView {
            cardview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveCard(_ :))))
            }
    }
    
    
    @objc func moveCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView
            {
                UIView.transition(from: chosenCardView,
                                  to: discardCardView,
                                  duration: 0.25,
                                  options: .showHideTransitionViews,
                                  completion: { finished in
                                    //let discardCard = self.game.getTopDiscardCard()
                                    UIView.transition(with: self.discardCardView,
                                                      duration: 0.1,
                                                      options: .transitionCurlUp,
                                                      animations:{
                                                        self.discardCardView.rank = chosenCardView.rank
                                                        self.discardCardView.suit = chosenCardView.suit
                                                      })
                                  })
            }
        default:
            break
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

        // ACT-R stores top suit and rank in memory
        actr.top = deck.getTopDiscardCard()
        actr.rememberSuitRank()

        game.drawCard()
        game.printGame()
        game.passTurn()
        game.modelTurn()
        //drawCard2(player: Player.player)
        let newCard = PlayingCardView()
        newCard.setSuit(newSuit: deck.getNewSuit())
        newCard.setRank(newRank: deck.getNewRank())
        newCard.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        newCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveCard(_:))))
        newCard.backgroundColor = UIColor.clear
        deck.drawCard(player: Player.player)
        playerStack.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        playerStack.autoresizesSubviews = true
        playerStack.addArrangedSubview(newCard)
        
        //        let state = updateDeck()
    }
    
//    marieke pls move back to deck
    func updateDeck() -> String {
        var state = "full"
        let stackCount = game.getDeckCount()
        if (stackCount <= 17) {
            state = "threeq"
        } else if (stackCount <= 13) {
            state = "half"
        } else if (stackCount <= 9){
            state = "oneq"
        } else if (stackCount <= 5) {
            state = "low"
        }
            return state
    }
    /**
     The selected card (TODO: multiple cards yet to be implemented) will be taken from the player's hand and added to the
     discard pile. The turn is now given to the model.
     */
    @IBAction func doMove(_ sender: UIButton) {
        //TODO figure out how to find a selected card
        
        // do the move
        //let inputRank = rankField!
        //let inputSuit = suitField!
        //print("inputRank: \(inputRank.text!), inputSuit: \(inputSuit.text!)")
        //let card = Card(suit: suitStringToSuit(suitString: inputSuit.text!), rank: rankStringToRank(rankString: inputRank.text!))
        //print("Playing this card: \(card)")
        //TODO if a new suit is chosen (in case its a 7 for example), pass that value when playing the card
        //if !game.playCard(card: card, newSuit: nil) {
      //      print("Invalid move, a card is drawn for you!")
    //}
        game.passTurn()
        checkpoint()
        game.modelTurn()
        checkpoint()
    }
    
    func checkpoint() {
        //TODO: Convert print statements to popups
        let checkpoint = game.checkpoint()
        switch checkpoint {
        case "Player":
            print("Player won the game!")
            game.newGame()
        case "Model":
            print("Model won the game!")
            game.newGame()
        default:
            break
        }
    }
    
    /*************************
    The procedure for the ACT-R's turn
    *************************/
    func actrTurn() {

        // First, put current ACTR hand and top discard into ACTR
        actr.hand = getHand(player.Model)
        actr.top = deck.getTopDiscardCard()

        // Go through the model's turn to generate a "choice"
        let choice = actr.turn()

        // Switch cases that play out the model's choice
        switch choice {

            // When ACT-R has no legal hand, the choice is "draw"
            case "draw":
                game.drawCard(player: game.getCurrentPlayer())
                game.passTurn()

            // When ACT-R has only one legal, the choice is "playOne"
            case "playOne":
                for (card in actr.hand) {
                    if deck.isLegalMove(card: card) == true {
                        let onlyLegal = card
                    }
                }

                let onlyLegalRank = onlyLegal.getRank().rawValue
                if onlyLegalRank == "VII" {
                    let newSuit = actr.predictSuit()
                } else {
                    let newSuit = nil
                }
                game.playCard(card: onlyLegal, player: game.getCurrentPlayer(), newSuit: newSuit)
                game.passTurn()

            // When ace is legal against a two, choice is "playAce"
            case "playAce":
                for card in actr.hand {
                    let rank = card.getRank().rawValue
                    if rank == "Ace" {
                        let aceCard = card
                    }
                }
                game.playCard(card: aceCard, player: game.getCurrentPlayer())
                game.passTurn()

            // When choice is "prediction", try play a card with the suit
            case "prediction":
                let predictSuit = actr.model.lastAction("predict")
                var suitMatched = "no"
                for card in actr.hand {
                    let isLegal = deck.isLegalMove(card: card)
                    let cardSuit = card.getSuit().rawValue
                    if cardSuit == predictSuit && isLegal == true {
                        let playCard = card
                        suitMatched = "yes"
                    }
                }
                if suitMatched = "no" {
                   for card in actr.hand {
                       let isLegal = deck.isLegalMove(card: card)
                       if isLegal == true {
                           let playCard = card
                       }
                   } 
                }
                game.playCard(card: playCard, player: game.getCurrentPlayer())
                game.passTurn()
			
			// When not against two and legal option with more than one count,
			// it can only be a rank, so choice is "bestRank"
			case "bestRank":
				let rank = actr.model.lastAction("rank")
				var cards: [Card]
				for card in actr.hand {
					let rank = card.getRank().rawValue
					if rank == suitRank {
						cards.append(card)	
					}
        		}
				// !!! Need a game method that plays multiple rank cards
            
            // If II played and no ace available, choice is "checkAce"
            case "checkAce":
                // If predict slot is not nil, check if ace suit is in hand
                if actr.model.lastAction("predict") != "nil" {
                    let aceSuit = model.lastAction("predict")
                    var twoExists = "no"
                    for (card in actr.hand) {
                        let cardSuit = card.getSuit().rawValue
                        let cardRank = card.getRank().rawValue
                        if (cardRank == "II" && cardSuit == aceSuit) {
                            let safeTwo = card
                            twoExists = "yes"
                        }
                    }
                    // If a II in hand matches suit with ace, play it
                    // Else if no II matches suit, play a random II
                    if twoExists == "yes" {
                        let playTwo = safeTwo
                    } else if twoExists == "no" {
                        for (card in actr.hand) {
                            let cardRank = card.getValue().rawValue
                            var playTwo: Card
                            if (cardRank == "II") {
                                playTwo = card
                            }
                        }
                    }
                } else if actr.model.lastAction("predict") == "nil" {
                    var playTwo: Card
                    for (card in actr.hand) {
                        let cardRank = card.getValue().rawValue
                        if (cardRank == "II") {
                            playTwo = card
                        }
                    }
                }
                game.playCard(card: playTwo, player: game.getCurrentPlayer())
                game.passTurn()
                

    
    
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
