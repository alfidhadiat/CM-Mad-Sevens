//
//  Card.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import Foundation

/**
 The card struct contains a cards suit and rank, including getters for these values.
 */
struct Card {
    
    private var suit: Suit
    private var rank: Rank
    
    init(suit: Suit, rank: Rank) {
        self.suit = suit
        self.rank = rank
    }
    
    func getSuit() -> Suit {
        return suit
    }
    
    func getRank() -> Rank {
        return rank
    }
}
