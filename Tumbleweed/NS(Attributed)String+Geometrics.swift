//
//  NS(Attributed)String+Geometrics.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/21/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa

var gNSStringGeometricsTypesetterBehavior = NSTypesetterBehavior.LatestBehavior

extension NSAttributedString {
    func sizeForWidth(width: CGFloat, height: CGFloat) -> NSSize {
        var answer = NSZeroSize
        if self.length > 0 {
            let size = NSMakeSize(width, height)
            let textContainer = NSTextContainer(size: size)
            let textStorage = NSTextStorage(attributedString: self)
            let layoutManager = NSLayoutManager()
            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)
            layoutManager.hyphenationFactor = 0.0
            if gNSStringGeometricsTypesetterBehavior != NSTypesetterBehavior.LatestBehavior {
                layoutManager.typesetterBehavior = NSTypesetterBehavior.LatestBehavior
            }
            layoutManager.glyphRangeForTextContainer(textContainer)
            
            answer = layoutManager.usedRectForTextContainer(textContainer).size
            
            let extraLineSize = layoutManager.extraLineFragmentRect.size
            if extraLineSize.height > 0 {
                answer.height -= extraLineSize.height
            }
            
            gNSStringGeometricsTypesetterBehavior = NSTypesetterBehavior.LatestBehavior
        }
        
        return answer
    }
    
    func heightForWidth(width: CGFloat) -> CGFloat {
        return self.sizeForWidth(width, height: CGFloat(FLT_MAX)).height
    }
    
    func widthForHeight(height: CGFloat) -> CGFloat {
        return self.sizeForWidth(CGFloat(FLT_MAX), height: height).width
    }
}