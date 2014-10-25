//
//  LTPassCode.swift
//  Latch
//
//  Created by Brian Vallelunga on 10/25/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

import Foundation
import UIKit

protocol LTPasscodeDelegate {
    func passcodeGranted()
    func passcodeDenied(reason: String)
}

class LTPasscode {
    
    // MARK: Instance Variables
    var delegate: LTPasscodeDelegate!
    var rootController: UIViewController!
    
    // MARK: Private Instance Variables
    private var viewController: LTPasscodeViewController!
    private var instructions: String!
    
    // MARK: Initializer
    init(instructions: String) {
        self.instructions = instructions
        self.viewController = LTPasscodeViewController()
    }
    
    // MARK: Instance Methods
    func authorize() {
        self.rootController!.presentViewController(self.viewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        self.rootController!.dismissViewControllerAnimated(true, completion: nil)
    }

}