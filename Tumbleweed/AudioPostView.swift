//
//  AudioPostView.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/20/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa
import WebKit

class AudioPostView : PostView {
    @IBOutlet var webView : WebView?
    @IBOutlet var artworkView : NSImageView?
    @IBOutlet var trackName : NSTextField?
    @IBOutlet var albumName : NSTextField?
}
