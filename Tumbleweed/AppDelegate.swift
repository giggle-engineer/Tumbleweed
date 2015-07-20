//
//  AppDelegate.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/17/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa
import TMTumblrSDK

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func applicationWillFinishLaunching(notification: NSNotification) {
        let appleEventManger = NSAppleEventManager.sharedAppleEventManager()
        appleEventManger.setEventHandler(self, andSelector: "handleURLEvent:withReplyEvent:", forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    func handleURLEvent(event : NSAppleEventDescriptor, withReplyEvent replyEvent : NSAppleEventDescriptor) {
        let calledURL = event.paramDescriptorForKeyword(AEKeyword(keyDirectObject))?.stringValue
        TMAPIClient.sharedInstance().handleOpenURL(NSURL(string: calledURL!))
    }
    
    @IBAction func refreshDashboard(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("refreshDashboard", object: self)
    }
}

