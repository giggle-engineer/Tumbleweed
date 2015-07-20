//
//  DashboardDataSource.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/18/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa

class DashboardDataSource : NSObject, NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet var tableView : NSTableView!
    var postControllers = Array<PostController>()
    var posts : NSArray = [] {
        didSet {
            // Initialize View Controllers for each post type
            postControllers.reserveCapacity(posts.count)
            for i in 0...posts.count-1 {
                let type = posts.objectAtIndex(i)["type"] as! String
                switch type {
                    case "text":
                        postControllers.append(TextPostController(tableView: tableView))
                        break
                    case "photo":
                        postControllers.append(ImagePostController(tableView: tableView))
                        break
                    default:
                        postControllers.append(ImagePostController(tableView: tableView))
                }
                postControllers[i].row = i
            }
        }
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let type = posts.objectAtIndex(row)["type"] as! String
        var postView : PostView!
        switch(type) {
            case "text":
                postView = tableView.makeViewWithIdentifier("text", owner: self) as? PostView
                break
            case "photo":
                postView = tableView.makeViewWithIdentifier("photo", owner: self) as? PostView
                break
            default:
                print("type: \(type) at row: \(row)")
                postView = tableView.makeViewWithIdentifier("photo", owner: self) as? PostView
        }
//        postView.row = row
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