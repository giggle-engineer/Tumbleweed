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
    @IBOutlet var noteCount : NSTextField!
    var postId : String!
    var reblogKey : String!
    
    @IBAction func likePost(sender: DOFavoriteButton)
    {
        let liked = !sender.selected
        
        if(liked) {
            TMAPIClient.sharedInstance().like(postId, reblogKey: reblogKey, callback: { (result : AnyObject!, error: NSError!)  -> Void in
                if(error == nil) {
                    sender.deselect()
                }
                else {
                    NSLog("Post was liked!")
                }
            })
        }
        else {
            NSLog("Post was unliked")
        }
    }
    
    @IBAction func reblogPost(sender: DOFavoriteButton)
    {
        let reblogged = !sender.selected
        
        if(reblogged) {
            NSLog("Post was reblogged!")
            // Do something here!
        }
        else {
            NSLog("Post was uhh, I dunno what to do here")
        }
    }
}