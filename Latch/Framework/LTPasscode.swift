//
//  LTPassCode.swift
//  Latch
//
//  Created by Brian Vallelunga on 10/25/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

enum LTPasscodeStatusBar {
    case Dark, Light
}

struct LTPasscodeTheme {
    var logo: UIImage = UIImage(named: "Latch")!
    var logoTint: UIColor! = UIColor(red:0.12, green:0.67, blue:0.95, alpha:1)
    var logoErrorTint: UIColor = UIColor.redColor()
   
    var instructions: UIColor = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1)
    var instructionsError: UIColor = UIColor.redColor()
    
    var background: UIColor = UIColor.whiteColor()
    var statusBar: LTPasscodeStatusBar = .Light
    
    var keyPadBackground: UIColor = UIColor.whiteColor()
    var keyPadBorder: UIColor = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1)
    
    var keyPadTouchBackground: UIColor = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1)
    var keyPadTouchBorder: UIColor = UIColor.whiteColor()
    
    var bubbleBackground: UIColor = UIColor.whiteColor()
    var bubbleColor: UIColor = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1)
    
    var bubbleActiveBackground: UIColor = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1)
    var bubbleActiveColor: UIColor = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1)
    
    var bubbleErrorBackground: UIColor = UIColor.redColor()
    var bubbleErrorColor: UIColor = UIColor.redColor()
}

protocol LTPasscodeDelegate {
    func passcodeGranted()
    func passcodeFailed(reason: LatchError)
}

class LTPasscode: UIViewController, LTPasscodeKeyDelegate {
    
    // MARK: Instance Variables
    var delegate: LTPasscodeDelegate!
    var parentController: UIViewController!
    var theme: LTPasscodeTheme!
    
    // MARK: Private Instance Variables
    private var storage: LTStorage! = LTStorage()
    private var passcode: [String] = []
    private var instructions: String!
    private var keys: [LTPasscodeKey] = [
        LTPasscodeKey(number: 1, alpha: "", row: 0, column: 0),
        LTPasscodeKey(number: 2, alpha: "ABC", row: 0, column: 1),
        LTPasscodeKey(number: 3, alpha: "DEF", row: 0, column: 2),
        LTPasscodeKey(number: 4, alpha: "GHI", row: 1, column: 0),
        LTPasscodeKey(number: 5, alpha: "JKL", row: 1, column: 1),
        LTPasscodeKey(number: 6, alpha: "MNO", row: 1, column: 2),
        LTPasscodeKey(number: 7, alpha: "PQRS", row: 2, column: 0),
        LTPasscodeKey(number: 8, alpha: "TUV", row: 2, column: 1),
        LTPasscodeKey(number: 9, alpha: "WXYZ", row: 2, column: 2),
        LTPasscodeKey(number: 0, alpha: nil, row: 3, column: 1),
        LTPasscodeKey(number: -1, alpha: nil, row: 3, column: 2)
    ]
    private var bubbles: [LTPasscodeBubble] = [
        LTPasscodeBubble(number: 0),
        LTPasscodeBubble(number: 1),
        LTPasscodeBubble(number: 2),
        LTPasscodeBubble(number: 3)
    ]
    
    // MARK: IBOutlets
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var keysView: UIView!
    @IBOutlet weak var bubblesView: UIView!
    
    // MARK: Initializer
    convenience init(instructions: String) {
        self.init()
        
        self.instructions = instructions
        self.updateStyle()
    }
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update Instructions Label
        self.instructionsLabel.text = self.instructions
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Create Bubbles
        self.configureBubbles()
        
        // Create Keys
        self.configureKeys()
    }
    
    // MARK: Instance Methods
    func authorize() {
        if self.storage.readPasscode() != nil {
            self.parentController!.presentViewController(self, animated: true, completion: nil)
        } else {
            self.delegate.passcodeFailed(LatchError.PasscodeNotSet)
        }
    }
    
    func dismiss() {
        for bubble in self.bubbles {
            bubble.state = .Normal
            bubble.updateStyle()
        }
        
        self.parentController!.dismissViewControllerAnimated(true, completion: nil)
        self.delegate.passcodeGranted()
    }
    
    func configureBubbles() {
        for bubble in self.bubbles {
            bubble.state = .Normal
            bubble.parentView = self.bubblesView
            
            bubble.border = self.theme.bubbleColor
            bubble.background = self.theme.bubbleBackground
            
            bubble.borderActive = self.theme.bubbleActiveColor
            bubble.backgroundActive = self.theme.bubbleActiveBackground
            
            bubble.borderError = self.theme.bubbleErrorColor
            bubble.backgroundError = self.theme.bubbleErrorBackground
            
            bubble.configureBubble()
            self.bubblesView.addSubview(bubble)
        }
    }
    
    func configureKeys() {
        for key in self.keys {
            key.delegate = self
            key.parentView = self.keysView
            
            key.border = self.theme.keyPadBorder
            key.background = self.theme.keyPadBackground
            
            key.borderTouch = self.theme.keyPadTouchBorder
            key.backgroundTouch = self.theme.keyPadTouchBackground
            
            key.configureKey()
            self.keysView.addSubview(key)
        }
    }
    
    func updateStyle() {
        if self.theme == nil {
            self.theme = LTPasscodeTheme()
        }
        
        // Update Controller View
        self.view.backgroundColor = self.theme.background
        
        // Update Instructions Label
        self.instructionsLabel.textColor = self.theme.instructions
        
        // Update Logo View
        if self.theme.logoTint != nil {
            self.theme.logo = self.theme.logo.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.logoView.tintColor = self.theme.logoTint
        }
        
        self.logoView.image = self.theme.logo
    }
    
    func checkPasscode() {
        var passcodeString = ""
        
        for character in self.passcode {
            passcodeString += character
        }
        
        self.passcode.removeAll(keepCapacity: false)
        
        if passcodeString == self.storage.readPasscode() {
            NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("dismiss"), userInfo: nil, repeats: false)
        } else {
            self.logoView.tintColor = self.theme.logoErrorTint
            self.instructionsLabel.textColor = self.theme.instructionsError
            
            for bubble in self.bubbles {
                bubble.state = .Error
                bubble.updateStyle()
            }
            
            var animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.autoreverses = true
            animation.repeatCount = 2
            animation.duration = 0.07
            animation.values = [NSNumber(float: -10), NSNumber(float: 10)]
            self.bubblesView.layer.addAnimation(animation, forKey: nil)
            
            AudioServicesPlaySystemSound(1352)
            NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("updateStyle"), userInfo: nil, repeats: false)
            NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("configureBubbles"), userInfo: nil, repeats: false)
        }
    }
    
    // MARK: LTPasscodeKey Delegate Methods
    func keyPressed(number: Int) {
        if number >= 0 {
            self.passcode.append("\(number)")
        } else if self.passcode.count > 0 {
            self.passcode.removeLast()
        }
        
        for (index, bubble) in enumerate(self.bubbles) {
            if index <= self.passcode.count - 1 {
                bubble.state = .Active
            } else {
                bubble.state = .Normal
            }
            
            bubble.updateStyle()
        }
        
        if self.passcode.count == 4 {
            self.checkPasscode()
        }
    }
}