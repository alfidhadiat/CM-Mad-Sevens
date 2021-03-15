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
        game.passTurn()
    }
        
    /**
     The selected card (TODO: multiple cards yet to be implemented) will be taken from the player's hand and added to the
     discard pile. The turn is now given to the model.
     */
    @IBAction func doMove(_ sender: UIButton) {
        // Make sure selected card is a legal move, if so execute move and pass turn to model
        let card = Card(suit: Suit.Hearts, rank: Rank.Ace) //TODO figure out how to find a selected card
        let topDiscardCard = game.getTopDiscardCard()
        if card.isLegalMove(discardSuit: topDiscardCard.getSuit(), discardRank: topDiscardCard.getRank()) {
            // Move card from players hand to discard pile
            game.playCard(card: card, player: game.getCurrentPlayer())
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
    
    
    /**
     Just a test function
     */
    @IBAction func topDiscardCard(_ sender: UIButton) {
        print("topcard: \(game.getTopDiscardCard())")
    }
    
    
    
    
    
//    @IBAction func PlayFirstCard(_ sender: UIButton) {
//        game.deck.playFirstCard(player: game.currentPlayer)
//        print("A card has been added to the discard pile")
//        print("Playerhand: \n \(game.deck.playerHand))")
//        print("Modelhand: \n \(game.deck.modelHand))")
//        print("Discardpile: \n \(game.deck.discard)")
//    }
}
