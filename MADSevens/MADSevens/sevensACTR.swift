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
	
	// Function that runs the model's turn
	func turn() {

		// Go through hand in case an ace exists
		checkHandForAce()
		
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
	
	// Goes through the hand to check for aces
	func checkHandForAce() {
		for card in actr.hand {
			let rank = card.getRank().rawValue
			if rank == "Ace" {
				let suit = card.getSuit().rawValue
				var aceSuit = "ace" + suit
				aceChunk = Chunk(aceSuit, model)
				aceChunk.slotvals["isa"] = "discardedAce"
				aceChunk.slotvals["aceSuit"] = suit
				self.model.dm.addToDm(aceChunk)
			}
		}
	}

	// Function that counts legal cards in ACT-R hand
    func countLegals() -> legals:String{
		
		let topSuit = top.getSuit().rawValue
		let topRank = top.getRank().rawValue
		var legal = 0

        // Seperate procedure between Two and Non-Two
        if topRank == "II" {
			
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
	
	// Function that runs when ACT-R must predict a suit
	func predictSuit() -> suitPrediction: String {
		
		// Set goal buffer state as predictSuit
		model.buffers["goal"]!.setSlot("state", "predictSuit")

		// Run the model to get the prediction
		model.run()

		// Return the prediction
		return model.lastAction("predict")
	}

	// When player draws, remember the top card's suit and rank
	func rememberSuitRank() {
		let topRank = top.getRank().rawValue
		let topSuit = top.getSuit().rawValue
		let suitName = "pred" + topSuit
		let rankName = "pred" + topRank

		var suitChunk = Chunk(suitName, self.model)
		suitChunk.setSlot(slot: "isa", value: "prediction")
		suitChunk.setSlot(slot: "specific", value: "suit")
		suitChunk.setSlot(slot: "suitRank", value: topSuit)

		var rankChunk = Chunk(rankName, self.model)
		rankChunk.setSlot(slot: "isa", value: "prediction")
		rankChunk.setSlot(slot: "specific", value: "rank")
		rankChunk.setSlot(slot: "suitRank", value: topRank)

		self.model.dm.addToDm(suitChunk)
		self.model.dm.addToDm(rankChunk)
	}

	// Function that generates a chunk of an ace if it has been used
	func storeAce() {

		// Double check if top really was ace
		let topRank = top.getRank().rawValue
		if topRank == "Ace" {
			
			// Generate chunk of ace that holds the ace's suit
			let topSuit = top.getSuit().rawValue
			let aceSuit = "ace" + topSuit
			var aceChunk = Chunk(aceSuit, model)
			aceChunk.setSlot(slot: "isa", value: "discardedAce")
			aceChunk.setSlot(slot: "aceSuit", value: topSuit)

			// Add ace chunk into model
			self.model.dm.addToDm(aceChunk)
		}	
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