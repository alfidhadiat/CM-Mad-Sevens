//
//  CardInPlayView.swift
//  MADSevens
//
//  Created by D.L. Kovacs on 18/03/2021.
//

import UIKit

class CardInPlayView: UIView {

    var rank = Rank.Ace {didSet {setNeedsDisplay(); setNeedsLayout() } }
    var suit = Suit.Acorn {didSet {setNeedsDisplay(); setNeedsLayout() } }
    var isFaceUp: Bool = true {didSet {setNeedsDisplay(); setNeedsLayout() } }
    
    

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()

        if isFaceUp {
            if let CardImage = UIImage(named: suit.rawValue+rank.rawValue) {
                CardImage.draw(in: bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundsSize))
            }
        } else {
            if let BackImage = UIImage(named: "cardback") {
                BackImage.draw(in: bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundsSize))
            }
        }
        
    }
    
    func setRank(newRank: Rank) {
//        print("Setting the value of new cards")
//        print("Current values: \(self.rank), \(self.suit)")
        self.rank = newRank
//        print("New values: \(self.rank), \(self.suit)")

    }
    
    func setSuit(newSuit: Suit) {
        self.suit = newSuit
    }
}

// Extension with simple but useful utilities
extension CardInPlayView {
    
    /// Ratios that determine the card's size
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.97
    }
    
    /// Corner radius
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    /// Corner offset
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    /// The font size for the corner text
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
 
}

