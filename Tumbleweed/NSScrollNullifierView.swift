//
//  NSScrollNullifierView.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/21/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa

class NSScrollNullifierView : NSScrollView {
    override func scrollWheel(theEvent: NSEvent) {
        self.nextResponder?.scrollWheel(theEvent)
    }
}
