//
//  Card.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import Foundation

struct Card {
    
    var suit: Suit
    var rank: Rank
    
    init(suit: Suit, rank: Rank) {
        self.suit = suit
        self.rank = rank
    }
    
    func isLegalMove(discardSuit: Suit, discardRank: Rank) -> Int {
        if discardSuit == self.suit {
            return 1
        }
        if discardRank == self.rank {
            return 1
        }
        //TODO Don't think this is correct, check with David
        if rank == Rank.VII {
            return 1
        }
        return 0
    }
}
