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
    var view : PostView! {
        didSet {
            self.fillContent()
        }
    }

    func fillContent() {
        if let blogName = post?["blog_name"] as? String {
            self.view.blogger.stringValue = blogName
            TMAPIClient.sharedInstance().avatar(blogName, size: 48) { (result: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    let image = NSImage(data: result as! NSData)
                    self.view.avatar.image = image
                    self.view.avatar.wantsLayer = true
                    self.view.avatar.layer!.cornerRadius = 3.0
                    self.view.avatar.layer!.masksToBounds = true
                }
                else {
                    print("error: \(error.description)")
                }
            }
        }
        if let count = post?["note_countt"] as? Int {
            self.view.noteCount.stringValue = "\(count) notes"
        }
        if let id = post?["id"] as? Int {
            self.view.postId = String(id)
        }
        if let liked = post?["liked"] as? Bool {
            self.view.favoriteButton.selected = liked
        }
        if let reblogKey = post?["reblog_key"] as? String {
            self.view.reblogKey = reblogKey
        }
        if let sourceTitle = post?["source_title"] as? String {
            self.view.reblogedFrom.stringValue = sourceTitle
            self.view.reblog.hidden = false
            self.view.reblogedFrom.hidden = false
        }
        else {
            self.view.reblogedFrom.stringValue = ""
            self.view.reblog.hidden = true
            self.view.reblogedFrom.hidden = true
        }
    }
}