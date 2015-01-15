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

enum LatchError: Printable {
    case TouchIDAuthFailed, TouchIDSystemCancel, TouchIDPasscodeNotSet,
    TouchIDNotAvailable, TouchIDNotEnrolled, NoAuthMethodsAvailable,
    TouchIDNotAvailablePasscodeDisabled, TouchIDCancelledPasscodeDisabled,
    PasscodeNotSet
  
    var description: String {
      switch self {
      case .TouchIDAuthFailed:
        return "Touch ID authorization failed."
      case .TouchIDSystemCancel:
        return "Touch ID system canceled."
      case .TouchIDPasscodeNotSet:
        return "Touch ID passcode not set."
      case .TouchIDNotAvailable:
        return "Touch ID not available."
      case .TouchIDNotEnrolled:
        return "Touch ID not enrolled."
      case .NoAuthMethodsAvailable:
        return "No authorization methods available."
      case .TouchIDNotAvailablePasscodeDisabled:
        return "Touch ID not available and passcode disabled."
      case .TouchIDCancelledPasscodeDisabled:
        return "Touch ID cancelled and passcode disabled."
      case .PasscodeNotSet:
        return "Passcode not set."
      }
    }
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
    internal func passcodeGranted() {
        self.delegate!.latchGranted()
    }
    
    internal func passcodeFailed(reason: LatchError) {
        self.delegate!.latchDenied(reason)
    }
    
    internal func passcodeSet() {
        self.delegate.latchSet()
    }
    
    // MARK: LTTouchID Delegate Methods
    internal func touchIDGranted() {
        self.delegate!.latchGranted()
        self.passcode.dismiss()
    }
    
    internal func touchIDDenied(reason: LatchError) {
        self.delegate!.latchDenied(reason)
    }
    
    internal func touchIDCancelled() {
        if self.enablePasscode == false {
            self.delegate!.latchDenied(LatchError.TouchIDCancelledPasscodeDisabled)
        }
    }
    
    internal func touchIDNotAvailable(reason: LatchError) {
        if self.enablePasscode == false {
            self.delegate!.latchDenied(LatchError.TouchIDNotAvailablePasscodeDisabled)
        }
    }
}