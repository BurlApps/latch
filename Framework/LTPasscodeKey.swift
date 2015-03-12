//
//  LTPasscodeKey.swift
//  Latch
//
//  Created by Brian Vallelunga on 10/25/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

import UIKit

protocol LTPasscodeKeyDelegate {
    func keyPressed(number: Int)
}

class LTPasscodeKey: UIButton {

    // MARK: Instance Variable
    var delegate: LTPasscodeKeyDelegate!
    var parentView: UIView!
    var background: UIColor!
    var border: UIColor!
    var backgroundTouch: UIColor!
    var borderTouch: UIColor!
    var numberLabel: UILabel!
    
    // MARK: Private Instance Variable
    var number: Int!
    private var row: CGFloat!
    private var column: CGFloat!
    
    // MARK: Instance Method
    convenience init(number: Int, alpha: String!, row: CGFloat, column: CGFloat) {
        self.init()
        
        // Assign Instance Variables
        self.row = row
        self.column = column
        self.number = number
        
        // Create Number Label
        self.numberLabel = UILabel()
        self.numberLabel.textAlignment = NSTextAlignment.Center
        
        if number >= 0 {
            self.numberLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 28)
            self.numberLabel.numberOfLines = 2
            
            if alpha != nil {
                var attributedText = NSMutableAttributedString(string: "\(number)")
                var alphaText = NSMutableAttributedString(string: "\n\(alpha)")
                alphaText.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 12)!, range: NSMakeRange(0, alphaText.length))
                attributedText.appendAttributedString(alphaText)
                
                self.numberLabel.attributedText = attributedText
            } else {
                self.numberLabel.text = "\(number)"
            }
        } else {
            self.numberLabel.text = "Delete"
            self.numberLabel.font = UIFont(name: "HelveticaNeue", size: 18)
        }
        
        self.addSubview(self.numberLabel)
        
        // Attach Event Listner
        self.addTarget(self, action: Selector("holdHandle"), forControlEvents: UIControlEvents.TouchDown)
        self.addTarget(self, action: Selector("tapHandle"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // MARK: Gesture Handler
    func holdHandle() {
        if self.number >= 0 {
            self.backgroundColor = self.backgroundTouch
            self.layer.borderColor = self.borderTouch.CGColor
            self.numberLabel.textColor = self.borderTouch
        } else {
            self.numberLabel.alpha = 0.4
        }
    }
    
    func tapHandle() {
        self.delegate!.keyPressed(self.number)
        
        UIView.animateWithDuration(0.4, delay: 0.05, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            if self.number >= 0 {
                self.backgroundColor = self.background
                self.layer.borderColor = self.border.CGColor
                self.numberLabel.textColor = self.border
            } else {
                self.numberLabel.alpha = 1
            }
        }, completion: nil)
    }
    
    // MARK: Instance Methods
    func configureKey() {
        // Create Frame
        var keyWidth: CGFloat = 65
        var keyHeight: CGFloat = 65
        var keyPadding: CGFloat = 18
        
        var keyCenterX = self.parentView.frame.width/2 - (keyWidth/2)
        var keyX = keyCenterX + ((keyWidth + keyPadding) * (self.column - 1))
        var keyY = (keyHeight + keyPadding) * self.row

        self.frame = CGRectMake(keyX, keyY, keyWidth, keyHeight)
        
        // Update View Styling
        if self.number >= 0 {
            self.backgroundColor = self.background
            self.layer.borderColor = self.border.CGColor
            self.layer.borderWidth = 1
            self.layer.cornerRadius = keyWidth/2
            self.layer.masksToBounds = true
        }
        
        // Update Label Styling
        self.numberLabel.frame = CGRectMake(0, 0, keyWidth, keyHeight)
        self.numberLabel.textColor = self.border
    }
}
