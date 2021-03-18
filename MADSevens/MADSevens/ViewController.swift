//
//  ViewController.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = MADSevens()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    /**
     Initiates a new game
     */
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        game.printGame()
    }
    
    /**
    Draws a card for the current player, gives the turn to its opponent.
     TODO: Do we want to enable/disable this button whenever its the models turn?
     */
    @IBAction func drawCard(_ sender: UIButton) {
        // draw card, add it to hand
        // give turn to next player
        //TODO: since button is pressed, it's always the player calling this function
        game.drawCard(player: game.getCurrentPlayer())
        game.printGame()
        game.passTurn()
    }
        
    /**
     The selected card (TODO: multiple cards yet to be implemented) will be taken from the player's hand and added to the
     discard pile. The turn is now given to the model.
     */
    @IBAction func doMove(_ sender: UIButton) {
        //TODO figure out how to find a selected card
//        print("Please insert Suit:")
//        let inputSuitString = readLine()!
//        let inputSuit = suitStringToSuit(suitString: inputSuitString)
//        print("Please insert Rank:")
//        let inputRankString = readLine()!
//        let inputRank = rankStringToRank(suitString: inputRankString)
//        let card = Card(suit: inputSuit, rank: inputRank)
        let card = Card(suit: Suit.Hearts, rank: Rank.II)
        //TODO if a new suit is chosen (in case its a 7 for example), pass that value when playing the card
        if game.playCard(card: card, player: game.getCurrentPlayer(), newSuit: nil) {
            // Pass turn to the model
            game.passTurn()
        } else {
            print("Invalid move, error!")
        }
        
        // Check if player has emptied his hand, if so he won.
        if game.isDone() {
            if game.playerWon(){
                // Display a "You won the game!" message
            } else if game.modelWon() {
                // Display a "You lost the game!" message
            }
        } else {
            // If game hasn't ended, we give the turn to the model.
            game.modelTurn()
        }
    }
    
    func suitStringToSuit(suitString: String) -> Suit {
        switch suitString {
        case "hearts":
            return Suit.Hearts
        case "acorn":
            return Suit.Acorn
        case "leaves":
            return Suit.Leaves
        case "pumpkin":
            return Suit.Pumpkin
        default:
            print("Error, used default suit: Hearts")
            return Suit.Hearts
        }
    }
    
    func rankStringToRank(suitString: String) -> Rank {
        switch suitString {
        case "II":
            return Rank.II
        case "VII":
            return Rank.VII
        case "VIII":
            return Rank.VIII
        case "IX":
            return Rank.IX
        case "X":
            return Rank.X
        case "Ace":
            return Rank.Ace
        case "Unter":
            return Rank.Unter
        case "King":
            return Rank.King
        default:
            print("Error, used default rank: II")
            return Rank.II
        }
    }
    
//    /**
//     Just a test function
//     */
//    @IBAction func topDiscardCard(_ sender: UIButton) {
//        print("topcard: \(game.getTopDiscardCard())")
//    }
//
    
    
//    @IBAction func PlayFirstCard(_ sender: UIButton) {
//        game.deck.playFirstCard(player: game.currentPlayer)
//        print("A card has been added to the discard pile")
//        print("Playerhand: \n \(game.deck.playerHand))")
//        print("Modelhand: \n \(game.deck.modelHand))")
//        print("Discardpile: \n \(game.deck.discard)")
//    }
}
