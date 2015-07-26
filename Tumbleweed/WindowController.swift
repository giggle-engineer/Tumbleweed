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
    @IBOutlet var titleBarView : NSView!
    override func windowWillLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleReopen", name: "handleReopen", object: nil)
    }
    
    override func awakeFromNib() {
        let window = self.window as! INAppStoreWindow
        window.trafficLightButtonsLeftMargin = 14.0
        window.titleBarHeight = 33.0
        
        self.titleBarView.frame = window.titleBarView.bounds
        self.titleBarView.autoresizingMask  = [NSAutoresizingMaskOptions.ViewWidthSizable, NSAutoresizingMaskOptions.ViewHeightSizable]
        window.titleBarView.addSubview(self.titleBarView)
    }
    
    func handleReopen() {
        self.showWindow(nil)
    }
}
