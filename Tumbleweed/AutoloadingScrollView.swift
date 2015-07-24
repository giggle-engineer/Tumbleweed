//
//  AutoloadingScrollView.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/23/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa

protocol AutoloadingScrollViewDelegate {
    func reachedEndOfRows()
}

class AutoloadingScrollView : NSScrollView {
    var delegate : AutoloadingScrollViewDelegate?
    var isLoading = false
    override func scrollWheel(theEvent: NSEvent) {
        super.scrollWheel(theEvent)
        if let tableView = self.documentView as? NSTableView {
            let range = tableView.rowsInRect(self.contentView.visibleRect)
            if(range.location+range.length >= tableView.numberOfRows) {
                if !isLoading {
                    NSLog("we should start autoloading!!")
                    isLoading = true
                    delegate?.reachedEndOfRows()
                }
            }
        }
    }
}