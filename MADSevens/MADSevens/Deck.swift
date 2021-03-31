//
//  Deck.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import Foundation

class Deck {
    
    public var stack = [Card]()
    private var discard = [Card]()
    private var playerHand = [Card]()
    private var modelHand = [Card]()
    private var discardSuit: Suit?
    
    init() {
        print("INIT Deck! -----------------------------")
        initialize()
    }

    /** At initialization, all cards are added to the stack, it'll be shuffled, and the players receive their first set of cards.
     */
    func initialize() {
        print("INITILIZING Deck! -----------------------------")
        discardSuit = nil
        for i in Suit.allCases {
            for j in Rank.allCases {
            let card = Card(suit: i, rank: j)
                stack.append(card)
            }
        }
//        print("The stack has been initialized! Stack: \n\(stack)")
        stack.shuffle()
//        print("The initialized stack has been shuffled! Stack: \n\(stack)")
        // Give both the player and the model 5 cards
        for _ in 0...4 {
            drawCard(player: Player.player)
            drawCard(player: Player.model)
        }
        // Opening card of the game
        drawCard(player: Player.setup)
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
    
    func drawCard(player: Player) {
        if stack.isEmpty {
            shuffleDiscardPile()
        }
        if stack.isEmpty {
            print("ERROR, we've reached an impasse.")
            exit(0)
        }
        if player == Player.model {
            modelHand.append(stack.remove(at: stack.startIndex))
        } else if player == Player.player {
            playerHand.append(stack.remove(at: stack.startIndex))
        } else if player == Player.setup { //Needed for setting up the game
            discard.append(stack.remove(at: stack.startIndex))
        }
    }

    func playCard(card: Card, player: Player, newSuit: Suit?) {
        switch player {
        case Player.player:
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
                print("Player doesn't have this card!")
            }
        case Player.model:
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
                print("Model doesn't have this card!")
            }
        default:
            print("Unknown who wants to play a card, error!")
        }
        if newSuit != nil {
            discardSuit = newSuit
        }
    }
    
    /** All cards in the discard pile, except for the top card, will be shuffled and added to the stack. The top card of the discard pile will remain the top card.
    */
    func shuffleDiscardPile() {
        print("Shuffling!")
        let topCard = discard.remove(at: discard.endIndex-1)
        discard.shuffle()
        while !discard.isEmpty {
            stack.append(discard.remove(at: discard.startIndex))
        }
        discard.append(topCard)
    }
    
    func updateDeck() -> String {
        var state = "full"
        let stackCount = stack.count
        if (stackCount <= 17) {
            state = "threeq"
        } else if (stackCount <= 13) {
            state = "half"
        } else if (stackCount <= 9){
            state = "oneq"
        } else if (stackCount <= 5) {
            state = "low"
        }
            return state
    }
    
    // marieke pls help: right here we wanted to do something that counts nr of cards in deck. Depending on this count, a string should be obtained. Then we could use this string to update the state variable within the DeckView, which would lead to a deck getting displayed in different levels (half, full, low, etc.). We're not sure where the update should be.
    
    func playerHandEmpty() -> Bool {
        return playerHand.isEmpty
    }
    
    func modelHandEmpty() -> Bool {
        return modelHand.isEmpty
    }
    
    func legalMove(card: Card) -> Bool {
        if card.getRank() == getCurrentRank() {
            return true
        }
        if card.getSuit() == getCurrentSuit() {
            return true
        }
        if card.getRank() == Rank.VII {
            return true
        }
        return false
    }

    func getDeckCount() -> Int {
        return stack.count
    }
    
    func getCurrentRank() -> Rank {
        return discard[discard.endIndex-1].getRank()
    }
    
    func getNewRank() -> Rank {
        return stack[stack.startIndex+1].getRank()
    }
    
    func getNewSuit() -> Suit {
        return stack[stack.startIndex+1].getSuit()
    }
    
    func getCurrentSuit() -> Suit {
        if discardSuit == nil {
            return discard[discard.endIndex-1].getSuit()
        } else {
            return discardSuit!
        }
    }
    
    func getPlayerHand() -> [Card] {
        return playerHand
    }

    func getModelHand() -> [Card] {
        return modelHand
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
        return discard[discard.endIndex-1]
    }
    
}
