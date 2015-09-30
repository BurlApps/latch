//
//  LTStorage.swift
//  Latch
//
//  Created by Brian Vallelunga on 10/25/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

import Foundation

class LTStorage {
    
    // MARK: Private Instance Variables
    private var data: NSMutableArray!
    private var path: String!
    
    // MARK: Initializer Method
    init() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0)as! NSString
        self.path = documentsDirectory.stringByAppendingPathComponent("Latch.plist")
        
        let fileManager = NSFileManager.defaultManager()
        
        // Check if file exists
        if !fileManager.fileExistsAtPath(path)  {
            // If it doesn't, copy it from the default file in the Resources folder
//            let bundle = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
          // FIXME:
//            fileManager.copyItemAtPath(bundle!, toPath: self.path, error:nil)
        }
        
        self.data = NSMutableArray(contentsOfFile: path)
        
        if self.data == nil {
            self.data = NSMutableArray()
        }
    }
    
    // MARK: Instance Methods
    func readPasscode() -> String! {
        if self.data.count > 0 {
            return self.data.objectAtIndex(0) as? String
        } else {
            return nil
        }
    }
    
    func removePasscode() {
        self.data.removeAllObjects()
        self.data.writeToFile(self.path, atomically: true)
    }
    
    func savePasscode(passcode: String) {
        if self.data.count > 0 {
            self.data.replaceObjectAtIndex(0, withObject: passcode)
        } else {
            self.data.insertObject(passcode, atIndex: 0)
        }
        
        self.data.writeToFile(self.path, atomically: true)
    }
}