Latch
=====

Easily use Passcode and Touch ID authentication!

Install
========

1) Copy `Framework` folder into your project

2) Change `Latch.LTPasscode.xib` to `<module>.LTPasscode.xib`

Configure
==========

1) Create Latch in View Controller 
``` swift
self.latch = Latch()
self.latch.delegate = self // Make sure to add LatchDelegate to Class
self.latch.parentController = self
```

2) Add Delegate Methods
``` swift
func latchGranted() {
    println("access granged")
}

func latchSet() {
    println("passcode set")
}

func latchDenied(reason: LatchError) {
    println(reason.hashValue)
}
```

3) Customize Messages (Optional)
``` swift
self.latch.touchReason = "We need to make sure it's you!"
self.latch.passcodeInstruction = "Enter Passcode"
```

4) Customize Theme (Optional)
``` swift
self.latch.passcodeTheme.logo = UIImage(named: "Logo")!
self.latch.passcodeTheme.logoTint = nil
self.latch.passcodeTheme.instructions = UIColor(red:0.96, green:0.33, blue:0.24, alpha:1)

//Passcode theme has these options
struct LTPasscodeTheme {
    var logo: UIImage = UIImage(named: "Latch")!
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
```

5) Turn On/Off Touch ID & Passcode (Optional)
``` swift
self.latch.enableTouch = true // True by default 
self.latch.enablePasscode = true // True by default 
```

Useage
========

**Set Passcode**: `self.latch.updatePasscode()`
**Remove Passcode**: `self.latch.removePasscode()`
**Authorize User**: `self.latch.authorize()`

Thanks for looking at our small docs. **Please use carefully, this was built in less than 12 hours and is no where near perfect.** Thanks:)
