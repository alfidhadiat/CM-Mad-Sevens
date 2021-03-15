//
//  Deck.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import Foundation

class Deck {
    
    private var stack = [Card]()
    private var discard = [Card]()
    private var playerHand = [Card]()
    private var modelHand = [Card]()
    
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
            drawCard(player: CurrentPlayer.player)
            drawCard(player: CurrentPlayer.model)
        }
        // Opening card of the game
        drawCard(player: CurrentPlayer.setup)
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
    func drawCard(player: CurrentPlayer) {
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
        print("Shuffling!")
        let topCard = discard.remove(at: discard.endIndex)
        discard.shuffle()
        while !discard.isEmpty {
            stack.append(discard.remove(at: discard.startIndex))
        }
        discard.append(topCard)
    }
    
//    func playFirstCard(player: CurrentPlayer) {
//        if player == CurrentPlayer.model {
//            discard.append(modelHand.remove(at: 0))
//        }
//        if player == CurrentPlayer.player {
//            discard.append(playerHand.remove(at: 0))
//        }
//    }
    
    func getTopDiscardCard() -> Card {
        print("EndIndex of discard: \(discard.endIndex)")
        print("Discard pile: \(discard)")
        return discard[discard.endIndex-1]
    }
    
    func playCard(card: Card, player: CurrentPlayer) {
        switch player {
        case CurrentPlayer.player:
            var index = -1
            for i in 0..<playerHand.endIndex {
                if (playerHand[i].getSuit() == card.getSuit() && playerHand[i].getRank() == card.getRank()) {
                    index = i
                }
            }
            if (index != -1) {
                discard.append(playerHand.remove(at: index))
            } else {
                //TODO: what to do now?
                print("Invalid move!")
            }
        case CurrentPlayer.model:
            var index = -1
            for i in 0..<modelHand.endIndex {
                if (modelHand[i].getSuit() == card.getSuit() && modelHand[i].getRank() == card.getRank()) {
                    index = i
                }
            }
            if (index != -1) {
                discard.append(modelHand.remove(at: index))
            } else {
                //TODO: what to do now?
                print("Invalid move!")
            }
        default:
            print("Unknown who wants to play a card")
        }
    }
    
    func playerHandEmpty() -> Bool {
        return playerHand.isEmpty
    }
    
    func modelHandEmpty() -> Bool {
        return modelHand.isEmpty
    }
}
