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
    func touchIDenied(reason: String)
    func touchIDNotAvailable(reason: String)
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
    func authorizeUser() {
        var context = LAContext()
        var error : NSError?
        
        // Test if TouchID fingerprint authentication is available on the device and a fingerprint has been enrolled.
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: self.reason, reply: {
                (success: Bool, authenticationError: NSError?) -> Void in
                
                // check whether evaluation of fingerprint was successful
                if (success || error!.code == LAError.UserFallback.rawValue) && authenticationError == nil {
                    self.delegate!.touchIDGranted()
                } else {
                    var failureReason = "Unable to authenticate user"
                    
                    switch error!.code {
                    case LAError.AuthenticationFailed.rawValue:
                        failureReason = "Authentication failed"
                    case LAError.UserCancel.rawValue:
                        failureReason = "User canceled authentication"
                    case LAError.SystemCancel.rawValue:
                        failureReason = "System canceled authentication"
                    case LAError.PasscodeNotSet.rawValue:
                        failureReason = "Passcode not set"
                    default:
                        failureReason = "Unable to authenticate user"
                    }
                    
                    self.delegate!.touchIDenied(failureReason)
                }
            })
        } else {
            var failureReason = "Local Authentication not available"
            
            switch error!.code {
            case LAError.TouchIDNotAvailable.rawValue:
                failureReason = "Touch ID not available on device"
            case LAError.TouchIDNotEnrolled.rawValue:
                failureReason = "Touch ID is not enrolled yet"
            case LAError.PasscodeNotSet.rawValue:
                failureReason = "Passcode not set"
            default: failureReason = "Authentication not available"
            }
            
            self.delegate!.touchIDNotAvailable(failureReason)
        }
    }
}
