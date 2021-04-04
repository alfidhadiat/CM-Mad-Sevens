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
    @IBOutlet weak var playerStack: UIStackView!
    @IBOutlet weak var modelStack: UIStackView!
    
    @IBOutlet weak var ColorLabel: UILabel!
    //    @IBOutlet weak var rankField: UITextField!
//    @IBOutlet weak var suitField: UITextField!
    
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
        
        ColorLabel.isHidden = true
        if discardCard.getRank() == Rank.VII{
            ColorLabel.isHidden = false
        }
        
        
        for cardview in playerCardView {
            let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
            if game.legalMove(card: currentCard) {
                cardview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveCard(_ :))))
            }
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
        
        game.drawCard()
        
        let currentPlayer = game.getCurrentPlayer()
        if currentPlayer == Player.player{
            let newCardView = PlayingCardView()
            playerCardView.append(newCardView)
            newCardView.setSuit(newSuit: game.getPlayerHand()[game.getPlayerHand().endIndex-1].getSuit())
            newCardView.setRank(newRank: game.getPlayerHand()[game.getPlayerHand().endIndex-1].getRank())
            newCardView.widthAnchor.constraint(lessThanOrEqualToConstant: 74).isActive = true
            newCardView.backgroundColor = UIColor.clear
            let newCard = Card(suit: newCardView.suit, rank: newCardView.rank)
            if game.legalMove(card: newCard) {
                for newCardView in playerCardView {
                    newCardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveCard(_ :))))
                }
            }
            
            playerStack.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            playerStack.autoresizesSubviews = true
            playerStack.spacing = 0
            playerStack.addArrangedSubview(newCardView)
            //deck.drawCard(player: Player.player)
        }
        if currentPlayer == Player.model{
            let newCardView = ModelCardView()
            newCardView.setSuit(newSuit: game.getPlayerHand()[game.getModelHand().endIndex-1].getSuit())
            newCardView.setRank(newRank: game.getPlayerHand()[game.getModelHand().endIndex-1].getRank())
            newCardView.backgroundColor = UIColor.clear
            modelStack.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            modelStack.autoresizesSubviews = true
            modelStack.spacing = 0
            modelStack.addArrangedSubview(newCardView)
            //deck.drawCard(player: Player.model)
        }
        
        if self.game.getPlayerHand().count > 3 {
            self.playerStack.distribution = UIStackView.Distribution.fillEqually
        } else {
            self.playerStack.distribution = UIStackView.Distribution.equalSpacing

        }
        
//        if self.game.getPlayerHand().count > 2 {
//            self.playerStack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
//        } else if game.getPlayerHand().count == 2 {
//            self.playerStack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 250).isActive = true
//        }
        
        game.printGame()
        game.passTurn()
        game.modelTurn()
        DeckView[0].state = game.getDeckState()
    }
    
    
    @objc func moveCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView
            {
                let chosenCard = Card(suit: chosenCardView.suit, rank: chosenCardView.rank)
                print("Playing this card: \(chosenCard)")
                UIView.transition(from: chosenCardView,
                                  to: discardCardView,
                                  duration: 0,
                                  options: .showHideTransitionViews,
                                  completion: { finished in
                                    //let discardCard = self.game.getTopDiscardCard()
                                    UIView.transition(with: self.discardCardView,
                                                      duration: 0.9,
                                                      options: .transitionCurlDown,
                                                      animations:{
                                                        self.discardCardView.rank = chosenCardView.rank
                                                        self.discardCardView.suit = chosenCardView.suit
                                                        
                                                        if self.game.getPlayerHand().count < 3 {
                                                            self.playerStack.distribution = UIStackView.Distribution.equalSpacing
                                                        }
                                            
//                                                        if self.game.getPlayerHand().count > 3 {
//                                                            self.playerStack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
//                                                            self.playerStack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 250).isActive = false
//                                                        } else {
//                                                            self.playerStack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = false
//                                                            self.playerStack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 250).isActive = true
//                                                        }
                                                        
                                                        if self.discardCardView.rank == Rank.VII{
                                                            self.ColorLabel.isHidden = false
                                                        }
                                                        
                                                        if self.discardCardView.rank != Rank.VII{
                                                            self.ColorLabel.isHidden = true
                                                        }
                                  
                                                        for cardview in self.playerCardView {
                                                            let currentCard = Card(suit: cardview.suit, rank: cardview.rank)
                                                            if self.game.legalMove(card: currentCard) {
                                                                cardview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.moveCard(_ :))))
                                                            }
                                                            if !self.game.legalMove(card: currentCard){
                                                                for recognizer in cardview.gestureRecognizers ?? [] {
                                                                    cardview.removeGestureRecognizer(recognizer)
                                                                }
                                                            }
                                                        }
                                                      })
                                  })
                if !game.playCard(card: chosenCard, newSuit: nil) {
                    print("Invalid move, a card is drawn for you!")
                }
                game.passTurn()
                checkpoint()
                game.modelTurn()
                checkpoint()
            }
        default:
            break
        }
    }

    /**
     The selected card (TODO: multiple cards yet to be implemented) will be taken from the player's hand and added to the
     discard pile. The turn is now given to the model.
     */
//    @IBAction func doMove(_ sender: UIButton) {
//        //TODO figure out how to find a selected card
//
//        // do the move
//        let inputRank = rankField!
//        let inputSuit = suitField!
//        print("inputRank: \(inputRank.text!), inputSuit: \(inputSuit.text!)")
//        let card = Card(suit: suitStringToSuit(suitString: inputSuit.text!), rank: rankStringToRank(rankString: inputRank.text!))
//        print("Playing this card: \(card)")
////        TODO if a new suit is chosen (in case its a 7 for example), pass that value when playing the card
//        if !game.playCard(card: card, newSuit: nil) {
//            print("Invalid move, a card is drawn for you!")
//    }
//        game.passTurn()
//        checkpoint()
//        game.modelTurn()
//        checkpoint()
//    }
//
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
