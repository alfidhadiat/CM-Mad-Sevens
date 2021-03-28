// Swift class of ACT-R model for Sevens

import Model

class actr {

    // --------------------
    // stored variables
    // --------------------
    var model
    var legals: String
	var twoState: String
	var aceHand: String
	var choice: String
	var top: Card
	var hand: [Card]

    // --------------------
    // Initialize Function
    // --------------------
    init(actrName: String) {
        self.model = Model(actrName)
    }    

    // --------------------
    // Functions
    // --------------------
	
	// Function that counts legal cards in ACT-R hand
    func countLegals() -> legals:String{
		
		let topSuit = top.getSuit().rawValue
		let topRank = top.getRank().rawValue
		
        // Seperate procedure between Two and Non-Two
        if topSuit == "II" {
			
			// Set state of two in model
			self.twoState = "yes"

			// Assume no legal ace in hand yet
			self.aceHand = "no"
			
			// Count all 2's and matching ace in ACT-R's hand
			for card in actr.hand {
				let rank = card.getRank().rawValue
				let suit = card.getSuit().rawValue
				
				if rank == "II" {
					legal += 1
				} else if rank == "Ace" && suit == topSuit{
					legal += 1
					self.aceHand = "yes"
				}
			}	

		} else {
			
			// Set state of two and ace in model
			self.twoState = "no"
			self.aceHand = "no"

			// Count all cards that match in suit and rank of top card
			for card in actr.hand {

				let rank = card.getRank().rawValue
				let suit = card.getSuit().rawValue

				if rank == topRank {
					legal += 1
				} else if suit == topSuit {
					legal += 1
				}
			}
		}
		
		// Turn count of legals into string categories
		if legal < 1 {
			return "noLegal"
		} else if legal == 1 {
			return "oneLegal"
		} else if legal > 1 {
			return "multipleLegal"
		}
    }
	
	// Function that generates a chunk of an ace if it has been used
	func storeAce() {

		// Double check if top really was ace
		let topRank = top.getRank().rawValue
		if topRank == "Ace" {
			
			// Generate chunk of ace that holds the ace's suit
			let topSuit = top.getSuit().rawValue
			var aceSuit = "ace" + topSuit
			aceChunk = Chunk(aceSuit, model)
			aceChunk.slotvals["isa"] = "discardedAce"
			aceChunk.slotvals["aceSuit"] = topSuit

			// Add ace chunk into model
			model.dm.addToDm(aceChunk)
		}	
	}		
	
	// Stores suit and rank of card that caused player to draw
	func storePlayerDraw(card: Card) {
		let suit = card.suit
		let rank = card.rank
		
	}
	
	// Function that runs the model when it is its turn
	func turn() {
		
		// Count the legal moves in ACT-R's hand
		self.legals = countLegals()
		
		// Add legal string into ACT-R's goal buffer as a state
		model.buffers["goal"]!.setSlot("state", self.legals)
		
		// Run the model until it finds an action
		model.run()

		// Perform the ACT-R's action
		self.choice = model.lastAction("choice")
		switch self.choice {
		case "draw":
			return self.choice 
		case "playOne":
			return self.choice
		case "multipleCheck":
			self.choice = multipleLegals()
			return self.choice
		}
	}
	
	// Function that runs when ACT-R must predict a suit
	func predictSuit() -> suitPrediction: String {
		
		// Set goal buffer state as predictSuit
		model.buffers["goal"]!.setSlot("state", "predictSuit")

		// Run the model to get the prediction
		model.run()

		// Return the prediction
		return model.lastAction("predict")
	}
	
