//
//  WindowController.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/22/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa
import INAppStoreWindow

class WindowController : NSWindowController {
    @IBOutlet var appWindow : INAppStoreWindow!
    @IBOutlet var titleBarView : NSView!
    override func windowWillLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleReopen", name: "handleReopen", object: nil)
        
        //        let appWindow = self.window as! INAppStoreWindow
        appWindow.trafficLightButtonsLeftMargin = 14.0
        appWindow.titleBarHeight = 33.0
        
        self.titleBarView.frame = appWindow.titleBarView.bounds
        self.titleBarView.autoresizingMask  = [NSAutoresizingMaskOptions.ViewWidthSizable, NSAutoresizingMaskOptions.ViewHeightSizable]
        appWindow.titleBarView.addSubview(self.titleBarView)
    }
    
    func handleReopen() {
        self.showWindow(nil)
    }
}
