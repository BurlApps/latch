//
//  LTPasscodeViewController.swift
//  Latch
//
//  Created by Brian Vallelunga on 10/25/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

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

class LTPasscodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.orangeColor()
    }

}
