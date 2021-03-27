//
//  PlayingCardView.swift
//  MADSevens
//
//  Created by D.L. Kovacs on 3/11/21.
//

import UIKit

class PlayingCardView: UIView {

    var rank = Rank.Ace {didSet {setNeedsDisplay(); setNeedsLayout() } }
    var suit = Suit.Acorn {didSet {setNeedsDisplay(); setNeedsLayout() } }
    var isFaceUp: Bool = true {didSet {setNeedsDisplay(); setNeedsLayout() } }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()

        if isFaceUp {
//            print("Raw value: \(suit.rawValue)")
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
        self.rank = newRank
    }
    
    func setSuit(newSuit: Suit) {
        self.suit = newSuit
    }

    
}

// Extension with simple but useful utilities
extension PlayingCardView {
    
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


// Extension with simple but useful utilities
extension CGPoint {
    /// Get a new point with the given offset
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

// Extension with simple but useful utilities
extension CGRect {
    
    /// Zoom rect by given factor
    func zoom(by zoomFactor: CGFloat) -> CGRect {
        let zoomedWidth = size.width * zoomFactor
        let zoomedHeight = size.height * zoomFactor
        let originX = origin.x + (size.width - zoomedWidth) / 2
        let originY = origin.y + (size.height - zoomedHeight) / 2
        return CGRect(origin: CGPoint(x: originX,y: originY) , size: CGSize(width: zoomedWidth, height: zoomedHeight))
    }
    
    /// Get the left half of the rect
    var leftHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: origin, size: CGSize(width: width, height: size.height))
    }
    
    /// Get the right half of the rect
    var rightHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: CGPoint(x: origin.x + width, y: origin.y), size: CGSize(width: width, height: size.height))
    }
}

