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
    
    @IBAction func start(_ sender: UIButton) {

    }

    @IBAction func NewGame(_ sender: UIButton) {
        game.newGame()
    }
    
    /**
        Draws a card for the current player, gives the turn to its opponent.
     TODO: Do we want to enable/disable this button whenever its the models turn?
     */
    @IBAction func DrawCard(_ sender: UIButton) {
        // draw card, add it to hand
        // give turn to next player
        //TODO: since button is pressed, it's always the player calling this function
        game.drawCard(player: game.currentPlayer)
        game.passTurn()
    }
        
    @IBAction func PlayCard(_ sender: UIButton) {
        // Make sure selected card is a legal move
        let card = Card(suit: Suit.Hearts, rank: Rank.Ace) //TODO figure out how to find a selected card
        let topDiscardCard = game.getTopDiscardCard()
        if card.isLegalMove(discardSuit: topDiscardCard.getSuit(), discardRank: topDiscardCard.getRank()) {
            // Move card from players hand to discard pile
            game.deck.playCard(card: card, player: game.currentPlayer)
            game.currentPlayer = CurrentPlayer.model
        }
    }
    
//    @IBAction func PlayFirstCard(_ sender: UIButton) {
//        game.deck.playFirstCard(player: game.currentPlayer)
//        print("A card has been added to the discard pile")
//        print("Playerhand: \n \(game.deck.playerHand))")
//        print("Modelhand: \n \(game.deck.modelHand))")
//        print("Discardpile: \n \(game.deck.discard)")
//    }
    
    @IBAction func TopDiscardCard(_ sender: UIButton) {
        print("topcard: \(game.getTopDiscardCard())")
    }
}
