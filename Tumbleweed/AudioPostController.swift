//
//  AudioPostController.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/20/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa
import TMCache
import AVKit
import AVFoundation

class AudioPostController : PostController {
    private var kvoContext: UInt8 = 1
    var player : AVPlayer?
    
    func togglePlayer() {
        if player!.rate == 0 {
            player!.play()
        } else {
            player!.pause()
        }
    }
    
    func restartPlayer(note: NSNotification) {
        self.player?.seekToTime(CMTimeMakeWithSeconds(0, 5))
    }
    
    func checkPlayer() {
        guard let previousPlayer = UserInfo.sharedUserInfo.currentPlayer else {
            UserInfo.sharedUserInfo.currentPlayer = self.player
            return
        }
        if previousPlayer != player {
            previousPlayer.pause()
            UserInfo.sharedUserInfo.currentPlayer = self.player
        }
    }
    
    override func fillContent() {
        super.fillContent()
        if let audioView = self.view as? AudioPostView {
            // this is for reused views because KVO won't work there
            playPauseUpdate()
            
            if let audioUrl = post?["audio_url"] as? String {
                var url = NSURL(string: audioUrl)
                var playDirectly = true
                if let type = post?["audio_type"] as? String {
                    switch (type) {
                        case "tumblr":
                            // whoa, this output is actually inconsistent, the bogus ones are at tumblr.com
                            if url?.host == "www.tumblr.com" {
                                if let lastPathComponent = url?.lastPathComponent {
                                    url = NSURL(string: "https://a.tumblr.com/\(lastPathComponent)o1.mp3")
                                }
                            }
                            break
                        case "spotify":
                            playDirectly = false
                            break
                        default:
                            break
                    }
                }
                
                audioView.playPauseCallback =  { () in
                    if playDirectly {
                        if self.player == nil {
                            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                                self.player = AVPlayer(URL: url!)
                                self.player?.addObserver(self, forKeyPath: "rate", options: [.Initial, .New], context: &self.kvoContext)
                                NSNotificationCenter.defaultCenter().addObserver(self, selector: "restartPlayer:", name: AVPlayerItemDidPlayToEndTimeNotification, object: self.player?.currentItem)
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.togglePlayer()
                                })
                            }
                        }
                        else {
                            self.togglePlayer()
                        }
                    }
                    else {
                        NSWorkspace.sharedWorkspace().openURL(url!)
                    }
                }
            }
            
            if let trackName = post?["track_name"] as? String {
                audioView.trackName?.stringValue = trackName
            }
            else {
                audioView.trackName?.hidden = true
            }
            if let albumName = post?["album"] as? String {
                audioView.albumName?.stringValue = albumName
            }
            else {
                audioView.albumName?.stringValue = ""
                audioView.albumName?.hidden = true
            }
            
            
            if let url = post?["album_art"] as? String {
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
                        dataTask.resume()
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
    
    func playPauseUpdate() {
        if let audioView = self.view as? AudioPostView where self.player != nil {
            if self.player!.rate == 0 {
                audioView.playPauseButton.image = NSImage(named: "play")
            }
            else {
                checkPlayer()
                audioView.playPauseButton.image = NSImage(named: "pause")
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]!, context: UnsafeMutablePointer<Void>) {
        if context == &kvoContext {
            if keyPath == "rate" {
                self.playPauseUpdate()
            }
        }
    }
    
    deinit {
        self.player?.removeObserver(self, forKeyPath: "rate")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: self.player)
    }
}
