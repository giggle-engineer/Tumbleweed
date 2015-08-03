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

enum PostViewOptions {
    case None
    case Title
}

class PostView : NSTableCellView {
    var topBar : NSView!
    var bottomBar : NSView!
    
    var avatar : NSImageView!
    var blogger : NSTextField!
    var reblogedFrom : NSTextField!
    var reblog : NSImageView!
    var noteCount : NSTextField!
    var favoriteButton : DOFavoriteButton!
    var tags : NSTextField?
    var row : Int?
    var postId : String!
    var reblogKey : String!
    
    init(frameRect: NSRect) {
        super.init(frame: frameRect)
        
        NSLog("height:\(frameRect.width)")
        topBar = NSView(frame: NSRect(x: 0.0, y: 278-32, width: frameRect.width, height: 32.0))
        avatar = NSImageView(frame: NSRect(x: 7, y: 3, width: 24, height: 24))
        blogger = NSTextField(frame: NSRect(x: 33, y: 7, width: 37, height: 17))
        blogger.bordered = false
        blogger.drawsBackground = false
        reblog = NSImageView(frame: NSRect(x: 76, y: 6, width: 18, height: 18))
        reblogedFrom = NSTextField(frame: NSRect(x: 100, y: 7, width: 37, height: 17))
        reblogedFrom.bordered = false
        reblogedFrom.drawsBackground = true
        
        topBar.addSubview(avatar)
        topBar.addSubview(blogger)
        topBar.addSubview(reblog)
        topBar.addSubview(reblogedFrom)
        
        let avatarConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-(7)-[avatar]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["avatar":avatar])
        topBar.addConstraints(avatarConstraints)
        
        
        self.addSubview(topBar)
        let topBarConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[topBar]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["topBar":topBar])
        self.addConstraints(topBarConstraints)
        
        bottomBar = NSView(frame: NSRect(x: 0, y: 0, width: frameRect.width, height: 32))
        
        noteCount = NSTextField(frame: NSRect(x: 7, y: 7, width: 50, height: 17))
        noteCount.drawsBackground = false
        noteCount.bordered = false
        
        let reblogButton = DOFavoriteButton(frame: NSRect(x: 207, y: -4, width: 40, height: 40), image: NSImage(named: "reblog"))
        reblogButton.imageColorOn = NSColor(red: 45/255, green: 204/255, blue: 112/255, alpha: 1.0)
        reblogButton.circleColor = NSColor(red: 45/255, green: 204/255, blue: 112/255, alpha: 1.0)
        reblogButton.lineColor = NSColor(red: 45/255, green: 195/255, blue: 106/255, alpha: 1.0)
        
        favoriteButton = DOFavoriteButton(frame: NSRect(x: 240, y: -2, width: 35, height: 35), image: NSImage(named: "like"))
        favoriteButton.imageColorOn = NSColor(red: 254/255, green: 110/255, blue: 111/255, alpha: 1.0)
        favoriteButton.circleColor = NSColor(red: 254/255, green: 110/255, blue: 111/255, alpha: 1.0)
        favoriteButton.lineColor = NSColor(red: 226/255, green: 96/255, blue: 96/255, alpha: 1.0)
        
        bottomBar.addSubview(noteCount)
        bottomBar.addSubview(reblogButton)
        bottomBar.addSubview(favoriteButton)
        self.addSubview(bottomBar)
        
//        let bottomBarConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[bottomBar]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bottomBar":bottomBar])
//        self.addConstraints(bottomBarConstraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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