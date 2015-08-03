//
//  VideoPostView.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/26/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa
import AVKit

class VideoPostView : PostView {
    @IBOutlet var playerView : AVPlayerView!
    
    init(frameRect: NSRect, options: PostViewOptions) {
        super.init(frameRect: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
