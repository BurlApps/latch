//
//  LTPassCode.swift
//  Latch
//
//  Created by Brian Vallelunga on 10/25/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

import Foundation
import UIKit

enum LTPasscodeStatusBar {
    case Dark, Light
}

struct LTPasscodeTheme {
    var logo: UIImage = UIImage(named: "Latch")!
    var logoTint: UIColor! = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1)
    var instructions = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1)
    var background: UIColor = UIColor.whiteColor()
    var statusBar: LTPasscodeStatusBar = .Light
    
    var keyPadBackground: UIColor = UIColor.whiteColor()
    var keyPadBorder: UIColor = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1)
    
    var keyPadTouchBackground: UIColor = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1)
    var keyPadTouchBorder: UIColor = UIColor.whiteColor()
    
    var bubbleBackground: UIColor = UIColor.whiteColor()
    var bubbleColor: UIColor = UIColor.lightGrayColor()
    
    var bubbleActiveBackground: UIColor = UIColor.whiteColor()
    var bubbleActiveColor: UIColor = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1)
    
    var bubbleErrorBackground: UIColor = UIColor.whiteColor()
    var bubbleErrorColor: UIColor = UIColor.redColor()
}

protocol LTPasscodeDelegate {
    func passcodeGranted()
    func passcodeDenied(reason: LatchError)
}

class LTPasscode: UIViewController, LTPasscodeKeyDelegate {
    
    // MARK: Instance Variables
    var delegate: LTPasscodeDelegate!
    var parentController: UIViewController!
    var theme: LTPasscodeTheme!
    
    // MARK: Private Instance Variables
    private var instructions: String!
    private var keys: [LTPasscodeKey] = [
        LTPasscodeKey(number: 1, row: 0, column: 0),
        LTPasscodeKey(number: 2, row: 0, column: 1),
        LTPasscodeKey(number: 3, row: 0, column: 2),
        LTPasscodeKey(number: 4, row: 1, column: 0),
        LTPasscodeKey(number: 5, row: 1, column: 1),
        LTPasscodeKey(number: 6, row: 1, column: 2),
        LTPasscodeKey(number: 7, row: 2, column: 0),
        LTPasscodeKey(number: 8, row: 2, column: 1),
        LTPasscodeKey(number: 9, row: 2, column: 2),
        LTPasscodeKey(number: 0, row: 3, column: 1)
    ]
    
    // MARK: IBOutlets
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var keysView: UIView!
    
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
        
        // Create Keys
        self.configureKeys()
    }
    
    // MARK: Instance Methods
    func authorize() {
        self.parentController!.presentViewController(self, animated: true, completion: nil)
    }
    
    func dismiss() {
        self.parentController!.dismissViewControllerAnimated(true, completion: nil)
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
    
    // MARK: LTPasscodeKey Delegate Methods
    func keyPressed(number: Int) {
        println(number)
    }
}