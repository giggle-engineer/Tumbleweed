//
//  ImagePostController.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/18/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa
import TMCache

class ImagePostController : PostController {
    override func fillContent() {
        super.fillContent()
        let photos = post?["photos"] as! NSArray
        for photo in photos {
            let photo = photo as! NSDictionary
            let sizes = photo["alt_sizes"] as! NSArray
            let firstPhoto = sizes[0] as! NSDictionary
            let url = firstPhoto["url"] as! String
            
            TMCache.sharedCache().objectForKey(url, block: { (cache: TMCache!, key:String!, object:AnyObject!) -> Void in
                let imagePostView = self.view as! ImagePostView
                imagePostView.photoView?.animates = true
                if object == nil {
                    let session = NSURLSession.sharedSession()
                    let dataTask = session.dataTaskWithURL(NSURL(string: url)!, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                        if error == nil {
                            let image = NSImage(data: data!)
                            
                            TMCache.sharedCache().setObject(image, forKey: url, block: { (cache: TMCache!, key: String!, object: AnyObject!) -> Void in })
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                imagePostView.photoView?.image = image
                            })
                        }
                        else {
                            print("image error: \(error!.description)")
                        }
                    })
                    dataTask?.resume()
                }
                else {
                    print("loading from cache!")
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        imagePostView.photoView?.image = object as? NSImage
                    })
                }
            })
        }
//        print("filling content")
//        self.view?
//        self.view?.imageView?.image =
    }
}