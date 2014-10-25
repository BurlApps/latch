//
//  Latch.swift
//  Latch
//
//  Created by Brian Vallelunga on 10/25/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

import Foundation

protocol LatchDelegate {
    func latchGranted()
    func latchDenied(reason: String)
}

class Latch: LTTouchIDDelegate {
    
    // MARK: Instance Variables
    var delegate: LatchDelegate!
    var touchReason: String = "We need to make sure it's you!"
    var passcodeInstruction: String = "Enter Passcode"
    
    // MARK: Private Instance Variables
    private var touchID: LTTouchID!
    
    // MARK: Initializer
    init() {
        
        // Initialize TouchID Module
        self.touchID = LTTouchID(reason: self.touchReason)
        self.touchID.delegate = self
    }
    
    // MARK: LTTouchID Delegate Methods
    func touchIDGranted() {
        self.delegate.latchGranted()
    }
    
    func touchIDenied(reason: String) {
        self.delegate.latchDenied(reason)
    }
    
    func touchIDNotAvailable(reason: String) {
        println(reason)
    }
}