import Foundation

class MADSevens {
    
    private var deck: Deck
    private var currentPlayer: Player
    private var actr: sevensACTR
    
    init() {
        print("Intitializing MADSevens game (INIT OF MADSevens)")
        deck = Deck()
        actr = sevensACTR(actrName: "sevens")
        currentPlayer = Player.player
        printGame()
    }
    
    func newGame() {
        print("Starting new MADSevens game")
        deck.newGame()
        currentPlayer = Player.player
        print("Started a new MADSevens game, this is the current situation")
        printGame()
    }
    
    func drawCard() {
        deck.drawCard(player: currentPlayer)
    }
    
    func setNewSuit(newsuit: Suit) {
        deck.setNewSuit(newSuit: newsuit)
    }
    
//    func playCard(card: Card, newSuit: Suit?) {
//        if currentPlayer == Player.model {
//            sleep(1)
//        }
//        print("\(currentPlayer) tries to play this card: \(card)")
//        if deck.legalMove(card: card) {
//            deck.playCard(card: card, player: currentPlayer, newSuit: newSuit)
//        } else {
//            drawCard()
//            print("Invalid move, a card is drawn for you!")
//        }
//    }
    
    func playCard(card: Card, newSuit: Suit?) -> Bool{
        print("\(currentPlayer) tries to play this card: \(card)")
        if currentPlayer == Player.model {
            sleep(1)
        }
        if deck.legalMove(card: card) {
            deck.playCard(card: card, player: currentPlayer, newSuit: newSuit)
            return true
        } else {
            drawCard()
            print("Invalid move, a card is drawn for you!")
        }
        return false
    }

//    TODO: remove
    func playCard2(card: Card, newSuit: Suit?) -> Bool {
        if deck.legalMove(card: card) {
            deck.playCard(card: card, player: currentPlayer, newSuit: newSuit)
            return true
        }
        return false
    }

    func modelTurn() {
        //Here, the model is called, and afterwards his move is executed
        //E.g. decide to draw a card:
        sleep(1)
        actrTurn()
        printGame()
        passTurn()
    }
    
    /**
     Pass the turn to the other player, check if someone has no cards left and therefore won the game
     */
    func passTurn() {
        if (currentPlayer == Player.model) {
            currentPlayer = Player.player
        } else {
            currentPlayer = Player.model
        }
    }
    
    /**
     Checks wether the end of the game has been reached. If so, displays a message and restarts the game.
     */
    func checkpoint() -> String {
        if (playerWon() || modelWon()) {
            if playerWon(){
                return "Player"
            } else if modelWon() {
                return "Model"
            }
        }
        return "None"
    }
    
    //    func done() -> Bool {
    //        return finished
    //    }
    
    func legalMove(card: Card) -> Bool {
        return deck.legalMove(card: card)
    }
    
    func playerWon() -> Bool {
        return deck.playerHandEmpty()
    }
    
    func modelWon() -> Bool {
        return deck.modelHandEmpty()
    }
    
    func getTopDiscardCard() -> Card {
        return deck.getTopDiscardCard()
    }
    
    func getCurrentSuit() -> Suit {
        return deck.getCurrentSuit()
    }
    
    func getCurrentRank() -> Rank {
        return deck.getCurrentRank()
    }
    
    func getDeckCount() -> Int {
        return deck.getDeckCount()
    }
    
    func getCurrentPlayer() -> Player {
        return currentPlayer
    }
    
    func getPlayerHand() -> [Card] {
        return deck.getPlayerHand()
    }
    
    func getModelHand() -> [Card] {
        return deck.getModelHand()
    }
    
    func rememberSuitRank() {
        actr.rememberSuitRank(topCard: deck.getTopDiscardCard())
    }
    
    func getNewRank() -> Rank {
        return deck.getNewRank()
    }
    
    func getNewSuit() -> Suit {
        return deck.getNewSuit()
    }
    
//    func legalMove_color(card: Card, suit: Suit) -> Bool {
//        return deck.legalMove_color(card: card, suit: suit)
//    }
    
    func getDeckState() -> String {
        return deck.updateDeck()
    }
    
