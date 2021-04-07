// Swift class of ACT-R model for Sevens

//import Model

class sevensACTR {

    // --------------------
    // stored variables
    // --------------------
    private var model: Model
    private var legals = ""
    private var twoState = ""
    private var aceHand = ""
    private var choice = ""
    private var hand = [Card]()

    // --------------------
    // Initialize Function
    // --------------------
    init(actrName: String) {
        model = Model()
        model.loadModel(fileName: actrName)
        model.run()
        print("\(String(describing: model.buffers["goal"]))")
    }

    // --------------------
    // Functions
    // --------------------
    
    // Function that runs the model's turn
    func turn(topCard: Card) -> String {

        // Go through hand in case an ace exists
        checkHandForAce()
        
        // Check if top was ace
        if topCard.getRank() == Rank.Ace {
            storeAce(topCard: topCard)
        }
        
        // Count the legal moves in ACT-R's hand
        self.legals = countLegals(topCard: topCard)
        
        // Add legal string into ACT-R's goal buffer as a state
        model.buffers["goal"]!.setSlot(slot: "state", value: self.legals)
        
        // Run the model until it finds an action
        model.run()

        // Perform the ACT-R's action
        self.choice = model.lastAction(slot: "choice")!
        switch self.choice {
        case "draw":
            return self.choice
        case "playOne":
            return self.choice
        case "multipleCheck":
            self.choice = multipleLegals(topCard: topCard)
            return self.choice
        default:
            //TODO: ALfid, something went wrong
            print("ACTR was unable to make a choice")
        }
        return "INVALID" //TODO: is this what we want to do?
    }
    
    // Goes through the hand to check for aces
    func checkHandForAce() {
        for card in hand {
            let rank = card.getRank().rawValue
            if rank == "Ace" {
                let suit = card.getSuit().rawValue
                let aceSuit = "ace" + suit
                let aceChunk = Chunk(s: aceSuit, m: model)
                aceChunk.setSlot(slot: "isa", value: suit)
                model.dm.addToDM(aceChunk)
            }
        }
    }

    // Function that counts legal cards in ACT-R hand
    func countLegals(topCard: Card) -> String{
        
        let topSuit = topCard.getSuit()
        let topRank = topCard.getRank()
        var legal = 0
        
        print("Top: \(String(describing: topSuit)), \(String(describing: topRank))")
        
        // Seperate procedure between Two and Non-Two
        if topRank ==  Rank.II {
            
            // Set state of two in model
            self.twoState = "yes"

            // Assume no legal ace in hand yet
            self.aceHand = "no"
            
            // Count all 2's and matching ace in ACT-R's hand
            for card in hand {
                let rank = card.getRank()
                let suit = card.getSuit()
                
                if rank == Rank.II {
                    legal += 1
                    print("Legal: \(String(describing: suit)), \(String(describing: rank))")
                } else if rank == Rank.Ace && suit == topSuit {
                    legal += 1
                    print("Legal: \(String(describing: suit)), \(String(describing: rank))")
                    self.aceHand = "yes"
                }
            }

        } else {
            
            // Set state of two and ace in model
            self.twoState = "no"
            self.aceHand = "no"

            // Count all cards that match in suit and rank of top card
            for card in hand {

                let rank = card.getRank()
                let suit = card.getSuit()
                print("Checking \(String(describing: suit)), \(String(describing: rank))")
                
                if (rank == topRank || suit == topSuit) {
                    legal += 1
                    print("Legal!")
                }
            }
        }
        
        print("\(String(describing: legal)) legals")
        
        // Turn count of legals into string categories
        if legal == 1 {
            return "oneLegal"
        } else if legal > 1 {
            return "multipleLegal"
        }
        return "noLegal"
    }
    
    // Function that runs when ACT-R must predict a suit
    func predictSuit() {
        
        // Set goal buffer state as predictSuit
        model.buffers["goal"]!.setSlot(slot: "state", value: "predictSuit")

        // Run the model to get the prediction
        model.run()
    }

