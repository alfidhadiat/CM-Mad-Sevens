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
    private var numberOfActiveTwos: Int
    
    init() {
        print("INIT Deck! -----------------------------")
        numberOfActiveTwos = 0
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
        numberOfActiveTwos = 0
        initialize()
    }
    
    
    /** When someone wants to draw a card, first we check if there are any cards left in the stack. If not, we shuffle the discardpile (except for the top card) and add them to the stack. If there are no cards in the discardpile, we reached an impasse and the game will be terminated.
    */
    func drawOneCard(player: Player) {
        print("In func drawOneCard!")
        if stack.isEmpty {
            shuffleDiscardPile()
        }
        if stack.isEmpty {
            print("ERROR, we've reached an impasse.")
            exit(0)
        }
        if player == Player.model {
            modelHand.append(stack.remove(at: stack.startIndex))
        }
        if player == Player.player {
            playerHand.append(stack.remove(at: stack.startIndex))
        }
        if player == Player.setup { //Needed for setting up the game
            discard.append(stack.remove(at: stack.startIndex))
        }
    }
    
    /**
     Draw a single card if no two on top, draw two times the number of two's on top of the discardpile othersiwe.
     */
    func drawCard(player: Player) {
        print("In func drawCard!")
        drawOneCard(player: player)
        while numberOfActiveTwos > 0 {
            print("There is a two on top!")
            numberOfActiveTwos -= 1
            drawOneCard(player: player)
            // for the top two, take only one extra card
            if numberOfActiveTwos != 0 {
                drawOneCard(player: player)
            }
        }
    }
    
    /**
     Play a card for a certain player, in case of a seven also update the value of newSuit to reflect the chosen suit.
     */
    func playCard(card: Card, player: Player, newSuit: Suit?) {
        if !legalMove(card: card) {
            print("How did you do this, shouldn't be possible. Drawing a card.")
            drawCard(player: player)
            return
        }
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
                if card.getRank() == Rank.II {
                    numberOfActiveTwos += 1
                } else {
                    numberOfActiveTwos = 0
                }
            } else {
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
                if card.getRank() == Rank.II {
                    numberOfActiveTwos += 1
                } else {
                    numberOfActiveTwos = 0
                }
            } else {
                //TODO: what to do now?
                print("Model doesn't have this card!")
            }
        default:
            print("Unknown who wants to play a card, error!")
        }
        // Update value of discardSuit
        discardSuit = nil
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
        }
        if (stackCount <= 13) {
            state = "half"
        }
        if (stackCount <= 9){
            state = "oneq"
        }
        if (stackCount <= 5) {
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
    
    /**
         Returns true in case a card is considered a legal move.
         */
        func legalMove(card: Card) -> Bool {
            if getCurrentRank() == Rank.II  && numberOfActiveTwos > 0 {
                if card.getRank() == Rank.II {
                    return true
                }
                if card.getRank() == Rank.Ace && card.getSuit() == getCurrentSuit() {
                    return true
                }
            } else {
                if card.getRank() == getCurrentRank() {
                    return true
                }
                if card.getSuit() == getCurrentSuit() {
                    return true
                }
                if card.getRank() == Rank.VII {
                    return true
                }
            }
            
            return false
        }
    
    /**
     Returns true in case this card is a legal move to play as a second card, i.e. when someone already played an eight of hearts, an eight of acorns/leaves/pumpkins is considered a legal move.
     */
    
    func secondLegalMove(card: Card) -> Bool {
        if card.getRank() == getCurrentRank() {
            return true
        }
        return false
    }
    
    func getCurrentRank() -> Rank {
        return discard[discard.endIndex-1].getRank()
    }
    
    func getCurrentSuit() -> Suit {
        if discardSuit == nil {
            return discard[discard.endIndex-1].getSuit()
        } else {
            return discardSuit!
        }
    }
    
    func setNewSuit(newSuit: Suit) {
        discardSuit = newSuit
    }
    
    func getPlayerHand() -> [Card] {
        return playerHand
    }

    func getModelHand() -> [Card] {
        return modelHand
    }
    
    func getDeckCount() -> Int {
        return stack.count
    }
    
    func getNewRank() -> Rank {
        return stack[stack.startIndex].getRank()
    }
    
    func getNewSuit() -> Suit {
        return stack[stack.startIndex].getSuit()
    }
    
    func getTopDiscardCard() -> Card {
        return discard[discard.endIndex-1]
    }
    
    func getAnyDiscardCard(index: Int) -> Card {
        return discard[discard.endIndex-index]
    }
    
    func getActiveTwos() -> Int {
        return numberOfActiveTwos
    }
    
    // A function for changing the legality of the card based on a color switch
//    func legalMove_color(card: Card, suit: Suit) -> Bool {
//        if suit == Suit.Acorn {
//            if card.getSuit() == Suit.Acorn{
//                return true
//            }
//        }
//        if suit == Suit.Pumpkins {
//            if card.getSuit() == Suit.Pumpkins{
//                return true
//            }
//        }
//        if suit == Suit.Hearts {
//            if card.getSuit() == Suit.Hearts{
//                return true
//            }
//        }
//        if suit == Suit.Leaves {
//            if card.getSuit() == Suit.Leaves{
//                return true
//            }
//        }
//        if card.getRank() == Rank.VII {
//            return true
//        }
//        return false
//    }
    
    
//    func playFirstCard(player: CurrentPlayer) {
//        if player == CurrentPlayer.model {
//            discard.append(modelHand.remove(at: 0))
//        }
//        if player == CurrentPlayer.player {
//            discard.append(playerHand.remove(at: 0))
//        }
//    }
}
