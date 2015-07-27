//
//  VideoPostController.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/26/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Foundation
import AVFoundation
import Regex

class VideoPostController : PostController {
    func getVineVideoFromPermalink(permalink : String) {
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithURL(NSURL(string: permalink)!, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error == nil {
                let page = NSString(data: data!, encoding:NSUTF8StringEncoding) as! String
                let result = page.grep("twitter:player:stream.*content=\"(.*)\"")
                print("capture:\(result.captures[1]) count: \(result.captures.count)")
                if result.captures.count > 1 {
                    self.loadVideo(result.captures[1])
                }
            }
            else {
                print("vine error: \(error!.description)")
            }
        })
        dataTask.resume()
    }
    
    func loadVideo(videoUrl: String) {
        let url = NSURL(string: videoUrl)
        if url != nil {
            if let postView = self.view as? VideoPostView {
                let player = AVPlayer(URL: url!)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    postView.playerView.player = player
                })
            }
        }
    }
    
    override func fillContent() {
        super.fillContent()
        
        if let type = post?["video_type"] as? String {
            switch type {
                case "vine":
                    // switching to async, we gotta grep the vine page for the url!
                    if let permalink = post?["permalink_url"] as? String {
                        self.getVineVideoFromPermalink(permalink) }
                    break
                default:
                    if let videoUrl = post?["video_url"] as? String {
                        self.loadVideo(videoUrl)
                    }
                    break
            }
        }
    }
}