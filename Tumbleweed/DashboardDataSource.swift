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
            case "chat":
                return TextPostController()
            case "text":
                return TextPostController()
            case "photo":
                return ImagePostController()
            case "video":
                return VideoPostController()
            default:
                return ImagePostController()
        }
    }
    
    var postControllers = Array<PostController>()
    var posts : Array<AnyObject> = []
    
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
            newPostIndex = newPosts.count-1
        }
        
        // we're adding to what we have
        if posts.count > 0 && newPostIndex > 0 {
            print("new posts")
            posts = newPosts[0...(newPostIndex-1)] + posts
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
        tableView.insertRowsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(0, newPostIndex)), withAnimation: .SlideDown)
    }
    
    func processOldPosts(oldPosts : Array<AnyObject>) {
        let range = NSMakeRange(posts.count-1, oldPosts.count)
        var newPostControllers = Array<PostController>()
        for post in oldPosts {
            let type = post["type"] as! String
            newPostControllers.append(postControllerForType(type))
        }
        
        postControllers = postControllers + newPostControllers
        posts = posts + oldPosts
        tableView.insertRowsAtIndexes(NSIndexSet(indexesInRange: range), withAnimation: .SlideUp)
    }
    
    func typeForRow(row: Int) -> String {
        return posts[row]["type"] as! String
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let id = posts[tableView.selectedRow]["id"] as! Int
        print("post: \(posts[tableView.selectedRow])")
        print("type of post: \(typeForRow(tableView.selectedRow)) id:\(id)")
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var postView : PostView!
        let type = typeForRow(row)
        switch(type) {
            case "audio":
                postView = tableView.makeViewWithIdentifier("audio", owner: self) as? PostView
                break
            case "chat":
                postView = tableView.makeViewWithIdentifier("text", owner: self) as? PostView
                break
            case "quote":
                postView = tableView.makeViewWithIdentifier("text", owner: self) as? PostView
                break
            case "text":
                postView = tableView.makeViewWithIdentifier("text", owner: self) as? PostView
                break
            case "photo":
                postView = tableView.makeViewWithIdentifier("photo", owner: self) as? PostView
                break
            case "video":
                postView = tableView.makeViewWithIdentifier("video", owner: self) as? PostView
            default:
                print("type: \(type) at row: \(row)")
                postView = tableView.makeViewWithIdentifier("photo", owner: self) as? PostView
        }
        postControllers[row].post = posts[row] as? NSDictionary
        postControllers[row].view = postView
        return postView
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        switch(typeForRow(row))
        {
            case "audio":
                return 172
            case "chat":
                let body = posts[row]["body"] as! String
                if let attributedString = NSMutableAttributedString(HTML: body.dataUsingEncoding(NSUTF8StringEncoding)!, documentAttributes: nil) {
                    attributedString.addAttribute(NSFontAttributeName, value: NSFont.systemFontOfSize(14.0), range: NSRange(location:0,length:attributedString.length))
                    let heightOfText = attributedString.heightForWidth(260)
                    return heightOfText+62
                }
                return 10
//            case "quote":
//                continue
            case "text":
                let body = posts[row]["body"] as! String
                if let attributedString = NSMutableAttributedString(HTML: body.dataUsingEncoding(NSUTF8StringEncoding)!, documentAttributes: nil) {
                    attributedString.addAttribute(NSFontAttributeName, value: NSFont.systemFontOfSize(14.0), range: NSRange(location:0,length:attributedString.length))
                    let heightOfText = attributedString.heightForWidth(260)
                    return heightOfText+62
                }
                return 10
//                return 62 + height of text
            default:
                return 300
        }
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return posts.count
    }
}