    // When player draws, remember the top card's suit and rank
    func rememberSuitRank(topCard: Card) {
        let topRank = topCard.getRank()
        let topSuit = topCard.getSuit()
        let suitName = "pred" + topSuit.rawValue
        let rankName = "pred" + topRank.rawValue

        let suitChunk = Chunk(s: suitName, m: self.model)
        suitChunk.setSlot(slot: "isa", value: "prediction")
        suitChunk.setSlot(slot: "specific", value: "suit")
        suitChunk.setSlot(slot: "suitRank", value: topSuit.rawValue)

        let rankChunk = Chunk(s: rankName, m: self.model)
        rankChunk.setSlot(slot: "isa", value: "prediction")
        rankChunk.setSlot(slot: "specific", value: "rank")
        rankChunk.setSlot(slot: "suitRank", value: topRank.rawValue)
        
        model.dm.addToDM(suitChunk)
        model.dm.addToDM(suitChunk)
    }

    // Function that generates a chunk of an ace if it has been used
    func storeAce(topCard: Card) {

        // Double check if top really was ace
        let topRank = topCard.getRank()
        if topRank == Rank.Ace {
            
            // Generate chunk of ace that holds the ace's suit
            let topSuit = topCard.getSuit()
            let aceSuit = "ace" + topSuit.rawValue
            let aceChunk = Chunk(s: aceSuit, m: model)
            aceChunk.setSlot(slot: "isa", value: "discardedAce")
            aceChunk.setSlot(slot: "aceSuit", value: topSuit.rawValue)

            // Add ace chunk into model
            model.dm.addToDM(aceChunk)
        }
    }
    
    // Function that runs when there are multiple legals
    func multipleLegals(topCard: Card) -> String {
        
        // Set goal state, if two was played, and if ace is in hand
        model.buffers["goal"]!.setSlot(slot: "state", value: "multipleProcedure")
        model.buffers["goal"]!.setSlot(slot: "two", value: twoState)
        model.buffers["goal"]!.setSlot(slot: "ace", value: aceHand)
        
        // Run the model
        model.run()

        // If two was not played, count legals and play accordingly
        if model.lastAction(slot: "choice") == "countLegals" {
            
            // Count all legal options into a dictionary
            var legalCounts = [String:Int]()
            let topRank = topCard.getRank()
            let topSuit = topCard.getSuit()

            for card in hand {

                let rank = card.getRank()
                let suit = card.getSuit()

                if rank == topRank {
                    if legalCounts[rank.rawValue] != nil {
                        legalCounts[rank.rawValue]! += 1
                    } else {
                        legalCounts[rank.rawValue] = 1
                    }
                } else if suit == topSuit {
                    // Cannot play multiple suits, so always 1 if present
                    legalCounts[suit.rawValue] = 1
                }
            }
            
            // Grab max value of dictionary
            // Only hold suits and ranks with max count
            var maxSuitRanks = [String]()
            let maxSuitRank = legalCounts.values.max()
            print("maxSuitRank: \(String(describing: maxSuitRank))")
            for (suitRank, count) in legalCounts {
                if (count == maxSuitRank) {
                    maxSuitRanks.append(suitRank)
                    print("\(String(describing: suitRank)) has max count in hand!")
                }
            }

            // If only one suitRank, then clearly a rank with more than one count
            // Play the rank;
            // If more than one suitRank, predictSuit and play card with suit if possible
            print("There are \(String(describing: maxSuitRanks.count)) legal(s) suitRank(s) with max count.")
            if maxSuitRanks.count == 1 {
                model.buffers["action"]!.setSlot(slot: "choice", value: "bestRank")
                model.buffers["action"]!.setSlot(slot: "rank", value: maxSuitRanks[0])
            } else {
                predictSuit()
            }
        }

        // Return the choice made
        // If it is a prediction, grab "predict" slot from action buffer for suitRank
        print("ACTR Choice: \(String(describing: model.lastAction(slot: "choice")!))")
        return model.lastAction(slot: "choice")!
    }
    
    func getHand() -> [Card] {
        return hand
    }
    
    func setHand(newHand: [Card]) {
        hand = newHand
    }
    
    func getPredictedSuit() -> Suit {
        //TODO: Might return nil
        return suitStringToSuit(suitString: model.lastAction(slot: "predict")!)
    }
    
    func getBestRank() -> Rank {
        return rankStringToRank(rankString: model.lastAction(slot: "rank")!)
    }
    
    func getLastAction() -> String? {
        return self.model.lastAction(slot: "predict")
    }
}