	// Function that runs when there are multiple legals
	func multipleLegals() -> choice: String {
		
		// Set goal state, if two was played, and if ace is in hand
		model.buffers["goal"]!.setSlot("state", "multipleProcedure")
		model.buffers["goal"]!.setSlot("two", self.twoState)
		model.buffers["goal"]!.setSlot("ace", self.aceHand)
		
		// Run the model
		model.run()

		// If two was not played, count legals and play accordingly
		if model.lastAction("choice") == "countLegals" {
			
			// Count all legal options into a dictionary
			var legalCounts = [String:Int]()
			let topRank = top.getRank().rawValue
			let topSuit = top.getSuit().rawValue

			for card in actr.hand {

				let rank = card.getRank().rawValue
				let suit = card.getSuit().rawValue

				if rank == topRank {
					legalCounts[rank] += 1
				} else if suit == topSuit {
					// Cannot play multiple suits, so always 1 if present
					legalCounts[suit] = 1
				}
			}
			
			// Grab max value of dictionary
			// Only hold suits and ranks with max count
			var maxSuitRanks: [String]()
			let maxSuitRank = legalCounts.max{a, b in a.rank < b.rank}
			for (suitRank, count) in legalCounts {
				if (count == maxSuitRank) {
					maxSuitRanks.append(suitRank)
				}
			}	 

			// If only one suitRank, then clearly a rank with more than one count
			// Play the rank;
			// If more than one suitRank, predictSuit and play card with suit if possible
			if maxSuitRanks.count == 1 {
				model.buffers["action"]!.setSlot("choice", "bestRank")
				model.buffers["action"]!.setSlot("rank", maxSuitRanks[0])
			} else {
				model.predictSuit()
			}
		}

		// Return the choice made
		// If it is a prediction, grab "predict" slot from action buffer for suitRank
		return model.lastAction("choice")
	}
}	

    /*************************
    The procedure for the ACT-R's turn
    *************************/
    func actrTurn() {

        // First, put current ACTR hand and top discard into ACTR
        actr.hand = getHand(player.Model)
        actr.top = deck.getTopDiscardCard()

        // Go through the model's turn to generate a "choice"
        choice = actr.turn()

        // Switch cases depending on the choice made
        // After a choice is played, pass the turn again
        switch choice {

            // When ACT-R has no legal hand, the choice is "draw"
            case "draw":
                game.drawCard(player: game.getCurrentPlayer())
                game.passTurn()

            // When ACT-R has only one legal, the choice is "playOne"
            case "playOne":
                for (card in actr.hand) {
                    if deck.isLegalMove(card: card) == True {
                        let onlyLegal = card
                    }
                }
                if onlyLegal.rank == Rank.VII {
                    let newSuit = actr.predictSuit()
                } else {
                    let newSuit = nil
                }
                game.playCard(card: onlyLegal, player: game.getCurrentPlayer(), newSuit: newSuit)
                game.passTurn()

            // When ace is legal against a two, choice is "playAce"
            case "playAce":
                for (card in actr.hand) {
                    if card.rank == Rank.Ace {
                        let aceCard = card
                    }
                }
                game.playCard(card: aceCard, player: game.getCurrentPlayer(), newSuit: newSuit)
                game.passTurn()

            // When choice is "prediction", try play a card with the suit
            case "prediction":
                var predictSuit = actr.model.lastAction("predict")
                var cardSuit: String
                var playCard: Card
                var suitMatched = "no"
                for (card in actr.hand) {
                    cardSuit = card.getSuit().rawValue
                    if (cardSuit == predictSuit) {
                        playCard = card
                        suitMatched = "yes"
                    }
                }
                if (suitMatched = "no") {
                    
                }
                game.playCard(card: playCard, player: game.getCurrentPlayer())
                game.passTurn()
			
			// When not against two and legal option with more than one count,
			// it can only be a rank, so choice is "bestRank"
			case "bestRank":
				let rank = actr.model.lastAction("rank")
				var cards: [Card]
				for (card in actr.hand) {
					let rank = card.getRank().rawValue
					if rank == suitRank {
						cards.append(card)	
					}
        		}
				// !!! Need a game method that plays multiple rank cards
            
            // If II played and no ace available, choice is "checkAce"
            case "checkAce":
                // If predict slot is not nil, check if ace suit is in hand
                if actr.model.lastAction("predict") != "nil" {
                    let aceSuit = model.lastAction("predict")
                    var twoExists = "no"
                    for (card in actr.hand) {
                        let cardSuit = card.getSuit().rawValue
                        let cardRank = card.getRank().rawValue
                        if (cardRank == "II" && cardSuit == aceSuit) {
                            let safeTwo = card
                            twoExists = "yes"
                        }
                    }
                    // If a II in hand matches suit with ace, play it
                    // Else if no II matches suit, play a random II
                    if twoExists == "yes" {
                        let playTwo = safeTwo
                    } else if twoExists == "no" {
                        for (card in actr.hand) {
                            let cardRank = card.getValue().rawValue
                            var playTwo: Card
                            if (cardRank == "II") {
                                playTwo = card
                            }
                        }
                    }
                } else if actr.model.lastAction("predict") == "nil" {
                    var playTwo: Card
                    for (card in actr.hand) {
                        let cardRank = card.getValue().rawValue
                        if (cardRank == "II") {
                            playTwo = card
                        }
                    }
                }