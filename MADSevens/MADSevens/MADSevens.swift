//
//  MADSevens.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import Foundation

class MADSevens {
    
    var deck: Deck
    var currentPlayer: CurrentPlayer
    
    init() {
        print("Intitializing new MADSevens game \n")
        deck = Deck()
        currentPlayer = CurrentPlayer.player
    }
    
    func newGame() {
        print("Starting new MADSevens game")
        deck.newGame()
    }
    
    func drawCard(player: CurrentPlayer) {
        self.deck.drawCard(player: player)
    }
    
    func passTurn() {
        if (self.currentPlayer == CurrentPlayer.model) {
            self.currentPlayer = CurrentPlayer.player
        } else {
            self.currentPlayer = CurrentPlayer.model
        }
    }
    
    func getTopDiscardCard() -> Card {
        return deck.getTopDiscardCard()
    }
    
}
