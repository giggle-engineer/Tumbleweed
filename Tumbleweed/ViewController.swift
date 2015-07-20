//
//  ViewController.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/17/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Cocoa
import TMTumblrSDK
import SwiftyUserDefaults

class ViewController: NSViewController {
    @IBOutlet var tableView : NSTableView!
    @IBOutlet var dashboardDataSource : DashboardDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TMAPIClient.sharedInstance().OAuthConsumerKey = "***REMOVED***"
        TMAPIClient.sharedInstance().OAuthConsumerSecret = "***REMOVED***"
        if(Defaults["OAuthToken"].stringValue=="") {
            TMAPIClient.sharedInstance().authenticate("tumbleweed") { (NSError error) -> Void in
                if(error == nil) {
                    Defaults["OAuthToken"] = TMAPIClient.sharedInstance().OAuthToken
                    Defaults["OAuthTokenSecret"] = TMAPIClient.sharedInstance().OAuthTokenSecret
                }
                else {
                    NSLog("not authenticated")
                }
            }
        }
        else {
            print("already authenticated")
            TMAPIClient.sharedInstance().OAuthToken = Defaults["OAuthToken"].stringValue
            TMAPIClient.sharedInstance().OAuthTokenSecret = Defaults["OAuthTokenSecret"].stringValue
        }
        TMAPIClient.sharedInstance().dashboard(nil, callback: { (result : AnyObject!, error: NSError!) -> Void in
            if error == nil {
                let posts = (result as! NSDictionary)["posts"] as! NSArray
                self.dashboardDataSource.posts = posts
                self.tableView.reloadData()
                //            print("dashboard \(posts)")
                //            print("count: \(posts.count)")
                //            for post in posts {
                //                let type = post["type"]
                //                let note_count = post["note_count"]
                //                let liked = post["liked"]
                //                let source_title = post["source_title"]
                //                let
                //                print("boop \(post)")
                //            }
            }
        })
        
        TMAPIClient.sharedInstance().blogInfo("giggle-engineer") { (result: AnyObject!, error: NSError!) -> Void in
//            let posts = result as! NSDictionary
//            print("blog \(posts)")
//            print("count: \(posts.count)")
//            for post in posts {
//                let boop = post as! String
//                print("boop \(boop)")
//            }
        }

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

