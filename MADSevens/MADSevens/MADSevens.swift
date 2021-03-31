//
//  MADSevens.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import Foundation

class MADSevens {
    
    private var deck: Deck
    private var currentPlayer: Player
    private var actr: sevensACTR
    
    init() {
        print("Intitializing MADSevens game (INIT OF MADSevens)")
        deck = Deck()
        actr = sevensACTR(actrName: "sevens")
        currentPlayer = Player.player
        printGame()
    }
    
    func newGame() {
        print("Starting new MADSevens game")
        deck.newGame()
        currentPlayer = Player.player
        print("Started a new MADSevens game, this is the current situation")
        printGame()
    }
    
    func drawCard() {
        deck.drawCard(player: currentPlayer)
    }
    
    func playCard(card: Card, newSuit: Suit?) {
        if deck.legalMove(card: card) {
            deck.playCard(card: card, player: currentPlayer, newSuit: newSuit)
        } else {
            drawCard()
            print("Invalid move, a card is drawn for you!")

        }
    }
    
    func modelTurn() {
        //Here, the model is called, and afterwards his move is executed
        //E.g. decide to draw a card:
        actrTurn()
        printGame()
        passTurn()
    }
    
    /**
     Pass the turn to the other player, check if someone has no cards left and therefore won the game
     */
    func passTurn() {
        if (currentPlayer == Player.model) {
            currentPlayer = Player.player
        } else {
            currentPlayer = Player.model
        }
    }
    
    /**
     Checks wether the end of the game has been reached. If so, displays a message and restarts the game.
     */
    func checkpoint() -> String {
        if (playerWon() || modelWon()) {
            if playerWon(){
                return "Player"
            } else if modelWon() {
                return "Model"
            }
        }
        return "None"
    }
    
    //    func done() -> Bool {
    //        return finished
    //    }
    
    func legalMove(card: Card) -> Bool {
        return deck.legalMove(card: card)
    }
    
    func playerWon() -> Bool {
        return deck.playerHandEmpty()
    }
    
    func modelWon() -> Bool {
        return deck.modelHandEmpty()
    }
    
    func getTopDiscardCard() -> Card {
        return deck.getTopDiscardCard()
    }
    
    func getCurrentSuit() -> Suit {
        return deck.getCurrentSuit()
    }
    
    func getCurrentRank() -> Rank {
        return deck.getCurrentRank()
    }
    
    func getDeckCount() -> Int {
        return deck.getDeckCount()
    }
    
    func getCurrentPlayer() -> Player {
        return currentPlayer
    }
    
    func getPlayerHand() -> [Card] {
        return deck.getPlayerHand()
    }
    
    func getModelHand() -> [Card] {
        return deck.getModelHand()
    }
    
    func rememberSuitRank() {
        actr.rememberSuitRank(topCard: deck.getTopDiscardCard())
    }
    
    func printGame() {
        print("Current situation:")
        print("Current player: \(currentPlayer)")
        let modelhand = deck.getModelHand()
        let playerhand = deck.getPlayerHand()
        print("\n Model's hand:")
        for i in 0..<modelhand.endIndex {
            print("\(modelhand[i].getSuit()) - \(modelhand[i].getRank())")
        }
        print("\n Player's hand:")
        for i in 0..<playerhand.endIndex {
            print("\(playerhand[i].getSuit()) - \(playerhand[i].getRank())")
        }
        print("\n Top of the discard pile: \(deck.getTopDiscardCard().getSuit()) - \(deck.getTopDiscardCard().getRank())")
    }
    
    /*************************
     The procedure for the ACT-R's turn
     *************************/
    func actrTurn() {
        
        // First, put current ACTR hand and top discard into ACTR
        actr.setHand(newHand: getPlayerHand())
        
        // Go through the model's turn to generate a "choice"
        let choice = actr.turn(topCard: getTopDiscardCard())
        
        // Switch cases that play out the model's choice
        switch choice {
        
        // When ACT-R has no legal hand, the choice is "draw"
        case "draw":
            drawCard()
            
        // When ACT-R has only one legal, the choice is "playOne"
        case "playOne":
            for card in actr.getHand() {
                if deck.legalMove(card: card) == true {
                    let onlyLegal = card
                    let onlyLegalRank = onlyLegal.getRank()
                    var newSuit: Suit? = nil
                    if onlyLegalRank == Rank.VII {
                        actr.predictSuit()
                        newSuit = actr.getPredictedSuit()
                    }
                    playCard(card: onlyLegal, newSuit: newSuit)
                }
            }
            
        // When ace is legal against a two, choice is "playAce"
        case "playAce":
            var aceCard: Card
            for card in actr.getHand() {
                let rank = card.getRank()
                if rank == Rank.Ace {
                    aceCard = card
                    playCard(card: aceCard, newSuit: nil)
                }
            }
            
        // When choice is "prediction", try play a card with the suit
        case "prediction":
            let predictSuit = actr.getPredictedSuit()
            var suitMatched = "no"
            var cardToPlay: Card
            
            for card in actr.getHand() {
                let isLegal = deck.legalMove(card: card)
                let cardSuit = card.getSuit()
                if cardSuit == predictSuit && isLegal == true {
                    cardToPlay = card
                    suitMatched = "yes"
                }
            }
            if suitMatched == "no" {
                for card in actr.getHand() {
                    let isLegal = deck.legalMove(card: card)
                    if isLegal == true {
                        cardToPlay = card
                        playCard(card: cardToPlay, newSuit: nil)
                    }
                }
            }
            
        // When not against two and legal option with more than one count,
        // it can only be a rank, so choice is "bestRank"
        case "bestRank":
            let bestRank = actr.getBestRank()
            var cards = [Card]()
            for card in actr.getHand() {
                let rank = card.getRank()
                if rank == bestRank {
                    cards.append(card)
                    playCard(card: cards[0], newSuit: nil)
                }
            }
            
        // !!! Need a game method that plays multiple rank cards
        
        // If II played and no ace available, choice is "checkAce"
        case "checkAce":
            // If predict slot is not nil, check if ace suit is in hand
            // TODO: We assume this returns a "nil" if no ace has been played yet
            var playTwo: Card
//            var safeTwo: Card
            
            if actr.getLastAction() != nil {
                let aceSuit = suitStringToSuit(suitString: actr.getLastAction()!)
//                var twoExists = "no"
                for card in actr.getHand() {
                    let cardSuit = card.getSuit()
                    let cardRank = card.getRank()
                    if (cardRank == Rank.Ace && cardSuit == aceSuit) {
                        playTwo = card
                        playCard(card: playTwo, newSuit: nil)
//                        twoExists = "yes"
                    } else {
                        for card in actr.getHand() {
                            let cardRank = card.getRank()
                            if (cardRank == Rank.II) {
                                playTwo = card
                                playCard(card: playTwo, newSuit: nil)
                            }
                        }
                    }
                }
                // If a II in hand matches suit with ace, play it
                // Else if no II matches suit, play a random II
//                if twoExists == "yes" {
//                    playTwo = safeTwo
//                } else if twoExists == "no" {
//
//                }
            } else {
                for card in actr.getHand() {
                    let cardRank = card.getRank()
                    if cardRank == Rank.II {
                        playTwo = card
                        playCard(card: playTwo, newSuit: nil)
                    }
                }
            }
        default:
            break
        }
        passTurn()
    }
    
}
