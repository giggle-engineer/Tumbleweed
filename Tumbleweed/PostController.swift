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
    var post : NSDictionary?
    var view : PostView? {
        didSet {
            self.fillContent()
        }
    }

    func fillContent() {
//        print("filling default content for PostController")
        let blogName = post?["blog_name"] as! String
        let id = String(post?["id"])
        let reblogKey = String(post?["reblog_key"])
        let count = post?["note_count"] as! Int
        
        view?.postId = id
        view?.reblogKey = reblogKey
        view?.blogger.stringValue = blogName
        view?.noteCount.stringValue = "\(count) notes"
        if (post?["source_title"] != nil) {
            view?.reblogedFrom.stringValue = post?["source_title"] as! String
        }
        
        TMAPIClient.sharedInstance().avatar(blogName, size: 48) { (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                let image = NSImage(data: result as! NSData)
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                
                self.view?.avatar.image = image
//                })
            }
            else {
                print("error: \(error.description)")
            }
        }
    }
}