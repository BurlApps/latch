Latch
=====

Easily use Passcode and Touch ID authentication!

Install
========

1. Copy `Framework` folder into your project
2. Change `Latch.LTPasscode.xib` to `<module>.LTPasscode.xib`

Configure
==========

1. Create Latch in View Controller
``` swift
self.latch = Latch()
self.latch.delegate = self
self.latch.parentController = self
```

2. Customize Theme (Optional)
``` swift
self.latch.passcodeTheme.logo = UIImage(named: "Logo")!
self.latch.passcodeTheme.logoTint = nil
self.latch.passcodeTheme.instructions = UIColor(red:0.96, green:0.33, blue:0.24, alpha:1)
self.latch.passcodeTheme.bubbleColor = UIColor(red:0.96, green:0.33, blue:0.24, alpha:1)
self.latch.passcodeTheme.bubbleActiveColor = UIColor(red:0.96, green:0.33, blue:0.24, alpha:1)
self.latch.passcodeTheme.bubbleActiveBackground = UIColor(red:0.96, green:0.33, blue:0.24, alpha:1)
self.latch.passcodeTheme.keyPadBorder = UIColor(red:0.96, green:0.33, blue:0.24, alpha:1)
self.latch.passcodeTheme.keyPadTouchBorder = UIColor(red:0.96, green:0.33, blue:0.24, alpha:1)
self.latch.passcodeTheme.keyPadTouchBackground = UIColor(red:0.96, green:0.33, blue:0.24, alpha:1)
```

3. Turn On/Off Touch ID & Passcode (Optional)
``` swift
self.latch.enableTouch = true // True by default 
self.latch.enablePasscode = true // True by default 
```

Useage
========

Set Passcode: `self.latch.updatePasscode()`
Remove Passcode: `self.latch.removePasscode()`
Authorize User: `self.latch.authorize()`

Thanks for looking at our small docs. Please use carefully, this was built in less than 12 hours and is no where near perfect. Thanks:)
