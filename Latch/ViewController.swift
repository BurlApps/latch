//
//  ViewController.swift
//  Latch
//
//  Created by Brian Vallelunga on 10/25/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LatchDelegate {
    
    // MARK: Private Instance Variables
    var latch: Latch!
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.latch = Latch()
        self.latch.delegate = self
        self.latch.rootController = self
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
    
    // MARK: LatchDelegate Methods
    func latchGranted() {
        println("access granged")
    }
    
    func latchDenied(reason: String) {
        println(reason)
    }
}

