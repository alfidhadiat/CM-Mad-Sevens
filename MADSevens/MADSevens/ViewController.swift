//
//  ViewController.swift
//  MADSevens
//
//  Created by Marieke on 27/02/2021.
//

import UIKit

class MADSevensViewController: UIViewController {
    
    public var game = MADSevens()
//    private var deck = Deck()
    
    @IBOutlet private var playerCardView: [PlayingCardView]!
    @IBOutlet private var modelCardView: [ModelCardView]!
    @IBOutlet private var discardCardView: CardInPlayView!
    @IBOutlet private var DeckView: [DeckView]!
    @IBOutlet weak var playerStack: UIStackView!
    
    @IBOutlet weak var rankField: UITextField!
    @IBOutlet weak var suitField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let playerCards = game.getPlayerHand()
        let modelCards = game.getModelHand()
        let discardCard = game.getTopDiscardCard()
        print("This is a dicard card \(discardCard)")
        
        
        
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
        
        
        discardCardView.isFaceUp = true
        discardCardView.setRank(newRank: discardCard.getRank())
        discardCardView.setSuit(newSuit: discardCard.getSuit())

        for cardview in playerCardView {
            cardview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveCard(_ :))))
            }
    }
    
    
    @objc func moveCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView
            {
                UIView.transition(from: chosenCardView,
                                  to: discardCardView,
                                  duration: 0.25,
                                  options: .showHideTransitionViews,
                                  completion: { finished in
                                    //let discardCard = self.game.getTopDiscardCard()
                                    UIView.transition(with: self.discardCardView,
                                                      duration: 0.1,
                                                      options: .transitionCurlUp,
                                                      animations:{
                                                        self.discardCardView.rank = chosenCardView.rank
                                                        self.discardCardView.suit = chosenCardView.suit
                                                      })
                                  })
            }
        default:
            break
        }
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

        game.rememberSuitRank()
//        print("Current player should be player, is now \(game.getCurrentPlayer())")
        game.drawCard()
        game.printGame()
        checkpoint()
        game.passTurn()
//        print("Current player should be model, is now \(game.getCurrentPlayer())")
        game.modelTurn()
        checkpoint()
//        print("Current player should be player, is now \(game.getCurrentPlayer())")
        //drawCard2(player: Player.player)
        let newCard = PlayingCardView()
        newCard.setSuit(newSuit: game.getNewSuit())
        newCard.setRank(newRank: game.getNewRank())
        newCard.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        newCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveCard(_:))))
        newCard.backgroundColor = UIColor.clear
        game.drawCard()
        playerStack.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        playerStack.autoresizesSubviews = true
        playerStack.addArrangedSubview(newCard)
        
        //        let state = updateDeck()
    }
    
//    marieke pls move back to deck
    func updateDeck() -> String {
        var state = "full"
        let stackCount = game.getDeckCount()
        if (stackCount <= 17) {
            state = "threeq"
        } else if (stackCount <= 13) {
            state = "half"
        } else if (stackCount <= 9){
            state = "oneq"
        } else if (stackCount <= 5) {
            state = "low"
        }
            return state
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
//        TODO if a new suit is chosen (in case its a 7 for example), pass that value when playing the card
//        print("Current player should be player, is now \(game.getCurrentPlayer())")
        game.playCard(card: card, newSuit: nil)
        game.passTurn()
//        print("Current player should be model, is now \(game.getCurrentPlayer())")
        checkpoint()
        
        game.modelTurn()
//        print("Current player should be player, is now \(game.getCurrentPlayer())")
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
