//
//  MADSevens.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import Foundation

class MADSevens {
    
    var deck: Deck
    var currentPlayer = CurrentPlayer.setup
    
    init() {
        print("Intitializing new MADSevens game \n")
        deck = Deck()
        currentPlayer = CurrentPlayer.player
    }
    
    func newGame() {
        deck.newGame()
    }
    
}
