//
//  ViewController.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = MADSevens()
    
    private var deck = Deck()
    

    @IBOutlet private var cardViews: [PlayingCardView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func start(_ sender: UIButton) {
        print("Started the game")
        print("Playerhand: \n \(game.deck.playerHand))")
        print("Modelhand: \n \(game.deck.modelHand))")
    }

    @IBAction func NewGame(_ sender: UIButton) {
        game.newGame()

    }
    
    @IBAction func DrawCard(_ sender: UIButton) {
        game.deck.drawcard(player: game.currentPlayer)
        print("A new card has been drawn.")
        print("Playerhand: \n \(game.deck.playerHand))")
        print("Modelhand: \n \(game.deck.modelHand))")
    }
}


