//
//  AppDelegate.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/17/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa
import PFAboutWindow
import TMTumblrSDK

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let aboutWindowController = PFAboutWindowController()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        self.handleReopen()
        return true;
    }
    
    func applicationWillFinishLaunching(notification: NSNotification) {
        let appleEventManger = NSAppleEventManager.sharedAppleEventManager()
        appleEventManger.setEventHandler(self, andSelector: "handleURLEvent:withReplyEvent:", forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        
        aboutWindowController.appURL = NSURL(string: "http://chloestars.me/apps/tumbleweed/")
    }
    
    func handleURLEvent(event : NSAppleEventDescriptor, withReplyEvent replyEvent : NSAppleEventDescriptor) {
        let calledURL = event.paramDescriptorForKeyword(AEKeyword(keyDirectObject))?.stringValue
        TMAPIClient.sharedInstance().handleOpenURL(NSURL(string: calledURL!))
    }
    
    func handleReopen() {
        NSNotificationCenter.defaultCenter().postNotificationName("handleReopen", object: self)
    }
    
    @IBAction func showAbout(sender: AnyObject) {
        aboutWindowController.showWindow(sender)
    }
    
    @IBAction func refreshDashboard(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("refreshDashboard", object: self)
    }
    
    @IBAction func loadOlder(sender: AnyObject)
    {
        NSNotificationCenter.defaultCenter().postNotificationName("loadOlder", object: self)
    }}

