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
    private var finished: Bool
//    private var model: ACTRModel
    
    init() {
        print("Intitializing new MADSevens game \n")
        deck = Deck()
        currentPlayer = Player.player
        finished = false
    }
    
    func newGame() {
        print("Starting new MADSevens game")
        deck.newGame()
        currentPlayer = Player.player
        finished = false
    }
    
    func drawCard(player: Player) {
        deck.drawCard(player: player)
    }
    
<<<<<<< HEAD
//    func getTopDiscardCard() -> Card {
//        return deck.getTopDiscardCard()
//    }
=======
    func getTopDiscardCard() -> Card {
        return deck.getTopDiscardCard()
    }
>>>>>>> main
    
    func getCurrentSuit() -> Suit {
        return deck.getCurrentSuit()
    }
    
    func getCurrentRank() -> Rank {
        return deck.getCurrentRank()
    }
    
<<<<<<< HEAD
=======
    func getDeckCount() -> Int {
        return deck.getDeckCount()
    }
    
>>>>>>> main
    func playCard(card: Card, player: Player, newSuit: Suit?) -> Bool {
        if deck.isLegalMove(card: card) {
            deck.playCard(card: card, player: player, newSuit: newSuit)
            return true
        }
        return false
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
        // When passing the turn, check if the game has ended
        if (playerWon() || modelWon()) {
            finished = true
        }
    }
    
    func modelTurn() {
        //Here, the model is called, and afterwards his move is executed
        //E.g. decide to draw a card:
        drawCard(player: currentPlayer)
        passTurn()
        // check if the game is done.
    }
    
    func playerWon() -> Bool {
        return deck.playerHandEmpty()
    }
    
    func modelWon() -> Bool {
        return deck.modelHandEmpty()
    }
    
    func isDone() -> Bool {
        return finished
    }
    
    func getCurrentPlayer() -> Player {
        return currentPlayer
    }
    
    func isLegalMove(card: Card) -> Bool {
        return deck.isLegalMove(card: card)
    }
    
    func getPlayerHand() -> [Card] {
        return deck.getPlayerHand()
    }
    
    func getModelHand() -> [Card] {
        return deck.getModelHand()
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
    
}
