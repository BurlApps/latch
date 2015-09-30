//
//  TouchID.swift
//  Latch
//
//  Created by Brian Vallelunga on 10/25/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

import LocalAuthentication

protocol LTTouchIDDelegate {
    func touchIDGranted()
    func touchIDDenied(reason: LatchError)
    func touchIDNotAvailable(reason: LatchError)
    func touchIDCancelled()
}

class LTTouchID {
    
    // MARK: Instance Variables
    var delegate: LTTouchIDDelegate!
    
    // MARK: Private Instance Variables
    private var reason: String!
    
    // MARK: Initializer
    init(reason: String) {
        self.reason = reason
    }
    
    // MARK: Instance Methods
    func authorize() {
        let context = LAContext()
        var error : NSError?
        
        // Test if TouchID fingerprint authentication is available on the device and a fingerprint has been enrolled.
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: self.reason, reply: {
                (success: Bool, authenticationError: NSError?) -> Void in
                
                // check whether evaluation of fingerprint was successful
                if success && error == nil && authenticationError == nil {
                    self.delegate!.touchIDGranted()
                } else if authenticationError!.code == LAError.UserCancel.rawValue {
                    self.delegate!.touchIDCancelled()
                } else if authenticationError!.code == LAError.UserFallback.rawValue {
                    self.delegate!.touchIDCancelled()
                } else {
                    var failureReason: LatchError!
                    var newError: NSError!
                    
                    if error != nil {
                        newError = error
                    } else {
                        newError = authenticationError
                    }
                    
                    switch newError!.code {
                    case LAError.SystemCancel.rawValue:
                        failureReason = .TouchIDSystemCancel
                    case LAError.PasscodeNotSet.rawValue:
                        failureReason = .TouchIDPasscodeNotSet
                    default:
                        failureReason = .TouchIDAuthFailed
                    }
                    
                    self.delegate!.touchIDDenied(failureReason)
                }
            })
        } else {
            var failureReason: LatchError!
            
            switch error!.code {
            case LAError.TouchIDNotAvailable.rawValue:
                failureReason = .TouchIDNotAvailable
            case LAError.TouchIDNotEnrolled.rawValue:
                failureReason = .TouchIDNotEnrolled
            case LAError.PasscodeNotSet.rawValue:
                failureReason = .TouchIDPasscodeNotSet
            default: failureReason = .TouchIDAuthFailed
            }
            
            self.delegate!.touchIDNotAvailable(failureReason)
        }
    }
}
