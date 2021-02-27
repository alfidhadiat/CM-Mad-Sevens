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
enum CurrentPlayer: String {
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
    case Pumpkin
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

