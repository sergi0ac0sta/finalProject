//
//  ExtensionDelegate.swift
//  FinalProjectWatch Extension
//
//  Created by Sergio Acosta on 11/07/16.
//  Copyright © 2016 Sergio Acosta. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    func applicationDidFinishLaunching() {
    }

    func applicationDidBecomeActive() {
        print("Active")
    }

    func applicationWillResignActive() {
        print("resign active")
    }
}
