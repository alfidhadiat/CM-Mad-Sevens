//
//  Deck.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import Foundation

/**
 The deck holds all cards of the German suited deck in either the stack, discard pile, playerhand or modelhand. It can execute moves (both playing and drawing of cards), check the legality of a move and shuffles the discard pile in case the stack is empty. 
 */
class Deck {
    
    public var stack = [Card]()
    private var discard = [Card]()
    private var playerHand = [Card]()
    private var modelHand = [Card]()
    // Indicates the newly chosen suit in case a seven is played
    private var discardSuit: Suit?
    // Indicates the number of active two's are on top of the discard pile, they would cause a player having to draw (a multiple of) two cards.
    private var numberOfActiveTwos: Int
    
    /**
     Initializes the deck. As resetting the game also requires to reinitialize the deck, most funcionallity is moved to the initialize funcion.
     */
    init() {
        print("INIT Deck! -----------------------------")
        numberOfActiveTwos = 0
        initialize()
    }

    /**
     Upon initialization, all cards are added to the stack, it'll be shuffled, the players receive their first set of cards and an opening card will be added to the discard pile.
     */
    func initialize() {
        print("INITILIZING Deck! -----------------------------")
        discardSuit = nil
        // Add all cards to the deck
        for i in Suit.allCases {
            for j in Rank.allCases {
            let card = Card(suit: i, rank: j)
                stack.append(card)
            }
        }
        stack.shuffle()
        // Give both the player and the model 5 cards
        for _ in 0...4 {
            drawCard(player: Player.player)
            drawCard(player: Player.model)
        }
        // Opening card of the game
        drawCard(player: Player.setup)
    }
    
    /**
     Whenever a new game is started, all cards are being removed, and the game will be re-initialized.
    */
    func newGame() {
        stack.removeAll()
        discard.removeAll()
        playerHand.removeAll()
        modelHand.removeAll()
        numberOfActiveTwos = 0
        initialize()
    }
    
    
    /**
     When someone wants to draw a card, first we check if there are any cards left in the stack. If not, we shuffle the discardpile (except for the top card since this one is still 'active') and add them to the stack. If there are no cards in the discardpile, we reached an impasse and the game will be terminated. The drawn card will be added to the current players' hand, or to the discard pile in case we're setting up the game and this card will be the opening card.
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
        } else if player == Player.player {
            playerHand.append(stack.remove(at: stack.startIndex))
        } else if player == Player.setup {
            //Needed for setting up the game, adds the opening card
            discard.append(stack.remove(at: stack.startIndex))
        }
    }
    
    /**
     Draw a single card if there is no active two on top of the discard pile. Othersiwe draw two times the number of active two's on top of the discardpile.
     */
    func drawCard(player: Player) {
        drawOneCard(player: player)
        while numberOfActiveTwos > 0 {
            print("There is an active two on top!")
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
        // The card should have already been checked on legality, so this should not occur.
        if !legalMove(card: card) {
            print("How did you do this, shouldn't be possible. Drawing a card.")
            drawCard(player: player)
            return
        }
        // Depending on the player, retrieve the card from the hand and move to the discard pile.
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
        // Update value of discardSuit if present, otherwise set to nil.
        discardSuit = nil
        if newSuit != nil {
            discardSuit = newSuit
        }
    }
    
    /**
     All cards in the discard pile, except for the top card, will be shuffled and added to the stack. The top card of the discard pile will remain the top card.
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
    
    /**
     Indicates the size of the stack, to display in the UI.
     */
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
    
    /**
     Returns true in case the player's hand is empty
     */
    func playerHandEmpty() -> Bool {
        return playerHand.isEmpty
    }
    
    /**
     Returns true in case the model's hand is empty
     */
    func modelHandEmpty() -> Bool {
        return modelHand.isEmpty
    }
    
    /**
     Returns true in case a card is considered a legal move.
    */
    func legalMove(card: Card) -> Bool {
        // If the top card is an active two, only another two or a same suited Ace is a valid response.
        if getCurrentRank() == Rank.II  && numberOfActiveTwos > 0 {
            if card.getRank() == Rank.II {
                return true
            }
            if card.getRank() == Rank.Ace && card.getSuit() == getCurrentSuit() {
                return true
            }
        // Else, either the suit or rank should match the current suit or rank. A seven is always a legal move.
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
        // Only cards with the same rank are considered a legal move.
        if card.getRank() == getCurrentRank() {
            return true
        }
        return false
    }
    
    // -----------------------------------Getters and Setters-----------------------------------
    func getCurrentRank() -> Rank {
        return discard[discard.endIndex-1].getRank()
    }
    
    /**
     Returns the suit of the card on top of the discard pile, or the newly chosen suit in case a seven has just been played.
     */
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
}
