//
//  MADSevens.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import Foundation

class MADSevens {
    
    private var deck: Deck
    private var currentPlayer: CurrentPlayer
    private var finished: Bool
//    private var model: ACTRModel
    
    init() {
        print("Intitializing new MADSevens game \n")
        deck = Deck()
        currentPlayer = CurrentPlayer.player
        finished = false
    }
    
    func newGame() {
        print("Starting new MADSevens game")
        deck.newGame()
        currentPlayer = CurrentPlayer.player
        finished = false
    }
    
    func drawCard(player: CurrentPlayer) {
        self.deck.drawCard(player: player)
    }
    
    
    func getTopDiscardCard() -> Card {
        return deck.getTopDiscardCard()
    }
    
    func playCard(card: Card, player: CurrentPlayer) {
        self.deck.playCard(card: card, player: player)
    }
    
    
    /**
     Pass the turn to the other player, check if someone has no cards left and therefore won the game
     */
    func passTurn() {
        if (self.currentPlayer == CurrentPlayer.model) {
            self.currentPlayer = CurrentPlayer.player
        } else {
            self.currentPlayer = CurrentPlayer.model
        }
        // When passing the turn, check if the game has ended
        if (playerWon() || modelWon()) {
            finished = true
        }
    }
    
    func modelTurn() {
        //Here, the model is called, and afterwards his move is executed
        //E.g. decide to draw a card:
        drawCard(player: CurrentPlayer.model)
        passTurn()
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
    
    func getCurrentPlayer() -> CurrentPlayer {
        return currentPlayer
    }
    
}
