//
//  PostController.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/18/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa
import TMTumblrSDK

class PostController {
    var row : Int?
    var tableView : NSTableView?
    var post : NSDictionary?
    var view : PostView? {
        didSet {
            self.fillContent()
        }
    }
    
    init(tableView : NSTableView) {
        self.tableView = tableView
    }

    func fillContent() {
        let blogName = post?["blog_name"] as! String
        let id = post?["id"] as! Int
        let idString = String(id)
        let reblogKey = post?["reblog_key"] as! String
        let count = post?["note_count"] as! Int
        let liked = post?["liked"] as! Bool
        
        view?.favoriteButton.selected = liked
        view?.postId = idString
        view?.reblogKey = reblogKey
        view?.blogger.stringValue = blogName
        view?.noteCount.stringValue = "\(count) notes"
        if (post?["source_title"] != nil) {
            if(post?["source_title"] is String) {
                view?.reblogedFrom.stringValue = post?["source_title"] as! String
            }
        }
        
        TMAPIClient.sharedInstance().avatar(blogName, size: 48) { (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                let image = NSImage(data: result as! NSData)
                self.view?.avatar.image = image
                self.view?.avatar.wantsLayer = true
                self.view?.avatar.layer!.cornerRadius = 3.0
                self.view?.avatar.layer!.masksToBounds = true
            }
            else {
                print("error: \(error.description)")
            }
        }
    }
}