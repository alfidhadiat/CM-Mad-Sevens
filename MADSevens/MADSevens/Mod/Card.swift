//
//  Card.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import Foundation

struct Card {
    //Reminder: value semantics!
    
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
