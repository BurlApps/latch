//
//  ViewController.swift
//  Latch
//
//  Created by Brian Vallelunga on 10/25/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

import UIKit
import Latch

class ViewController: UIViewController, LatchDelegate {
    
    // MARK: Private Instance Variables
    var latch: Latch!
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.latch = Latch(defaultPasscode: "0000")
        self.latch.delegate = self
      self.latch.enablePasscodeChange = true
        self.latch.parentController = self
    }
    
    // MARK: IBAction
    @IBAction func authorize(sender: UIButton) {
        self.latch.enableTouch = true
        self.latch.enablePasscode = true
        self.latch.authorize()
    }
    
    @IBAction func authorizePasscode(sender: UIButton) {
        self.latch.enableTouch = false
        self.latch.enablePasscode = true
        self.latch.authorize()
    }
    
    @IBAction func authorizeTouch(sender: UIButton) {
        self.latch.enableTouch = true
        self.latch.enablePasscode = false
        self.latch.authorize()
    }
    
    @IBAction func changePasscode(sender: UIButton) {
        self.latch.updatePasscode()
    }
    
    @IBAction func removePasscode(sender: UIButton) {
        self.latch.removePasscode()
    }
    
    // MARK: LatchDelegate Methods
    func latchCanceled() {
        println("canceled")
    }
    func latchGranted() {
        println("access granged")
    }
    
    func latchSet() {
        println("passcode set")
    }
    
    func latchDenied(reason: LatchError) {
        println(reason)
    }
}

