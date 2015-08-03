//
//  ImagePostView.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/19/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa

class ImagePostView : PostView {
    @IBOutlet var photoView : NSImageView!
    
    init(frameRect: NSRect, options: PostViewOptions?) {
        super.init(frameRect: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
