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
    
    //    func isLegalMove(discardSuit: Suit, discardRank: Rank) -> Bool {
    //        if discardSuit == self.suit {
    //            return true
    //        }
    //        if discardRank == self.rank {
    //            return true
    //        }
    //        if self.rank == Rank.VII {
    //            return true
    //        }
    //        return false
    //    }
}
