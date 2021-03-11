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
//        let newcard = Card(suit: Suit.Hearts, rank: Rank.VIII)
//        let randomcard = Card(suit: Suit.Acorn, rank: Rank.King)
//        print("newcard is legal move? \(newcard.isLegalMove(discardSuit:  randomcard.suit, discardRank: randomcard.rank))")
//        print("Started the game")
//        print("Playerhand: \n \(game.deck.playerHand))")
//        print("Modelhand: \n \(game.deck.modelHand))")
    }

    @IBAction func NewGame(_ sender: UIButton) {
        game.newGame()
    }
    
    @IBAction func DrawCard(_ sender: UIButton) {
        // draw card, add it to hand
        // give turn to next player
        game.drawCard(player: game.currentPlayer)
        if (game.currentPlayer == CurrentPlayer.model) {
            game.currentPlayer
        }
        
        
//        print("A new card has been drawn.")
//        print("Stack: \(game.deck.stack)")
//        print("Discard: \(game.deck.discard)")
//        print("Playerhand: \n \(game.deck.playerHand))")
//        print("Modelhand: \n \(game.deck.modelHand))")
    }
    
    @IBAction func TopDiscardCard(_ sender: UIButton) {
        print("topcard: \(game.getTopDiscardCard())")
    }
}


