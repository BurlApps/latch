//
//  LTPassCode.swift
//  Latch
//
//  Created by Brian Vallelunga on 10/25/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

public enum LTPasscodeStatusBar {
    case Dark, Light
}

public struct LTPasscodeTheme {
    var logo: UIImage = UIImage(contentsOfFile: LTBundle.pathForResource("Latch", ofType: "png")!)!
    var logoTint: UIColor! = UIColor(red:0.12, green:0.67, blue:0.95, alpha:1)
    var logoErrorTint: UIColor = UIColor.redColor()
   
    var instructions: UIColor = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1)
    var instructionsError: UIColor = UIColor.redColor()
    
    var background: UIColor = UIColor.whiteColor()
    var statusBar: LTPasscodeStatusBar = .Light
    
    var keyPadBackground: UIColor = UIColor.whiteColor()
    var keyPadBorder: UIColor = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1)
    
    var keyPadTouchBackground: UIColor = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1)
    var keyPadTouchBorder: UIColor = UIColor.whiteColor()
    
    var bubbleBackground: UIColor = UIColor.whiteColor()
    var bubbleColor: UIColor = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1)
    
    var bubbleActiveBackground: UIColor = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1)
    var bubbleActiveColor: UIColor = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1)
    
    var bubbleErrorBackground: UIColor = UIColor.redColor()
    var bubbleErrorColor: UIColor = UIColor.redColor()
}

protocol LTPasscodeDelegate {
    func passcodeGranted()
    func passcodeSet()
    func passcodeFailed(reason: LatchError)
    func passcodeCanceled()
}

#if COCOAPODS
let LTBundle = NSBundle(path: NSBundle.mainBundle().privateFrameworksPath!.stringByAppendingPathComponent("Latch.framework"))!
#else
let LTBundle = NSBundle.mainBundle()
#endif

class LTPasscode: UIViewController, LTPasscodeKeyDelegate {
    
    // MARK: Instance Enum
    enum State {
        case Check, Set, Inactive, UpdateCheck, UpdateSet
    }
    
    // MARK: Instance Variables
    var delegate: LTPasscodeDelegate!
    var parentController: UIViewController!
    var theme: LTPasscodeTheme!
  var enablePasscodeChange: Bool = false
    
    // MARK: Private Instance Variables
    private var storage: LTStorage! = LTStorage()
    private var state: State = .Inactive
    private var passcode: [String] = []
    private var previousPasscode: String = ""
  private var changeInstructions: String!
    private var instructions: String!
    private var keys: [LTPasscodeKey] = [
      LTPasscodeKey(number: 1, alpha: "", row: 0, column: 0),
      LTPasscodeKey(number: 2, alpha: "ABC", row: 0, column: 1),
      LTPasscodeKey(number: 3, alpha: "DEF", row: 0, column: 2),
      LTPasscodeKey(number: 4, alpha: "GHI", row: 1, column: 0),
      LTPasscodeKey(number: 5, alpha: "JKL", row: 1, column: 1),
      LTPasscodeKey(number: 6, alpha: "MNO", row: 1, column: 2),
      LTPasscodeKey(number: 7, alpha: "PQRS", row: 2, column: 0),
      LTPasscodeKey(number: 8, alpha: "TUV", row: 2, column: 1),
      LTPasscodeKey(number: 9, alpha: "WXYZ", row: 2, column: 2),
      LTPasscodeKey(number: 0, alpha: nil, row: 3, column: 1),
      LTPasscodeKey(number: -2, alpha: nil, row: 3, column: 0),
      LTPasscodeKey(number: -1, alpha: nil, row: 3, column: 2)
    ]
    private var bubbles: [LTPasscodeBubble] = [
        LTPasscodeBubble(number: 0),
        LTPasscodeBubble(number: 1),
        LTPasscodeBubble(number: 2),
        LTPasscodeBubble(number: 3)
    ]
    
    // MARK: IBOutlets
  
  @IBOutlet weak private var logoImageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var keysView: UIView!
    @IBOutlet weak var bubblesView: UIView!
    
    // MARK: Initializer
  convenience init(instructions: String, changeInstructions: String) {
    self.init(nibName: "LTPasscode", bundle: LTBundle)
    self.instructions = instructions
    self.changeInstructions = changeInstructions
    self.updateStyle()
    if UIScreen.mainScreen().bounds.size.height < 568 {
      self.logoImageViewHeightLayoutConstraint.constant = 0
    } else {
      self.logoImageViewHeightLayoutConstraint.constant = 50
    }
  }
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
  override func shouldAutorotate() -> Bool {
    return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
  }
  
