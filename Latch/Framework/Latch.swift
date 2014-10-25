//
//  Latch.swift
//  Latch
//
//  Created by Brian Vallelunga on 10/25/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

import Foundation
import UIKit

@objc protocol LatchDelegate {
    optional func latchGranted()
    optional func latchDenied(reason: String)
}

class Latch: LTTouchIDDelegate, LTPasscodeDelegate {
    
    // MARK: Instance Variables
    var delegate: LatchDelegate!
    var rootController: UIViewController!
    var touchReason: String = "We need to make sure it's you!"
    var passcodeInstruction: String = "Enter Passcode"
    var enableTouch: Bool = true
    var enablePasscode: Bool = true
    var passcodeTheme: LTPasscodeTheme = LTPasscodeTheme()
    
    // MARK: Private Instance Variables
    private var touchID: LTTouchID!
    private var passcode: LTPasscode!
    
    // MARK: Initializer
    init() {
        
        // Initialize TouchID Module
        self.touchID = LTTouchID(reason: self.touchReason)
        self.touchID.delegate = self
        
        // Initialize Passcode Module
        self.passcode = LTPasscode(instructions: self.passcodeInstruction)
        self.passcode.delegate = self
    }
    
    // MARK: Instance Methods
    func authorize() {
        self.passcode.rootController = self.rootController
        
        if self.enableTouch == false && self.enablePasscode == false {
            self.delegate!.latchDenied!("Both Passcode and Touch ID are disabled")
            return
        }
        
        if self.enableTouch {
            self.touchID.authorize()
        }
        
        if self.enablePasscode {
            self.passcode.authorize()
        }
    }
    
    // MARK: LTPasscode Delegate Methods
    func passcodeGranted() {
        self.delegate!.latchGranted!()
    }
    
    func passcodeDenied(reason: String) {
        self.delegate!.latchDenied!(reason)
    }
    
    // MARK: LTTouchID Delegate Methods
    func touchIDGranted() {
        self.delegate!.latchGranted!()
        self.passcode.dismiss()
    }
    
    func touchIDDenied(reason: String) {
        self.delegate!.latchDenied!(reason)
    }
    
    func touchIDCancelled() {
        if self.enablePasscode == false {
            self.delegate!.latchDenied!("Touch ID was cancelled and the passcode fallback is disabled")
        }
    }
    
    func touchIDNotAvailable(reason: String) {
        if self.enablePasscode == false {
            self.delegate!.latchDenied!("Touch ID is not available and the passcode fallback is disabled")
        }
    }
}