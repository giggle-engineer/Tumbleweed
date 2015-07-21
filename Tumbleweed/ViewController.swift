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
        self.loadDashboard()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadDashboard", name: "refreshDashboard", object: nil)
        NSTimer.scheduledTimerWithTimeInterval(60*5, target: self, selector: "loadDashboard", userInfo: nil, repeats: true)
    }
    
    func loadDashboard() {
        let parameters = ["limit":20]//["before_id":124634106921]//["since_id": "124627523585"] //["type":"audio"]
//        let parameters = ["before_id":124634106921]
        TMAPIClient.sharedInstance().dashboard(parameters, callback: { (result : AnyObject!, error: NSError!) -> Void in
            if error == nil {
                let posts = (result as! NSDictionary)["posts"] as! NSArray
//                self.dashboardDataSource.posts = Array(posts)
                self.dashboardDataSource.processNewPosts(Array(posts))
//                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func refresh (sender: AnyObject) {
        self.loadDashboard()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

