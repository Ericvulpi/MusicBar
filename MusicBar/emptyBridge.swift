//
//  Support.swift
//  Swift-AppleScriptObjC
//

import Cocoa

@objc(NSObject) protocol emptyBridge {

    var isRunning: NSNumber { get } // Bool
    
}

extension emptyBridge { // native Swift versions of the above ASOC APIs
    var isRunning: Bool { return self.isRunning.boolValue }
}
