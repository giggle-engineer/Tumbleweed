//
//  DashboardDataSource.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/18/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa

class DashboardDataSource : NSObject, NSTableViewDataSource, NSTableViewDelegate {
    var postControllers = Array<PostController>()
    var posts : NSArray = [] {
        didSet {
            // Initialize View Controllers for each post type
            postControllers.reserveCapacity(posts.count)
            for i in 0...posts.count-1 {
                let type = posts.objectAtIndex(i)["type"] as! String
                switch type {
                    case "text":
                        postControllers.append(TextPostController())
                        break
                    case "photo":
                        postControllers.append(ImagePostController())
                        break
                    default:
                        postControllers.append(TextPostController())
                }
            }
            postControllers.append(ImagePostController())
        }
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        let type = posts.objectAtIndex(row)["type"] as! String
        let postView = tableView.makeViewWithIdentifier("photo", owner: self) as? PostView
//        print("row: \(row) type: \(type)")
//        let controller = postControllers[row] as PostController
        postControllers[row].post = posts[row] as? NSDictionary
        postControllers[row].view = postView
        return postView
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 300
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return posts.count
    }
    // makeViewWithIdentifier with different identifiers for different post types
}