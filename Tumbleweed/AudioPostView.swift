//
//  AudioPostView.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/20/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa

class AudioPostView : PostView {
    @IBOutlet var playPauseButton : NSButton!
    @IBOutlet var artworkView : NSImageView!
    @IBOutlet var trackName : NSTextField!
    @IBOutlet var albumName : NSTextField!
    
    var playPauseCallback: (() -> Void)!
    @IBAction func playPause(sender : NSButton) { playPauseCallback() }
}
