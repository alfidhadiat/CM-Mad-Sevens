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
        // seperate if two is played
        if top.rank == "two" {
			
			// Set state of two in model
			self.twoState = "yes"

			// Assume no legal ace in hand yet
			self.aceHand = "no"
			
			// Count all 2's and matching ace in ACT-R's hand
			for card in actr.hand {
				if card.rank == "two" {
					legal += 1
				} else if card.rank == "ace" && card.suit == top.suit {
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
				if card.rank == top.rank {
					legal += 1
				} else if card.suit == top.suit {
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
		if top.rank == "ace" {
			
			// Generate chunk of ace that holds the ace's suit
			var aceSuit = "ace" + top.suit
			aceChunk = Chunk(aceSuit, model)
			aceChunk.slotvals["isa"] = "discardedAce"
			aceChunk.slotvals["aceSuit"] = top.suit

			// Add ace chunk into model
			model.dm.addToDm(aceChunk)
		}	
	}		
	
	// Stores suit and rank of card that caused player to draw
	func storePlayerDraw(card: Card) {
		
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

		// If two played, then check for ace
		if model.buffers["goal"]!.slotValue("state") == "checkAce" {
			if model.lastAction("choice") == "nil" {
				model.buffer["goal"]!.setSlot("state", "predictSuit")
				model.run()
			}
		}

		// If two was not played, count legals and play accordingly
		if model.lastAction("choice") == "countLegals" {
			
			// Count all legal options into a dictionary
			var legalCounts = [String:Int]()
			for card in actr.hand {
				if card.rank == top.rank {
					legalCounts[card.rank] += 1
				} else if card.suit == top.suit {
					legalCounts[card.suit] += 1
				}
			}
			
			// Grab max value of dictionary
			// Only hold suits and ranks with max count
			var maxSuitValues: [String]()
			let maxSuitValue = legalCounts.max{a, b in a.rank < b.rank}
			for (suitValue, count) in legalCounts {
				if (count == maxSuitValue) {
					maxSuitValues.append(suitValue)
				}
			}	 

			// If only one suitValue, return it; else, predict suit
			if maxSuitValues.count == 1 {
				model.buffers["action"]!.setSlot("choice", maxSuitValues[0])
			} else {
				model.buffers["goal"]!.setSlot("state", "predictSuit")
				model.run()
			}
		}

		// Return the choice made
		// If it is a prediction, grab "predict" slot from action buffer for suitValue
		return model.lastAction("choice")
	}
		
}	
