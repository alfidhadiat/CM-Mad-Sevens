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
//    private var model: ACTRModel
    
    init() {
        print("Intitializing MADSevens game (INIT OF MADSevens)")
        deck = Deck()
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
    
    func playCard(card: Card, newSuit: Suit?) -> Bool {
        if deck.legalMove(card: card) {
            deck.playCard(card: card, player: currentPlayer, newSuit: newSuit)
            return true
        }
        return false
    }

    func modelTurn() {
        //Here, the model is called, and afterwards his move is executed
        //E.g. decide to draw a card:
        print("Model draws a card")
        drawCard()
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
    
    func getDeckState() -> String {
        return deck.updateDeck()
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
