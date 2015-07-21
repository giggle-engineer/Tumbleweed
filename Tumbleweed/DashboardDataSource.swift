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
    
    func postControllerForType(type: String) -> PostController {
        switch type {
            case "audio":
                return AudioPostController()
            case "text":
                return TextPostController()
            case "photo":
                return ImagePostController()
            default:
                return ImagePostController()
        }
    }
    
    var postControllers = Array<PostController>()
    var posts : Array<AnyObject> = [] /*{
        didSet {
            // Initialize View Controllers for each post type
            postControllers.removeAll()
            postControllers.reserveCapacity(posts.count)
            for i in 0...posts.count-1 {
                let type = posts[i]["type"] as! String
                postControllers.append(postControllerForType(type))
                postControllers[i].row = i
            }
        }
    }*/
    
    func processNewPosts(newPosts : Array<AnyObject>) {
        var postsInRange = false
        var newPostIndex = 0
        var newPostControllers = Array<PostController>()
        var mostRecentPostId : Int = 0
        
        if posts.count > 0 {
            mostRecentPostId = posts[0]["id"] as! Int
        }
        for (index,post) in newPosts.enumerate() {
            if post["id"] as! Int  == mostRecentPostId {
                postsInRange = true
                newPostIndex = index
                break
            }
            else {
                let type = post["type"] as! String
                newPostControllers.append(postControllerForType(type))
            }
        }
        
        if !postsInRange {
            // there was a gap in the new posts between now and what we have
            // we can do something like tweetbot and have a gap button
            newPostIndex = newPosts.count
        }
        
        // we're adding to what we have
        if posts.count > 0 && newPostIndex > 0 {
            print("new posts")
            posts = newPosts[0...newPostIndex] + posts
        }
        else {
            // we have no current posts but new posts, we're starting fresh
            if newPostControllers.count > 0 {
                print("loading from scratch")
                posts = newPosts
            }
            else {
                // nothing to do
                print("no new posts")
                return
            }
        }
        
        postControllers = newPostControllers + postControllers
        
        for (index,postController) in postControllers.enumerate() {
            if (postController is TextPostController) {
                print("TextPostController")
            }
            if (postController is ImagePostController) {
                print("ImagePostController")
            }
            if (postController is AudioPostController) {
                print("AudioPostController")
            }
            let type = posts[index]["type"] as! String
            print("for \(type)")
        }
        
        tableView.insertRowsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(0, newPostIndex)), withAnimation: .SlideDown)
    }
    
    func processOldPosts(oldPosts : Array<AnyObject>) {
        
    }

    func insertPostsAtEnd(newPosts : NSArray) {
        tableView.insertRowsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(self.posts.count, self.posts.count+newPosts.count)), withAnimation: .SlideRight)
    }
    
    func typeForRow(row: Int) -> String {
        return posts[row]["type"] as! String
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let id = posts[tableView.selectedRow]["id"] as! Int
        print("type of post: \(typeForRow(tableView.selectedRow)) id:\(id)")
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var postView : PostView!
        let type = typeForRow(row)
        switch(type) {
            case "audio":
                postView = tableView.makeViewWithIdentifier("audio", owner: self) as? PostView
                break
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
        switch(typeForRow(row))
        {
            case "audio":
                return 172
//            case "text":
//                let body = postControllers[row].post?["body"] as! String
//                let textPost = tableView.viewAtColumn(0, row: row, makeIfNecessary: true)
//                return 62 + height of text
            default:
                return 300
        }
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return posts.count
    }
    // makeViewWithIdentifier with different identifiers for different post types
}