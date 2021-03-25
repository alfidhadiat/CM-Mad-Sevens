//
//  ViewController.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import UIKit

class MADSevensViewController: UIViewController {
    
    public var game = MADSevens()
        
    @IBOutlet private var playerCardView: [PlayingCardView]!
    @IBOutlet private var modelCardView: [ModelCardView]!
    @IBOutlet private var discardCardView: CardInPlayView!
    @IBOutlet private var DeckView: [DeckView]!
    @IBOutlet weak var rankField: UITextField!
    @IBOutlet weak var suitField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let playerCards = game.getPlayerHand()
        let modelCards = game.getModelHand()
        let discardCard = game.getTopDiscardCard()
        //let deckCard = deck.updateDeck()
        
        for i in 0 ..< playerCards.count {
            playerCardView[i].isFaceUp = true
            playerCardView[i].setRank(newRank: playerCards[i].getRank())
            playerCardView[i].setSuit(newSuit: playerCards[i].getSuit())
        }
        for i in 0 ..< modelCards.count {
            modelCardView[i].isFaceUp = false
            modelCardView[i].setRank(newRank: modelCards[i].getRank())
            modelCardView[i].setSuit(newSuit: modelCards[i].getSuit())
        }
        discardCardView = CardInPlayView()
        discardCardView.setRank(newRank: discardCard.getRank())
        discardCardView.setSuit(newSuit: discardCard.getSuit())
    }

    
    /**
    Draws a card for the current player, gives the turn to its opponent.
     TODO: Do we want to enable/disable this button whenever its the models turn?
     */
    @IBAction func drawCard(_ sender: UIButton) {
        // draw card, add it to hand
        // give turn to next player
        //TODO: since button is pressed, it's always the player calling this function
        print("Current player: \(game.getCurrentPlayer()), drawing a card right now!")
        game.drawCard()
        game.printGame()
        game.passTurn()
        game.modelTurn()
//        let state = updateDeck()
    }
        
    /**
     The selected card (TODO: multiple cards yet to be implemented) will be taken from the player's hand and added to the
     discard pile. The turn is now given to the model.
     */
    @IBAction func doMove(_ sender: UIButton) {
        //TODO figure out how to find a selected card
        
        // do the move
        let inputRank = rankField!
        let inputSuit = suitField!
        print("inputRank: \(inputRank.text!), inputSuit: \(inputSuit.text!)")
        let card = Card(suit: suitStringToSuit(suitString: inputSuit.text!), rank: rankStringToRank(rankString: inputRank.text!))
        print("Playing this card: \(card)")
        //TODO if a new suit is chosen (in case its a 7 for example), pass that value when playing the card
        if !game.playCard(card: card, newSuit: nil) {
            print("Invalid move, a card is drawn for you!")
        }
        game.passTurn()
        checkpoint()
        game.modelTurn()
        checkpoint()
    }
    
    func checkpoint() {
        //TODO: Convert print statements to popups
        let checkpoint = game.checkpoint()
        switch checkpoint {
        case "Player":
            print("Player won the game!")
            game.newGame()
        case "Model":
            print("Model won the game!")
            game.newGame()
        default:
            break
        }
    }
    
//    /**
//     Just a test function
//     */
//    @IBAction func topDiscardCard(_ sender: UIButton) {
//        print("topcard: \(game.getTopDiscardCard())")
//    }
//
    
    
    //    func getHand(player: Player) -> [Card] {
    //        if player == Player.model {
    //            return game.getModelHand()
    //        } else {
    //            return game.getPlayerHand()
    //        }
    //    }
    
    
//    @IBAction func PlayFirstCard(_ sender: UIButton) {
//        game.deck.playFirstCard(player: game.currentPlayer)
//        print("A card has been added to the discard pile")
//        print("Playerhand: \n \(game.deck.playerHand))")
//        print("Modelhand: \n \(game.deck.modelHand))")
//        print("Discardpile: \n \(game.deck.discard)")
//    }
}
