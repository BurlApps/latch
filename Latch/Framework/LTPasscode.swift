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
    var logo: UIImage = UIImage()
    var title = UIColor(red:0.1, green:0.51, blue:0.98, alpha:1)
    var background: UIColor = UIColor.whiteColor()
    var statusBar: LTPasscodeStatusBar = .Light
    
    var keyPadBackground: UIColor = UIColor.whiteColor()
    var keyPadBorder: UIColor = UIColor(red:0.1, green:0.51, blue:0.98, alpha:1)
    
    var keyPadTouchBackground: UIColor = UIColor.whiteColor()
    var keyPadTouchBorder: UIColor = UIColor(red:0.1, green:0.51, blue:0.98, alpha:1)
    
    var bubbleBackground: UIColor = UIColor.whiteColor()
    var bubbleBorder: UIColor = UIColor.lightGrayColor()
    
    var bubbleActiveBackground: UIColor = UIColor.whiteColor()
    var bubbleActiveBorder: UIColor = UIColor(red:0.1, green:0.51, blue:0.98, alpha:1)
    
    var bubbleErrorBackground: UIColor = UIColor.whiteColor()
    var bubbleErrorBorder: UIColor = UIColor.redColor()
}


protocol LTPasscodeDelegate {
    func passcodeGranted()
    func passcodeDenied(reason: LatchError)
}

class LTPasscode: UIViewController {
    
    // MARK: Instance Variables
    var delegate: LTPasscodeDelegate!
    var rootController: UIViewController!
    var theme: LTPasscodeTheme!
    
    // MARK: Private Instance Variables
    private var instructions: String!
    
    // MARK: Initializer
    convenience init(instructions: String) {
        self.init()
        
        self.instructions = instructions
    }
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.updateStyle()
    }
    
    // MARK: Instance Methods
    func updateStyle() {
        if self.theme == nil {
            self.theme = LTPasscodeTheme()
        }
        
        self.view.backgroundColor = self.theme.background
    }
    
    // MARK: Instance Methods
    func authorize() {
        self.rootController!.presentViewController(self, animated: true, completion: nil)
    }
    
    func dismiss() {
        self.rootController!.dismissViewControllerAnimated(true, completion: nil)
    }

}