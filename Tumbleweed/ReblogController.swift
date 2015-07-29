//
//  ReblogController.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/21/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa
import TMTumblrSDK

class ReblogController : NSViewController {
    @IBOutlet var tagsField : NSTokenField?
    @IBOutlet var commentsField : NSTextField?
    var postId : String?
    var reblogKey : String?
    
    @IBAction func reblog (sender: AnyObject) {
        
    }
}
