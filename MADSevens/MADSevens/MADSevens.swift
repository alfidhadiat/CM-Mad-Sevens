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
}
