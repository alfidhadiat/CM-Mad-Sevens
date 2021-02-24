//
//  Deck.swift
//  MADSevens
//
//  Created by  Alfiuddin Rahadian Hadiat on 24/02/2021.
//

import Foundation

class Deck {
    
    let colors = ["Acorn", "Hearts", "Green", "Pumpkin"]
    let values = ["Ace", "King", "Unter", "II", "VII", "VIII", "IX", "X"]
    
    var cards: [Card]!
    
    var stack: [Card]!
    
    var discard: [Card]!
    
    var playerHand: [Card]!
    
    var modelHand: [Card]!
    
    func drawcard(player: String) {
        if player == "model" {
            modelHand.append(stack.remove(at: 0))
        } else if player == "player" {
            playerHand.append(stack.remove(at: 0))
        }
    }
    
    init() {
        for (i in colors) {
            for (j in values) {
                let card = Card(color = i, value = j)
                stack.append(card)
            }
        }
        stack.shuffle()
    }
    
}
