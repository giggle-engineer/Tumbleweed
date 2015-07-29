//
//  PostView.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/18/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa
import DOFavoriteButton
import TMTumblrSDK

class PostView : NSTableCellView {
    @IBOutlet var avatar : NSImageView!
    @IBOutlet var blogger : NSTextField!
    @IBOutlet var reblogedFrom : NSTextField!
    @IBOutlet var reblog : NSImageView!
    @IBOutlet var noteCount : NSTextField!
    @IBOutlet var favoriteButton : DOFavoriteButton!
    @IBOutlet var tags : NSTextField?
    var row : Int?
    var postId : String!
    var reblogKey : String!
    
    @IBAction func likePost(sender: DOFavoriteButton)
    {
        let liked = !sender.selected
        
        if(liked) {
            NSLog("postId:%@ reblogKey:%@", postId, reblogKey)
            TMAPIClient.sharedInstance().like(postId, reblogKey: reblogKey, callback: { (result : AnyObject!, error: NSError!)  -> Void in
                if error == nil {
                    NSLog("Post was liked!")
                }
                else {
                    NSLog("like error:%@", error.description)
                    sender.selected = false
                }
            })
        }
        else {
            TMAPIClient.sharedInstance().unlike(postId, reblogKey: "", callback: { (result: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    NSLog("Post was unliked.")
                }
                else {
                    NSLog("unlike error:%@", error.description)
                    sender.selected = true
                }
            })
            NSLog("Post was unliked")
        }
    }
    
    @IBAction func reblogPost(sender: DOFavoriteButton)
    {
        let reblogged = !sender.selected
        
        if(reblogged) {
            let controller = ReblogController(nibName: "ReblogPopover", bundle: nil)
            controller?.reblogKey = self.reblogKey
            controller?.postId = self.postId
            let popover = NSPopover()
            popover.behavior = .Transient
            popover.contentSize = NSSize(width: 361, height: 115)
            popover.contentViewController = controller
            popover.animates = true
            popover.showRelativeToRect(sender.bounds, ofView: sender, preferredEdge: .MaxX)
        }
        else {
            NSLog("Post was uhh, I dunno what to do here")
        }
    }
}