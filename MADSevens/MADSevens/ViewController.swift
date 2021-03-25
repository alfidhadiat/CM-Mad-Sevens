//
//  ViewController.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import UIKit

class MADSevensViewController: UIViewController {
    
    lazy var game = MADSevens()
    
    // Initialize model with the .actr file
    actr = actr("sevens")

    private var deck = Deck()
    
    @IBOutlet private var playerCardView: [PlayingCardView]!
    @IBOutlet private var modelCardView: [ModelCardView]!
    @IBOutlet private var discardCardView: CardInPlayView!
    @IBOutlet private var DeckView: [DeckView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let playerCards = game.getPlayerHand()
        let modelCards = game.getModelHand()
        let discardCard = game.getTopDiscardCard()
        //let deckCard = deck.updateDeck()
        
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
        
        
        
        discardCardView = CardInPlayView()
        discardCardView.setRank(newRank: discardCard.getRank())
        discardCardView.setSuit(newSuit: discardCard.getSuit())
    }


    
    /**
    Draws a card for the current player, gives the turn to its opponent.
     TODO: Do we want to enable/disable this button whenever its the models turn?
     */
    @IBAction func drawCard(_ sender: UIButton) {
        // draw card, add it to hand
        // give turn to next player
        //TODO: since button is pressed, it's always the player calling this function
        game.drawCard(player: game.getCurrentPlayer())
        game.printGame()
        game.passTurn()
        let state = updateDeck()
        
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
//        print("Please insert Suit:")
//        let inputSuitString = readLine()!
//        let inputSuit = suitStringToSuit(suitString: inputSuitString)
//        print("Please insert Rank:")
//        let inputRankString = readLine()!
//        let inputRank = rankStringToRank(suitString: inputRankString)
//        let card = Card(suit: inputSuit, rank: inputRank)
        let card = Card(suit: Suit.Hearts, rank: Rank.II)
        //TODO if a new suit is chosen (in case its a 7 for example), pass that value when playing the card
        if game.playCard(card: card, player: game.getCurrentPlayer(), newSuit: nil) {
            // Pass turn to the model
            game.passTurn()
            if card.rank == Rank.Ace {
                actr.storeAce()
            }
            actrTurn()
        } else {
            print("Invalid move, error!")
        }
        
        // Check if player has emptied his hand, if so he won.
        if game.isDone() {
            if game.playerWon(){
                // Display a "You won the game!" message
            } else if game.modelWon() {
                // Display a "You lost the game!" message
            }
        } else {
            // If game hasn't ended, we give the turn to the model.
            game.passTurn()
            actrTurn()
        }
    }

    /**
    The procedure for the ACT-R's turn
    **/
    func actrTurn() {

        // First, put current ACTR hand and top discard into ACTR
        let actr.hand = getHand(player.Model)
        let actr.top = deck.getTopDiscardCard()

        // Go through the model's turn to generate a "choice"
        let choice = actr.turn()

        // Switch cases depending on the choice made
        // After a choice is played, pass the turn again
        switch choice {

            // When ACT-R has no legal hand, the choice is "draw"
            case "draw":
                game.drawCard(player: game.getCurrentPlayer())
                game.passTurn()

            // When ACT-R has only one legal, the choice is "playOne"
            case "playOne":
                for (card in actr.hand) {
                    if deck.isLegalMove(card: card) == True {
                        let onlyLegal = card
                    }
                }
                if onlyLegal.rank == Rank.VII {
                    let newSuit = actr.predictSuit()
                } else {
                    let newSuit = nil
                }
                game.playCard(card: onlyLegal, player: game.getCurrentPlayer(), newSuit: newSuit)
                game.passTurn()

            // When ace is legal against a two, choice is "playAce"
            case "playAce":
                for (card in actr.hand) {
                    if card.rank == Rank.Ace {
                        let aceCard = card
                    }
                }
                game.playCard(card: aceCard, player: game.getCurrentPlayer(), newSuit: newSuit)
                game.passTurn()
			
			// When not against two and legal option with more than one count,
			// it can only be a rank, so choice is "bestRank"
			case "bestRank":
				let rank = actr.model.lastAction("rank")
				var cards: [Card]
				for (card in actr.hand) {
					let rank = card.getRank().rawValue
					let suit = card.getSuit().rawValue
					
					if rank == suitRank {
						cards.append(card)	
					}
        		}
				// !!! Need a game method that plays multiple rank cards
    }
    
    func getHand(player: Player) -> [Card] {
        if player == Player.model {
            return game.getModelHand()
        } else {
            return game.getPlayerHand()
        }
    }
    
    func suitStringToSuit(suitString: String) -> Suit {
        switch suitString {
        case "hearts":
            return Suit.Hearts
        case "acorn":
            return Suit.Acorn
        case "leaves":
            return Suit.Leaves
        case "pumpkin":
            return Suit.Pumpkins
        default:
            print("Error, used default suit: Hearts")
            return Suit.Hearts
        }
    }
    
    func rankStringToRank(suitString: String) -> Rank {
        switch suitString {
        case "II":
            return Rank.II
        case "VII":
            return Rank.VII
        case "VIII":
            return Rank.VIII
        case "IX":
            return Rank.IX
        case "X":
            return Rank.X
        case "Ace":
            return Rank.Ace
        case "Unter":
            return Rank.Unter
        case "King":
            return Rank.King
        default:
            print("Error, used default rank: II")
            return Rank.II
        }
    }
    
//    /**
//     Just a test function
//     */
//    @IBAction func topDiscardCard(_ sender: UIButton) {
//        print("topcard: \(game.getTopDiscardCard())")
//    }
//
    
    
//    @IBAction func PlayFirstCard(_ sender: UIButton) {
//        game.deck.playFirstCard(player: game.currentPlayer)
//        print("A card has been added to the discard pile")
//        print("Playerhand: \n \(game.deck.playerHand))")
//        print("Modelhand: \n \(game.deck.modelHand))")
//        print("Discardpile: \n \(game.deck.discard)")
//    }
}
