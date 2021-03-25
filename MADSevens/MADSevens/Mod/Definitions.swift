//
//  CurrentPlayer.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import Foundation

/**
Describes the player whose turn it is. At init, setup is the player, which draws a card from the stack to the discard pile to start the game. Then, the turn is given to the player after which model and player alternate turns.
 */
enum Player: String {
    case model
    case player
    case setup
}

/**
 Describes the suit of a card.
 */
enum Suit: String, CaseIterable {
    case Hearts
    case Acorn
    case Leaves
    case Pumpkins
}

/**
 Describes the rank of a card.
 */
enum Rank: String, CaseIterable {
    case Ace
    case King
    case Unter
    case II
    case VII
    case VIII
    case IX
    case X
}

func suitStringToSuit(suitString: String) -> Suit {
    switch suitString {
    case "Hearts":
        return Suit.Hearts
    case "Acorn":
        return Suit.Acorn
    case "Leaves":
        return Suit.Leaves
    case "Pumpkins":
        return Suit.Pumpkins
    default:
        print("Error, used default suit: Hearts")
        return Suit.Hearts
    }
}

func rankStringToRank(rankString: String) -> Rank {
    switch rankString {
    case "II":
        return Rank.II
    case "VII":
        return Rank.VII
    case "VIII":
        return Rank.VIII
    case "IX":
        return Rank.IX
    case "X":
        return Rank.X
    case "Ace":
        return Rank.Ace
    case "Unter":
        return Rank.Unter
    case "King":
        return Rank.King
    default:
        print("Error, used default rank: II")
        return Rank.II
    }
}
