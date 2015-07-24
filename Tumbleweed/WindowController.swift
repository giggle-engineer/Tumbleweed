//
//  WindowController.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/22/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa

class WindowController : NSWindowController {
    override func windowWillLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleReopen", name: "handleReopen", object: nil)
    }
    
    func handleReopen() {
        self.showWindow(nil)
    }
}
