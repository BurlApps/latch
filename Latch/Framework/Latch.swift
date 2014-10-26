//
//  Latch.swift
//  Latch
//
//  Created by Brian Vallelunga on 10/25/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

import Foundation
import UIKit

protocol LatchDelegate {
    func latchGranted()
    func latchSet()
    func latchDenied(reason: LatchError)
}

enum LatchError {
    case TouchIDAuthFailed, TouchIDSystemCancel, TouchIDPasscodeNotSet,
    TouchIDNotAvailable, TouchIDNotEnrolled, NoAuthMethodsAvailable,
    TouchIDNotAvailablePasscodeDisabled, TouchIDCancelledPasscodeDisabled,
    PasscodeNotSet
}

class Latch: LTTouchIDDelegate, LTPasscodeDelegate {
    
    // MARK: Instance Variables
    var delegate: LatchDelegate!
    var parentController: UIViewController!
    var touchReason: String = "We need to make sure it's you!"
    var passcodeInstruction: String = "Enter Passcode"
    var enableTouch: Bool = true
    var enablePasscode: Bool = true
    var passcodeTheme: LTPasscodeTheme = LTPasscodeTheme()
    
    // MARK: Private Instance Variables
    private var touchID: LTTouchID!
    private var passcode: LTPasscode!
    private var storage: LTStorage! = LTStorage()
    
    // MARK: Initializer
    init() {
        
        // Initialize TouchID Module
        self.touchID = LTTouchID(reason: self.touchReason)
        self.touchID.delegate = self
        
        // Initialize Passcode Module
        self.passcode = LTPasscode(instructions: self.passcodeInstruction)
        self.passcode.delegate = self
        self.passcode.theme = self.passcodeTheme
    }
    
    // MARK: Instance Methods
    func authorize() {
        if self.enableTouch == false && self.enablePasscode == false {
            self.delegate!.latchDenied(LatchError.NoAuthMethodsAvailable)
            return
        }
        
        if self.enableTouch {
            self.touchID.authorize()
        }
        
        if self.enablePasscode {
            self.passcode.parentController = self.parentController
            self.passcode.theme = self.passcodeTheme
            self.passcode.updateStyle()
            self.passcode.authorize()
        }
    }
    
    func updatePasscode() {
        self.passcode.parentController = self.parentController
        self.passcode.theme = self.passcodeTheme
        self.passcode.updateStyle()
        self.passcode.setPasscode()
    }
    
    func removePasscode() {
        self.storage.removePasscode()
    }
    
    // MARK: LTPasscode Delegate Methods
    func passcodeGranted() {
        self.delegate!.latchGranted()
    }
    
    func passcodeFailed(reason: LatchError) {
        self.delegate!.latchDenied(reason)
    }
    
    func passcodeSet() {
        self.delegate.latchSet()
    }
    
    // MARK: LTTouchID Delegate Methods
    func touchIDGranted() {
        self.delegate!.latchGranted()
        self.passcode.dismiss()
    }
    
    func touchIDDenied(reason: LatchError) {
        self.delegate!.latchDenied(reason)
    }
    
    func touchIDCancelled() {
        if self.enablePasscode == false {
            self.delegate!.latchDenied(LatchError.TouchIDCancelledPasscodeDisabled)
        }
    }
    
    func touchIDNotAvailable(reason: LatchError) {
        if self.enablePasscode == false {
            self.delegate!.latchDenied(LatchError.TouchIDNotAvailablePasscodeDisabled)
        }
    }
}