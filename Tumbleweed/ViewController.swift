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

class ViewController: NSViewController, AutoloadingScrollViewDelegate {
    @IBOutlet var avatarView : NSImageView!
    @IBOutlet var tableView : NSTableView!
    @IBOutlet var dashboardDataSource : DashboardDataSource!
    @IBOutlet var scrollView : AutoloadingScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        TMAPIClient.sharedInstance().OAuthConsumerKey = OAuthConsumerKey
        TMAPIClient.sharedInstance().OAuthConsumerSecret = OAuthConsumerSecret
        if(Defaults["OAuthToken"].stringValue=="") {
            TMAPIClient.sharedInstance().authenticate("tumbleweed") { (NSError error) -> Void in
                if(error == nil) {
                    Defaults["OAuthToken"] = TMAPIClient.sharedInstance().OAuthToken
                    Defaults["OAuthTokenSecret"] = TMAPIClient.sharedInstance().OAuthTokenSecret
                }
                else {
                    NSLog("there was an error authenticating")
                }
            }
        }
        else {
            TMAPIClient.sharedInstance().OAuthToken = Defaults["OAuthToken"].stringValue
            TMAPIClient.sharedInstance().OAuthTokenSecret = Defaults["OAuthTokenSecret"].stringValue
        }
        self.loadDashboard()
        self.loadUserAvatar()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadDashboard", name: "refreshDashboard", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadOlder", name: "loadOlder", object: nil)
        NSTimer.scheduledTimerWithTimeInterval(60*5, target: self, selector: "loadDashboard", userInfo: nil, repeats: true)
    }
    
    func loadUserAvatar() {
        avatarView.wantsLayer = true
        avatarView.layer!.cornerRadius = 3.0
        avatarView.layer!.masksToBounds = true
        TMAPIClient.sharedInstance().userInfo { (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                let userInfo = result as! NSDictionary
                let user = userInfo["user"] as! NSDictionary
                let blogs = user["blogs"] as! NSArray
                for blog in blogs {
                    if blog["primary"] as? Int == 1 {
                        let name = blog["name"] as! String
                        TMAPIClient.sharedInstance().avatar(name, size: UInt(96), callback: { (result: AnyObject!, error: NSError!) -> Void in
                            if error == nil {
                                let avatarData = result as! NSData
                                self.avatarView.image = NSImage(data: avatarData)
                            }
                        })
                        break
                    }
                }
            }
        }
    }
    
    func loadDashboard() {
        // prevent from loading older posts and refreshing at the same time.. there's probably a better way.. like queueing these up
        scrollView.isLoading = true
        let parameters = ["limit":20, "reblog_info":"YES"]
        TMAPIClient.sharedInstance().dashboard(parameters, callback: { (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                let posts = (result as! NSDictionary)["posts"] as! NSArray
                self.dashboardDataSource.processNewPosts(Array(posts))
            }
            self.scrollView.isLoading = false
        })
    }
    
    func loadOlder() {
        let lastPostId = dashboardDataSource.posts[dashboardDataSource.posts.endIndex-1]["id"] as! Int
        let parameters : Array = ["before_id":lastPostId, "reblog_info":"YES"]
        print("last post id: \(lastPostId)")
        TMAPIClient.sharedInstance().dashboard(parameters, callback: {  (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                let posts = (result as! NSDictionary)["posts"] as! NSArray
                self.dashboardDataSource.processOldPosts(Array(posts))
            }
            // the scroll view will wait for this before autoloading again
            self.scrollView.isLoading = false
        })
    }
    
    @IBAction func refresh(sender: AnyObject) {
        self.loadDashboard()
    }
    
    // MARK: AutoloadingScrollViewDelegate
    
    func reachedEndOfRows() {
        self.loadOlder()
    }
    
    // MARK: -

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

