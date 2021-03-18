//
//  OpponentCardView.swift
//  MADSevens
//
//  Created by D.L. Kovacs on 18/03/2021.
//

import UIKit

class OpponentCardView: UIView {

    @IBInspectable
    var rank: String = "Ace" {didSet {setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var suit: String = "Pumpkins" {didSet {setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var isFaceUp: Bool = false {didSet {setNeedsDisplay(); setNeedsLayout() } }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()

        if isFaceUp {
            if let CardImage = UIImage(named: suit+rank) {
                CardImage.draw(in: bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundsSize))
            }
        } else {
            if let BackImage = UIImage(named: "cardback") {
                BackImage.draw(in: bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundsSize))
            }
        }
        
        
        
        
    }

    
}

// Extension with simple but useful utilities
extension OpponentCardView {
    
    /// Ratios that determine the card's size
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.95
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