    func printGame() {
        print("Current situation:")
        print("Current player: \(currentPlayer)")
        let modelhand = deck.getModelHand()
        let playerhand = deck.getPlayerHand()
        print("\n Model's hand:")
        for i in 0..<modelhand.endIndex {
            print("\(modelhand[i].getSuit()) - \(modelhand[i].getRank())")
        }
        print("\n Player's hand:")
        for i in 0..<playerhand.endIndex {
            print("\(playerhand[i].getSuit()) - \(playerhand[i].getRank())")
        }
        print("\n Top of the discard pile: \(deck.getTopDiscardCard().getSuit()) - \(deck.getTopDiscardCard().getRank())")
        print(" The current suit is: \(deck.getCurrentSuit())")
    }
    
    /*************************
     The procedure for the ACT-R's turn
     *************************/
    func actrTurn() {
        
        // First, put current ACTR hand and number of active twos in hand
        actr.setHand(newHand: getModelHand())
        actr.setActiveTwos(numberOfActiveTwos: deck.getActiveTwos())
        
        // Go through the model's turn to generate a "choice"
        let choice = actr.turn(currentRank: deck.getCurrentRank(), currentSuit: deck.getCurrentSuit())
        print("Choice retrieved from ACTR: \(choice)")
        
        var didMove = false
        
        // Switch cases that play out the model's choice
        switch choice {
        
        // When ACT-R has no legal hand, the choice is "draw"
        case "draw":
            drawCard()
            didMove = true
            
        // When ACT-R has only one legal, the choice is "playOne"
        case "playOne":
            for card in getModelHand() {
                if deck.legalMove(card: card) {
                    let onlyLegal = card
                    let onlyLegalRank = onlyLegal.getRank()
                    let onlyLegalSuit = onlyLegal.getSuit()
                    print("Only legal card: \(String(describing: onlyLegalSuit)), \(String(describing: onlyLegalRank))")
                    var newSuit: Suit? = nil
                    if onlyLegalRank == Rank.VII {
                        print("Predict the suit for VII!")
                        actr.predictSuit()
                        newSuit = actr.getPredictedSuit()
                        print("The new suit is \(String(describing: newSuit))")
                    }
                    print("Playing \(String(describing: onlyLegalSuit)), \(String(describing: onlyLegalRank))...")
                    playCard(card: onlyLegal, newSuit: newSuit)
                    didMove = true
                    break
                }
            }
//            print("(playOne) Ended up not playing a card.....")
//            drawCard()
            
        // When ace is legal against a two, choice is "playAce"
        case "playAce":
            var aceCard: Card
            for card in getModelHand() {
                let rank = card.getRank()
                let isLegal = deck.legalMove(card: card)
                if (rank == Rank.Ace && isLegal) {
                    aceCard = card
                    playCard(card: aceCard, newSuit: nil)
                    didMove = true
                    break
                }
            }
//            print("(Playace ) Ended up not playing a card.....")
//            drawCard()

            
        // When choice is "prediction", try play a card with the suit
        case "prediction":
            let predictSuit = actr.getPredictedSuit()
            print("Predicting a \(String(describing: predictSuit))")
            var suitMatched = "no"
            
            for card in getModelHand() {
                let isLegal = deck.legalMove(card: card)
                let cardSuit = card.getSuit()
                let cardRank = card.getRank()
                if cardSuit == predictSuit && isLegal {
                    print("Predicted! Playing a \(String(describing: cardSuit)), \(String(describing: cardRank))")
                    if cardRank == Rank.VII {
                        actr.predictSuit()
                        let predictedSuit = actr.getPredictedSuit()
                        print("Playing a VII with \(String(describing: predictedSuit))")
                        playCard(card: card, newSuit: predictedSuit)
                        didMove = true
                        suitMatched = "yes"
                        break
                    } else {
                        playCard(card: card, newSuit: nil)
                        didMove = true
                        suitMatched = "yes"
                        break
                    }
                }
            }
            if suitMatched == "no" {
                for card in getModelHand() {
                    let isLegal = deck.legalMove(card: card)
                    if isLegal {
                        let cardSuit = card.getSuit()
                        let cardRank = card.getRank()
                        print("Playing a \(String(describing: cardSuit)), \(String(describing: cardRank))")
                        playCard(card: card, newSuit: nil)
                        didMove = true
                        break
                    }
                }
            }
//            print("(prediction) Ended up not playing a card.....")
//            drawCard()
//
        // When not against two and legal option with more than one count,
        // it can only be a rank, so choice is "bestRank"
        case "bestRank":
            let bestRank = actr.getBestRank()
            var cards = [Card]()
            for card in getModelHand() {
                let rank = card.getRank()
                if rank == bestRank {
                    cards.append(card)
                }
            }
            actr.predictSuit()
            let predictedSuit = actr.getPredictedSuit()
            var sortedCards = [Card]()
            for card in cards {
                let suit = card.getSuit()
                if suit == predictedSuit {
                    sortedCards.insert(card, at: sortedCards.endIndex)
                } else {
                    sortedCards.insert(card, at: cards.startIndex)
                }
            }
            for card in sortedCards {
                playCard(card: card, newSuit: nil)
                sleep(1)
            }
            didMove = true
            break
            
            
//             Add this function when multiple ranks can be played; for now, just play any legal
//            let bestRank = actr.getBestRank()
//            var cards = [Card]()
//            for card in getModelHand() {
//                let rank = card.getRank()
//                if rank == bestRank {
//                    cards.append(card)
//                    playCard(card: cards[0], newSuit: nil)
//                }
//            }
//            for card in getModelHand() {
//                if deck.legalMove(card: card) {
//                    print("Multiple cards are scary! I'm playing a single card instead...")
//                    playCard(card: card, newSuit: nil)
//                    didMove = true
//                    break
//                }
//            }
//            print("(Bestrank) Ended up not playing a card.....")
        
        // If II played and no ace available, choice is "checkAce"
        case "checkAce":
            // If predict slot is not nil, check if ace suit is in hand
            // TODO: We assume this returns a "nil" if no ace has been played yet
//            var safeTwo: Card
            print("ACTR recalling if Ace was played to play a II")
            let aceSuit = suitStringToSuit(suitString: actr.getLastAction()!)
            print("ACTR recalls \(String(describing: aceSuit))")
            
            for card in getModelHand() {
                let cardSuit = card.getSuit()
                let cardRank = card.getRank()
                if (cardRank == Rank.II && cardSuit == aceSuit) {
                    print("II card matches with recalled Ace!")
                    print("Playing \(String(describing: cardSuit)), \(String(describing: cardRank))!")
                    playCard(card: card, newSuit: nil)
                    didMove = true
                    break
                }
            }
            print("No II in ACTR hand matches the recalled ace...")
            for card in getModelHand() {
                let cardSuit = card.getSuit()
                let cardRank = card.getRank()
                if cardRank == Rank.II {
                    print("Playing \(String(describing: cardSuit)), \(String(describing: cardRank)) anyway.")
                    playCard(card: card, newSuit: nil)
                    didMove = true
                    break
                }
            }
        case "trickRank":
            var rankCounter = [String:Int]()
            let topSuit = getCurrentSuit()
            for card in getModelHand() {
                let rank = card.getRank()
                if rankCounter[rank.rawValue] != nil {
                    rankCounter[rank.rawValue]! += 1
                } else {
                    rankCounter[rank.rawValue] = 1
                }
            }
            let maxRankCount = rankCounter.values.max()
            for (rank, count) in rankCounter {
                if count == maxRankCount {
                    for card in getModelHand() {
                        let cardRank = card.getRank()
                        let cardSuit = card.getSuit()
                        if (cardRank.rawValue == rank && cardSuit == topSuit) {
                            playCard(card: card, newSuit: nil)
                            break
                        }
                    }
                }
            }
            actr.predictSuit()
            let predictedSuit = actr.getPredictedSuit()
            var cards = [Card]()
            for card in getModelHand() {
                let rank = card.getRank()
                let suit = card.getSuit()
                if rank == getCurrentRank() {
                    if suit == predictedSuit {
                        cards.insert(card, at: cards.endIndex)
                    } else {
                        cards.insert(card, at: cards.startIndex)
                    }
                }
            }
            for card in cards {
                playCard(card: card, newSuit: nil)
            }
            didMove = true
            
//            print("(checkace) Ended up not playing a card.....")
//            drawCard()
        default:
//            print("(DEFAULT) Ended up not playing a card.....")
//            drawCard()
            break
        }
    
        
        if !didMove {
            print("No move has been made yet, we draw a card.")
            drawCard()
        }
    }
}
