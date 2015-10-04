//
//  LTPasscodeBubble.swift
//  Latch
//
//  Created by Brian Vallelunga on 10/25/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

import UIKit

class LTPasscodeBubble: UIView {
    
    // MARK: Instance Variables
    enum State {
        case Normal, Active, Error
    }
    var state: State = .Normal
    var background: UIColor!
    var border: UIColor!
    var backgroundActive: UIColor!
    var borderActive: UIColor!
    var backgroundError: UIColor!
    var borderError: UIColor!
    var parentView: UIView!
    
    // MARK: Private Instance Variables
    var number: CGFloat!
    
    convenience init(number: CGFloat) {
        self.init()
        
        self.number = number
    }
    
    // MARK: Instance Methods
    func configureBubble() {
        // Create Frame
        let bubbleWidth: CGFloat = 12
        let bubbleHeight: CGFloat = 12
        let bubblePadding: CGFloat = 8
        
        let bubbleCenterX = self.parentView.frame.width/2 + bubblePadding/2
        let bubbleX = bubbleCenterX + ((bubbleWidth + bubblePadding) * (self.number - 2))
        
        self.frame = CGRectMake(bubbleX, 0, bubbleWidth, bubbleHeight)
        
        self.layer.borderWidth = 1
        self.layer.cornerRadius = bubbleWidth/2
        self.layer.masksToBounds = true
        
        // Update Styling
        self.updateStyle()
    }
    
    func updateStyle() {
        var newBorder: UIColor!
        var newBackground: UIColor!
        
        switch(self.state) {
        case .Normal:
            newBorder = self.border
            newBackground = self.background
            
        case .Active:
            newBorder = self.borderActive
            newBackground = self.backgroundActive
        
        case .Error:
            newBorder = self.borderError
            newBackground = self.backgroundError
        }
        
        self.backgroundColor = newBackground
        self.layer.borderColor = newBorder.CGColor
        self.layer.borderWidth = 1
    }
}
