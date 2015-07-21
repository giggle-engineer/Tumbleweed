//
//  AudioPostController.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/20/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa
import TMCache

class AudioPostController : PostController {
    override func fillContent() {
        super.fillContent()
        if post?["player"] == nil {
            // I just, I don't know what to say here, this actually happens
            return
        }
        let player = post?["player"] as! String
        let audioView = self.view as! AudioPostView
        audioView.webView?.mainFrame.loadHTMLString(player, baseURL: nil)
        if post?["track_name"] != nil {
            audioView.trackName?.stringValue = post?["track_name"] as! String
        }
        else {
            audioView.trackName?.hidden = true
        }
        if post?["album_name"] != nil {
            audioView.albumName?.stringValue = post?["album_name"] as! String
        }
        else {
            audioView.albumName?.hidden = true
        }
        
        
        if post?["album_art"] != nil {
            let url = post?["album_art"] as! String
            TMCache.sharedCache().objectForKey(url, block: { (cache: TMCache!, key:String!, object:AnyObject!) -> Void in
                let audioPostView = self.view as! AudioPostView
                audioPostView.artworkView?.image = nil
                if object == nil {
                    let session = NSURLSession.sharedSession()
                    let dataTask = session.dataTaskWithURL(NSURL(string: url)!, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                        if error == nil {
                            let image = NSImage(data: data!)
                            
                            TMCache.sharedCache().setObject(image, forKey: url, block: { (cache: TMCache!, key: String!, object: AnyObject!) -> Void in })
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                audioPostView.artworkView?.image = image
                            })
                        }
                        else {
                            print("image error: \(error!.description)")
                        }
                    })
                    dataTask?.resume()
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        audioPostView.artworkView?.image = object as? NSImage
                    })
                }
            })
        }
    }
}
