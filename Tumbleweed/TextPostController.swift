//
//  TextPostController.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/18/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa
import DCTextEngine

class TextPostController : PostController {
    private var body : NSString!
    override func fillContent() {
        super.fillContent()
        if (self.view is TextPostView) {
        }
        else {
            return
        }
        let textPostView = self.view as! TextPostView
        let body = post?["body"] as! NSString
//        detect format type
//        let engine = DCTextEngine.engineWithMarkdown()
//        let attributedString = engine.parse(body)
        let attributedString = NSMutableAttributedString(HTML: body.dataUsingEncoding(NSUnicodeStringEncoding)!, documentAttributes: nil)
        attributedString!.addAttribute(NSFontAttributeName, value: NSFont.systemFontOfSize(14.0), range: NSRange(location:0,length:attributedString!.length))
        textPostView.body?.textStorage?.appendAttributedString(attributedString!)
        
    }
    
//    func heightForBody() -> Int {
//        let attributedString = NSMutableAttributedString(HTML: body.dataUsingEncoding(NSUTF8StringEncoding)!, documentAttributes: nil)
//        attributedString!.addAttribute(NSFontAttributeName, value: NSFont.systemFontOfSize(14.0), range: NSRange(location:0,length:attributedString!.length))
////        attributedString.height
////        [attributedStatus heightForWidth:[[self window] frame].size.width-distanceToLeftSuperview-distanceToRightSuperview]
//    }
}