  override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
    if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
      return UIApplication.sharedApplication().statusBarOrientation
    } else {
      return UIInterfaceOrientation.Portrait
    }
  }
  
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update Instructions Label
        self.instructionsLabel.text = self.instructions
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Create Bubbles
        self.configureBubbles()
        
        // Create Keys
        self.configureKeys()
    }
  
    // MARK: Instance Methods
  func setDefaultPasscode(passcodeString: String) {
    if self.storage.readPasscode() == nil {
      self.storage.savePasscode(passcodeString)
    }
  }
    func authorize() {
        if self.storage.readPasscode() != nil {
            self.state = .Check
            self.parentController!.presentViewController(self, animated: true, completion: nil)
        } else {
            self.delegate.passcodeFailed(LatchError.PasscodeNotSet)
        }
    }
    
    func setPasscode() {
        self.state = .Set
        self.parentController!.presentViewController(self, animated: true, completion: nil)
    }
    
    func dismiss() {
        if self.state != .Inactive {
            for bubble in self.bubbles {
                bubble.state = .Normal
                bubble.updateStyle()
            }
            
            self.passcode.removeAll(keepCapacity: false)
            self.previousPasscode = ""
            self.state = .Inactive
            self.parentController!.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    internal func granted() {
        if self.state == .Check {
            self.delegate.passcodeGranted()
        } else {
            self.delegate.passcodeSet()
        }
        
        self.dismiss()
    }
    
    internal func configureBubbles() {
        for bubble in self.bubbles {
            bubble.state = .Normal
            bubble.parentView = self.bubblesView
            
            bubble.border = self.theme.bubbleColor
            bubble.background = self.theme.bubbleBackground
            
            bubble.borderActive = self.theme.bubbleActiveColor
            bubble.backgroundActive = self.theme.bubbleActiveBackground
            
            bubble.borderError = self.theme.bubbleErrorColor
            bubble.backgroundError = self.theme.bubbleErrorBackground
            
            bubble.configureBubble()
            self.bubblesView.addSubview(bubble)
        }
    }
    
    internal func configureKeys() {
        for key in self.keys {
            key.delegate = self
            key.parentView = self.keysView
            
            key.border = self.theme.keyPadBorder
            key.background = self.theme.keyPadBackground
            
            key.borderTouch = self.theme.keyPadTouchBorder
            key.backgroundTouch = self.theme.keyPadTouchBackground
          
          if key.number == -1 {
            if self.state == .Set {
              key.numberLabel.text = NSLocalizedString("Cancel", bundle: LTBundle, comment: "")
            } else {
              key.numberLabel.text = NSLocalizedString("Delete", bundle: LTBundle, comment: "")
            }
          } else if key.number == -2 {
            switch self.state {
            case .Check:
              if self.storage.readPasscode() != nil {
                key.numberLabel.text = NSLocalizedString("Change Passcode", bundle: LTBundle, comment: "")
              } else {
                key.numberLabel.text = NSLocalizedString("", bundle: LTBundle, comment: "")
              }
            case .UpdateCheck:
              key.numberLabel.text = NSLocalizedString("Cancel", bundle: LTBundle, comment: "")
            default:
              key.numberLabel.text = NSLocalizedString("", bundle: LTBundle, comment: "")
            }
          }
            
            key.configureKey()
            self.keysView.addSubview(key)
        }
    }
    
    internal func updateStyle() {
        if self.theme == nil {
            self.theme = LTPasscodeTheme()
        }
        
        // Update Controller View
        self.view.backgroundColor = self.theme.background
        
        // Update Instructions Label
        self.instructionsLabel.textColor = self.theme.instructions
        
        // Update Logo View
        if self.theme.logoTint != nil {
            self.theme.logo = self.theme.logo.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.logoView.tintColor = self.theme.logoTint
        }
        
        self.logoView.image = self.theme.logo
    }
    
    internal func failedPasscode() {
        self.logoView.tintColor = self.theme.logoErrorTint
        self.instructionsLabel.textColor = self.theme.instructionsError
        
        for bubble in self.bubbles {
            bubble.state = .Error
            bubble.updateStyle()
        }
        
        var animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.autoreverses = true
        animation.repeatCount = 2
        animation.duration = 0.07
        animation.values = [NSNumber(float: -10), NSNumber(float: 10)]
        self.bubblesView.layer.addAnimation(animation, forKey: nil)
        
        AudioServicesPlaySystemSound(1352)
        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("updateStyle"), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("configureBubbles"), userInfo: nil, repeats: false)
    }
    
    internal func checkPasscode() {
        var passcodeString = ""
        
        for character in self.passcode {
            passcodeString += character
        }
        
        self.passcode.removeAll(keepCapacity: false)
        
        if passcodeString == self.storage.readPasscode() {
          if self.state == .UpdateCheck {
            self.state = .UpdateSet
            self.updateStyle()
            self.passcode.removeAll(keepCapacity: false)
            self.previousPasscode = ""
            self.configureBubbles()
            self.configureKeys()
            let originalInstructionsLabelFrame = self.instructionsLabel.frame
            let originalBubbleFrame = self.bubblesView.frame
            let screenWidth = UIScreen.mainScreen().bounds.size.width
            
            UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
              
              self.instructionsLabel.frame.origin.x = -screenWidth
              self.bubblesView.frame.origin.x = -screenWidth
              
              }, completion: { finished in
                
                self.instructionsLabel.text = NSLocalizedString("Enter your new passcode", bundle: LTBundle, comment: "")
                self.instructionsLabel.frame.origin.x = screenWidth
                self.bubblesView.frame.origin.x = screenWidth
                for bubble in self.bubbles {
                  bubble.state = .Normal
                  bubble.updateStyle()
                }
                
                UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                  self.instructionsLabel.frame = originalInstructionsLabelFrame
                  self.bubblesView.frame = originalBubbleFrame
                  }, completion: nil)
                
            })
          } else {
            NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("granted"), userInfo: nil, repeats: false)
          }
        } else {
            self.failedPasscode()
        }
    }
    
    internal func storePasscode() {
        var passcodeString = ""
        
        for character in self.passcode {
            passcodeString += character
        }
        
        self.passcode.removeAll(keepCapacity: false)
        
        if self.previousPasscode.isEmpty {
            self.previousPasscode = passcodeString
          
          let originalInstructionsLabelFrame = self.instructionsLabel.frame
          let originalBubbleFrame = self.bubblesView.frame
          let screenWidth = UIScreen.mainScreen().bounds.size.width
          
          UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.instructionsLabel.frame.origin.x = -screenWidth
            self.bubblesView.frame.origin.x = -screenWidth
            
            }, completion: { finished in
              
              self.instructionsLabel.text = NSLocalizedString("Confirm Passcode", bundle: LTBundle, comment: "")
              self.instructionsLabel.frame.origin.x = screenWidth
              self.bubblesView.frame.origin.x = screenWidth
              for bubble in self.bubbles {
                bubble.state = .Normal
                bubble.updateStyle()
              }
              
              UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.instructionsLabel.frame = originalInstructionsLabelFrame
                self.bubblesView.frame = originalBubbleFrame
                }, completion: nil)
              
          })
          
        } else if self.previousPasscode == passcodeString {
            self.storage.savePasscode(passcodeString)
            self.granted()
        } else {
            self.failedPasscode()
        }
    }
    
    // MARK: LTPasscodeKey Delegate Methods
    internal func keyPressed(number: Int) {
      if number == -2 {
        if self.state == .Check {
          self.state = .UpdateCheck
          self.instructionsLabel.text = self.changeInstructions
        } else {
          self.state = .Check
          self.instructionsLabel.text = self.instructions
        }
        self.passcode.removeAll(keepCapacity: false)
        self.previousPasscode = ""
        self.updateStyle()
        self.configureBubbles()
        self.configureKeys()
        return
      }
        if number < 0 && self.passcode.count == 0 && self.state == .Set {
            self.dismiss()
            self.delegate.passcodeCanceled()
            return
        }
        
        if number >= 0 {
            self.passcode.append("\(number)")
        } else if self.passcode.count > 0 {
            self.passcode.removeLast()
        }
        
        for (index, bubble) in enumerate(self.bubbles) {
            if index <= self.passcode.count - 1 {
                bubble.state = .Active
            } else {
                bubble.state = .Normal
            }
            
            bubble.updateStyle()
        }
        
        if self.passcode.count == 4 {
            if self.state == .Check || self.state == .UpdateCheck {
                self.checkPasscode()
            } else if self.state == .Set || self.state == .UpdateSet {
                self.storePasscode()
            }
        }
        
        if self.state == .Set {
            if self.passcode.count == 0 {
                self.keys.last?.numberLabel.text = NSLocalizedString("Cancel", bundle: LTBundle, comment: "")
            } else {
                self.keys.last?.numberLabel.text = NSLocalizedString("Delete", bundle: LTBundle, comment: "")
            }
        }
    }
}