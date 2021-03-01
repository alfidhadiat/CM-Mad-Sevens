//
//  Deck.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import Foundation

class Deck {
    
    var stack = [Card]()
    var discard = [Card]()
    var playerHand = [Card]()
    var modelHand = [Card]()
    
    init() {
        initialize()
    }

    /** At initialization, all cards are added to the stack, it'll be shuffled, and the players receive their first set of cards.
     */
    func initialize() {
        for i in Suit.allCases {
            for j in Rank.allCases {
            let card = Card(suit: i, rank: j)
                stack.append(card)
            }
        }
        print("The stack has been initialized! Stack: \n\(stack)")
        stack.shuffle()
        print("The initialized stack has been shuffled! Stack: \n\(stack)")
        // Give both the player and the model 5 cards
        for _ in 0...4 {
            drawcard(player: CurrentPlayer.player)
            drawcard(player: CurrentPlayer.model)
        }
        // Opening card of the game
        drawcard(player: CurrentPlayer.setup)
    }
    
    /** Whenever a new game is started, all cards are being removed, and the game will be re-initialized.
    */
    func newGame() {
        stack.removeAll()
        discard.removeAll()
        playerHand.removeAll()
        modelHand.removeAll()
        initialize()
    }
    
    /** When someone wants to draw a card, first we check if there are any cards left in the stack. If not, we shuffle the discardpile (except for the top card) and add them to the stack. If there are no cards in the discardpile, we reached an impasse and the game will be terminated.
    */
    func drawcard(player: CurrentPlayer) {
        if stack.isEmpty {
            shuffleDiscardPile()
        }
        if stack.isEmpty {
            print("ERROR, we've reached an impasse.")
            exit(0)
        }
        if player == CurrentPlayer.model {
            modelHand.append(stack.remove(at: stack.startIndex))
        } else if player == CurrentPlayer.player {
            playerHand.append(stack.remove(at: stack.startIndex))
        } else if player == CurrentPlayer.setup {
            discard.append(stack.remove(at: stack.startIndex))
        }
    }
    
    /** All cards in the discard pile, except for the top card, will be shuffled and added to the stack. The top card of the discard pile will remain the top card.
    */
    func shuffleDiscardPile() {
        let topCard = discard.remove(at: discard.endIndex)
        discard.shuffle()
        while !discard.isEmpty {
            stack.append(discard.remove(at: discard.startIndex))
        }
        discard.append(topCard)
    }
}
